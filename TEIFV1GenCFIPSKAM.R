#--- Clear workspace
rm(list=ls())

# Opens up library necessary for the DBF read function
library('foreign')

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "P:/Temp/KMosuela/TEIF"

#---Specify dbf file to open
filename <- 'TEIFCensusBlocks.dbf'

#---Specify name of output file
output <- "TEIFCensusBlocks.dbf"

#========================================================#
#-------------------USER INPUT END-----------------------#
#========================================================#

# set the working directory
setwd(dir)

# read the dbf file
dbf <- read.dbf(filename)
head(dbf)

# join the state and county fips into a character field
dbf$CFIPS <- paste0(dbf$STATEFP10,dbf$COUNTYFP10)
class(dbf$CFIPS)

# convert into an integer (this is how the other data set is read)
dbf$CFIPS <- as.integer(dbf$CFIPS)
class(dbf$CFIPS)


# write file
write.dbf(dbf,output)