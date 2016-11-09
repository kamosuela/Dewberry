#--- Clear workspace
rm(list=ls())

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "P:/Temp/KMosuela/TEIF"

#---Specify the data set
file <- "CommunitiesinScopeUpdated.txt"

#---Specify name of output file
output <- "CommunitiesinScopeUpdated.txt"


#========================================================#
#------------------END USER INPUT------------------------#
#========================================================#

setwd(dir)

# read file
mydata <- read.csv(file, header=TRUE, sep='\t')

# change names so that they are easily importable to ArcGIS
badnames <- colnames(mydata)
goodnames <- gsub("[.]","_",badnames) #"." requires an escape because it is a metacharacter
colnames(mydata) <- goodnames

mydata$CFIPS <- as.numeric(mydata$CFIPS)

# write file
write.table(mydata,file=output,col.names=TRUE,row.names=FALSE,sep='\t')