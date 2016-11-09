# SurficialAnalysis.R
# Version = v0
#
# Summarizes the result of joining surficial geology to bridge/culvert points.
# 
# K. Mosuela, kmosuela@dewberry.com
# 10.28.2016


#--- Clear workspace


#--- Clear workspace
rm(list=ls())
library(plyr)

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/Development/SSURGO/data"
#---Specify the data set
filename <- "C_SurficialData.csv"
ID <- as.character('BDMS_ID') #either BIN for bridges or BDMS_ID for culverts
#---Output
outputname <- "C_Surficial.txt"
outputsummary <- "C_SurficialSummary.txt"

#========================================================#
#------------------END USER INPUT------------------------#
#========================================================#

setwd(dir)
#file <- read.table(filename,header=TRUE,sep=",")
file <- read.csv(filename,header=TRUE,sep=",")

head(file)
colnames(file)

dt <- file[,c(ID,'MATERIAL')]
head(dt)

collapsed <- aggregate(dt[ID],by=dt['MATERIAL'],FUN=length)

write.table(dt,file=outputname,col.names=TRUE,row.names=FALSE, sep='\t')
write.table(collapsed,file=outputsummary,col.names=TRUE,row.names=FALSE, sep='\t')
