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
filename <- 'RFbridgesSlope.dbf'

#---Write
output <- 'RFbridgesSlope.txt'

#========================================================#
#-------------------USER INPUT END-----------------------#
#========================================================#

# set the working directory
setwd(dir)

# read the dbf file
dbf <- read.dbf(filename)
head(dbf)
colnames(dbf)


write.dbf(dbf, filename)
write.table(dbf, file = output, sep = '\t')