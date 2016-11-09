#--- Clear workspace
rm(list=ls())

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "P:/Temp/NEWYORK/Bankfull/Analysis"

#---Specify the data set
filebankfull <- "bankfulloutput.txt"
filenorm <- "B_NormalFlows.csv"

#========================================================#
#------------------END USER INPUT------------------------#
#========================================================#

setwd(dir)
bankfull <- read.table(filebankfull,header=TRUE,sep="\t")
norm <- read.csv(filenorm, sep="", header=TRUE)

join <- merge(x = bankfull, y = norm, by.x = "BIN", by.y = "Name", all.x = FALSE)
head(join)

join$Return_cfs <- NA
head(join)

#This needs to be collated. And the return cfs gives the return period cfs right BEFORE bankfull.
Q500 <- is.na(join$Return_cfs) == TRUE & join$Discharge >= join$Q500
join[Q500,'Return_cfs'] <- join$Q500[Q500]
Q200 <- is.na(join$Return_cfs) == TRUE & join$Discharge >= join$Q200
join[Q200,'Return_cfs'] <- join$Q100[Q200]
Q100 <- is.na(join$Return_cfs) == TRUE & join$Discharge >= join$Q100
join[Q100,'Return_cfs'] <- join$Q100[Q100]
Q50 <- is.na(join$Return_cfs) == TRUE & join$Discharge >= join$Q50
join[Q50,'Return_cfs'] <- join$Q50[Q50]
Q25 <- is.na(join$Return_cfs) == TRUE & join$Discharge >= join$Q25
join[Q25,'Return_cfs'] <- join$Q25[Q25]
Q10 <- is.na(join$Return_cfs) == TRUE & join$Discharge >= join$Q10
join[Q10,'Return_cfs'] <- join$Q10[Q10]
Q5 <- is.na(join$Return_cfs) == TRUE & join$Discharge >= join$Q5
join[Q5,'Return_cfs'] <- join$Q5[Q5]
Q2 <- is.na(join$Return_cfs) == TRUE & join$Discharge >= join$Q2
join[Q2,'Return_cfs'] <- join$Q2[Q2]
Q1_5 <- is.na(join$Return_cfs) == TRUE & join$Discharge >= join$Q1_5
join[Q1_5,'Return_cfs'] <- join$Q1_5[Q1_5]
Q1_25 <- is.na(join$Return_cfs) == TRUE & join$Discharge >= join$Q1_25
join[Q1_25,'Return_cfs'] <- join$Q1_25[Q1_25]

head(join)

