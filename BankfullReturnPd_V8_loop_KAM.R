# BankfullReturnPeriod.R
# Version = v0
#
# A prototype script that calculates the return period/discharge immediately
# before the bankfull discharge.
#
# "NA" indicates that the stream is at bankfull discharge at less than an annual basis.
# 
# K. Mosuela, kmosuela@dewberry.com
# 6.27.2016


#--- Clear workspace
rm(list=ls())

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/StatisticalAnalysis/BankfullDischarge"

#---Specify the data set
filebankfull <- "BankfullOutput.txt"
filenorm <- "W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/FLOW/FinalFlows/B_NormalFlows.txt"

#---Specify name of output file
outputname <- "BankfullReturn.txt"

#========================================================#
#------------------END USER INPUT------------------------#
#========================================================#

setwd(dir)
bankfull <- read.table(filebankfull,header=TRUE,sep="\t")
norm <- read.csv(filenorm, sep="", header=TRUE)

join <- merge(x = bankfull, y = norm, by.x = "BIN", by.y = "Name", all.x = FALSE)
head(join)

join$Return_cfs <- NA
join$Return_pd <- NA
head(join)

retpds <- c("Q500","Q200","Q100","Q50","Q25","Q10","Q5","Q2","Q1_5","Q1_25")
print(retpds)

# the return cfs gives the return period cfs right BEFORE bankfull.
for (i in retpds){
  pd <- i
  print(pd)
  cond <- is.na(join$Return_cfs) == TRUE & join$Discharge >= join[,i]
  join[cond,'Return_pd'] <- colnames(join[i])
  join[cond, 'Return_cfs'] <- join[cond,i]
  }

head(join)

write.table(join,file=outputname,col.names=TRUE,row.names=FALSE,sep='\t')