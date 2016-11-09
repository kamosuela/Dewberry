# SSURGO_LL_Merge.R
# Version = v0
#
# Merges Average Log Lengths with bridge data based on SSURGO soil types.
# 
# K. Mosuela, kmosuela@dewberry.com
# 09.07.2016


#--- Clear workspace
rm(list=ls())

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/SSURGO/data"

#---Specify the data set
BINfile <- "Bridge_KeyPairs.txt" #Name column is BIN, Key is soil type
LLfile <- "SSURGO-LL_maxminavg.txt" #Name is soil type

#---Specify name of output file
output <- "Bridges_LL.txt"

#========================================================#
#------------------END USER INPUT------------------------#
#========================================================#

setwd(dir)

# read file
BIN <- read.csv(BINfile, header=TRUE, sep=',')
LL <- read.csv(LLfile, header=TRUE, sep='\t')

joined <- merge(BIN, LL, by.x = 'key', by.y = 'Name')


write.table(joined,file=output,col.names=TRUE,row.names=FALSE,sep='\t')