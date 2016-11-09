#--- Clear workspace
rm(list=ls())

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
savedir <- "W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/StatisticalAnalysis/BankfullDischarge"

#---Specify the data set directories
dirdirty <- savedir
dirclean <- "W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/FLOW/FinalFlows"

#---Specify the data sets and column by which to merge
dirtydata <- 'BankfullReturn.txt'
  dirtykey <- 'BIN'
cleandata <- 'B_pr45_25_49.txt'
  cleankey <- 'Name'

#---Specify name of output file
outputname <- "BankfullClipped.txt"

#========================================================#
#------------------END USER INPUT------------------------#
#========================================================#

setwd(savedir)

dirtypath <- file.path(dirdirty,dirtydata)
cleanpath <- file.path(dirclean,cleandata)

dirty <- read.table(dirtypath,header=TRUE,sep="\t")
cleantocut <- read.table(cleanpath, header=TRUE,sep="")
  clean <- as.data.frame(cleantocut$Name)
  colnames(clean) <- cleankey
  
join <- merge(x = clean, y = dirty, by.x = cleankey, by.y = dirtykey, all.x = FALSE)

write.table(join,file=outputname,col.names=TRUE,row.names=FALSE,sep='\t')