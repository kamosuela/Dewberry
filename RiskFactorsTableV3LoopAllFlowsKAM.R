# RiskFactorTable.R
# Version = v0
#
# Prototype script that assembles relevant data for calculating overall debris risk:
# - Debris log length
# - Debris root mass diameter
# - Bankfull width and depth
# - Bankfull return period ("Flow Index")
# - Normalized projected flows (change in proj vs. norm)
# - Projected flows given 6 future flow scenarios
# - Normal flows
# 
# K. Mosuela, kmosuela@dewberry.com
# 9.21.2016



#--- Clear workspace
rm(list=ls())

# Opens up library necessary for the DBF read function
library('foreign')

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA"

#---Specify dbf file to open
dbffile <- file.path(dir,'RiskFactors/shapefiles/Bridges.dbf')
LLfile <- file.path(dir,'SSURGO/data/Bridges_LL.txt')
bffile <- file.path(dir,'StatisticalAnalysis/BankfullDischarge/BankfullReturn.txt')
nffile <- file.path(dir,'FLOW/FinalFlows/B_NormalFlows.txt')

#---Specify glob definitions (bridges vs. culverts)
projnormglob <- 'change_B_pr*'
projglob <- 'B_pr*'

#---Specify name of output file
output <- file.path(dir,'RiskFactors/RFbridges.dbf')
outputtxt <- file.path(dir,'RiskFactors/RFbridges.txt')

#========================================================#
#-------------------USER INPUT END-----------------------#
#========================================================#

# set the working directory
setwd(dir)

# read the dbf file
dbf <- read.dbf(dbffile)
RFbase <- as.data.frame(dbf$BIN)
colnames(RFbase) <- 'BIN'

# grab the LL data
LL <- read.csv(LLfile, header=TRUE, sep='\t')

# join the LL data
join <- merge(RFbase, LL, by.x = 'BIN', by.y = 'Name')
list <- c('BIN','LL_avg','LL_max','LL_min')
RFbase <- join[,c(list)]

# grab the bankfull
bf <- read.csv(bffile, header=TRUE, sep='\t')
join <- merge(RFbase, bf, by = 'BIN')
list <- c(list, 'Width', 'Depth', 'Return_cfs')
RFbase <- join[,c(list)]

# Some column renaming
ind <- grep('Return_cfs', colnames(RFbase))
colnames(RFbase)[ind] <- 'FI'

# calculate the DRW
RFbase$DRW_avg <- 0.03*RFbase$LL_avg
RFbase$DRW_min <- 0.03*RFbase$LL_min
RFbase$DRW_max <- 0.03*RFbase$LL_max
list <- c(list, 'DRW_avg', 'DRW_min', 'DRW_max')

# looping through the normalized projected flow files
filelist <- list.files(path = 'W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/StatisticalAnalysis/NormalizedProjectedFlow')
filelist <- filelist[grep(glob2rx(projnormglob), filelist)]

n <- length(filelist)

for (i in 1:n){
  k <- filelist[i]
  namescenario <- strsplit(filelist[i],'[.]')[[1]][1]
  subdir <- 'W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/StatisticalAnalysis/NormalizedProjectedFlow'
  changedata <- read.csv(file.path(subdir,k), header=TRUE, sep='\t')
  namecols <- colnames(changedata)
  nameflows <- NULL
  m <- length(namecols)
  for (j in 1:m){
    renamed <- paste0(namescenario,'_',namecols[j])
    nameflows <- c(nameflows,renamed)
  }
  nameflows -> colnames(changedata)
  ykey <- colnames(changedata)[1]
  join <- merge(RFbase, changedata, by.x = 'BIN', by.y = ykey)
  list <- c(list, nameflows[2:11])
  RFbase <- join
}
  
# looping through the projected flow files
filelistP <- list.files(path = 'W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/FLOW/FinalFlows')
filelistP <- filelistP[grep(glob2rx(projglob), filelistP)]

a <- length(filelistP)

for (f in 1:a){
  g <- filelistP[f]
  namescenario <- strsplit(filelistP[f],'[.]')[[1]][1]
  subdir <- 'W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/FLOW/FinalFlows'
  changedata <- read.csv(file.path(subdir,g), header=TRUE, sep=' ')
  namecols <- colnames(changedata)
  nameflows <- NULL
  b <- length(namecols)
  for (h in 1:b){
    renamed <- paste0('Proj_',namescenario,'_',namecols[h])
    nameflows <- c(nameflows,renamed)
  }
  nameflows -> colnames(changedata)
  ykey <- colnames(changedata)[1]
  join <- merge(RFbase, changedata, by.x = 'BIN', by.y = ykey)
  list <- c(list, nameflows[2:11])
  RFbase <- join
}

# grabbing normal flow
nf <- read.csv(nffile, header=TRUE, sep='\t')
nameflows <- colnames(nf)
join <- merge(RFbase, nf, by.x = 'BIN', by.y = 'Name')
list <- c(list, nameflows[2:11])
RFbase <- join

head(RFbase)


# write file
write.dbf(RFbase,output)
write.table(RFbase,file = outputtxt, col.names = TRUE, row.names = FALSE, sep = '\t')