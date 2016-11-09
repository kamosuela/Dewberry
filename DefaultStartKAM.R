#--- Clear workspace
rm(list=ls())

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "P:/Temp/KMosuela/NYSERDA/Work/Trees"

#---Specify the data set
file <- "CommunitiesinScopeUpdated.xlsx"

#---Specify name of output file
output <- "CommunitiesinScopeMerge.txt"


#========================================================#
#------------------END USER INPUT------------------------#
#========================================================#

setwd(dir)

# read file
mydata <- read.csv(file, header=TRUE, sep='\t')






# write file
write.table(myfinaldata,file=output,col.names=TRUE,row.names=FALSE,sep='\t')