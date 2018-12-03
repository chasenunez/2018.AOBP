#fixed mastif 04/06/18 fixed mastif 04.06.18
rm(list=ls())

load("~/Desktop/2018.AOBP.data")

library("mastif")
library("RcppArmadillo")
library("corrplot")
library("RANN")
library("Rcpp")
library("dplyr") 

#creating a loop over species
for(i in 1:length(common.spp.names.no.liana)){
  specNames <- seedNames <- common.spp.names.no.liana[i]
  treeData$plot <- as.numeric(treeData$plot)
  treeData.now <- subset(treeData, species == paste0(specNames))
  seedData$plot <- as.numeric(seedData$plot)
  seedData.now <- subset(seedData, plot %in% unique(treeData.now$plot))
  
  inputs   <- list( specNames = specNames, seedNames = seedNames, 
                    treeData = treeData.now, seedData = seedData.now, 
                    xytree = xytree, xytrap = xytrap, priorDist = 15, 
                    priorVDist = 100, minDist = 1, maxDist = 100, minDiam = 15,
                    maxDiam = 30)
  
  output <- mastif(formulaFec, formulaRep,  inputs = inputs, ng = 3000, burnin = 1000, yearEffect = yearEffect,randomEffect = randomEffect)
  predList <- list(mapMeters = 10, plots = c(1:30), years = c(2005:2007))
  output <- mastif(inputs = inputs, ng = 50000, burnin = 1000, predList = predList)
  save(output, file = paste0("~/Desktop/",seedNames,"_output.rdata"))
   plotPars <- list(SAVEPLOTS=T)
}

