#--- Clear workspace
rm(list=ls())

# Opens up library necessary for the DBF read function
library('foreign')

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- 'W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/RiskFactors/tables'

#---Specify dbf file to open
filename <- 'RFbridgesAll.txt'
filenameslope <- 'W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/RiskFactors/shapefiles/SubBasins_Merge.dbf'

#---Write
output <- 'RFbridgesSlope.txt'

#========================================================#
#-------------------USER INPUT END-----------------------#
#========================================================#

# set the working directory
setwd(dir)

# read the dbf file
rf <- read.table(filename, header = TRUE, sep = '\t')
slope <- read.dbf(filenameslope)
colnames(rf)
colnames(slope)

joined <- merge(rf, slope, by.x = 'BIN', by.y = 'Name')
colnames(joined)

joined <- joined[,c(1:140, 143, 152, 153)]
head(joined)
colnames(joined)

write.dbf(joined, output)
write.table(joined, file = output, col.names=TRUE,row.names=FALSE, sep='\t')