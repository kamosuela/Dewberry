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
dbffile <- paste0(dir,'/RiskFactors/shapefiles/Bridges.dbf')
LLfile <- paste0(dir,'/SSURGO/data/Bridges_LL.txt')
bffile <- paste0(dir,'/StatisticalAnalysis/BankfullDischarge/BankfullReturn.txt')
fifile <- 

#---Specify name of output file
output <- "/RiskFactors/RFbridges.dbf"

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
head(RFbase)$DRW_max <- 0.03*RFbase$LL_max













# write file
write.dbf(RFbase,output)