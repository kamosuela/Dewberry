#--- Clear workspace
rm(list=ls())

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "C:/Users/kmosuela/Desktop/Debug"

#---Specify the data set
filenull <- "NullOnly.csv"
  keynull <- 'Name'
filefull <- "B_NormalFlows.txt"
  keyfull <- 'Name'

#---Specify name of output file
outputname <- "ErrorNormal.txt"

#========================================================#
#------------------END USER INPUT------------------------#
#========================================================#

setwd(dir)
full <- read.table(filefull,header=TRUE,sep="\t")
null <- read.csv(filenull, sep=",", header=TRUE)

join <- merge(x = null, y = full, by.x = keynull, by.y = keyfull, all.x = FALSE)

print(join)

cut <- join$Name
print(length(cut))

origdata <- full[cut,]