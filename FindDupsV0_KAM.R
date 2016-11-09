#--- Clear workspace
rm(list=ls())

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
MYDIR <- "P:/Temp/NEWYORK/STATISTICS"
setwd(MYDIR)

#========================================================#
#-------------------USER INPUT END-----------------------#
#========================================================#

txt <- list.files(MYDIR)
Bfiles <- txt[grep(glob2rx("B_*.txt"), txt)]
Cfiles <- txt[grep(glob2rx("C_*.txt"), txt)]
files <- c(Bfiles, Cfiles)
nfiles <- length(files)

for (i in 1:nfiles) {

#read files into a data frame
read <- read.table(files[i], sep="", header=TRUE)

#remove rows where the first column (Names) are duplicated -- via [(blank=allrows),col#]
dups <- duplicated(read[,1])
print(files[i])
nodups <- length(dups[dups==TRUE])
print(nodups)

}