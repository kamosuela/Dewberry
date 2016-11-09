#--- Clear workspace
rm(list=ls())

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "P:/Temp/KMosuela/NYSERDA/Work/Trees"

#---Specify the data set
treefile <- "vegcharsallnames.txt"
vegclass <- "VEGClasses.txt"

#---Specify name of output file
outputname <- "lookuptable.txt"

#========================================================#
#------------------END USER INPUT------------------------#
#========================================================#

setwd(dir)

# read file
species <- read.csv(treefile, header=TRUE, sep='\t')
classes <- read.csv(vegclass, header=FALSE, sep='\t')

# TREE Clip to only where species data was found
cond <- is.na(species$Height.Min) == FALSE
nyspecies <- species[cond,]

# TREE Calculate average height
nyspecies$Average <- (nyspecies$Height.Min + nyspecies$Height.Max)/2

# TREE Converting to searchable characters
nyspecies$charname <- as.character(nyspecies$Name)
nyspecies$charname <- tolower(nyspecies$charname)
nyspecies$charname <- gsub('[[:space:]]', '', nyspecies$charname)


# CLASS split the list of text into cells
classes$V2 <- as.character(classes$V2)
classes$V2 <- tolower(classes$V2)
classes$V2 <- gsub('[[:space:]]', '', classes$V2)
classes$V2 <- strsplit(classes$V2, ',', fixed = FALSE, perl = FALSE, useBytes = FALSE)

lookup <- c(
'americanbeech'	= 70,
'beech' = 70,
'americanelm'	=	87.5,
'swampelm' = 87.5,
'atlanticwhitecedar' = 120,
'balsamfir'	=	50,
'basswood'	=	70,
'blackash'	=	50,
'blackbirch'	=	62.5,
'blackcherry'	=	50,
'cherry' = 50,
'wildcherry' = 50,
'blackoak'	=	60,
'chestnutoak'	=	60,
'cottonwood'	=	80,
'dogwood'	=	40,
'elder'	=	40,
'graybirch'	=	65,
'greenash'	=	45,
'hackberry'	=	110,
'hemlock'	=	65,
'easternhemlock' = 65,
'hophornbeam' = 30,
'ironwood'	=	30,
'jackpine'	=	70,
'northernredoak'	=	70,
'paperbirch'	=	65,
'whitebirch' = 65,
'pinoak'	=	70,
'pitchpine'	=	50,
'quakingaspen'	=	55,
'tremblingaspen' = 55,
'aspen' = 55,
'redcedar'	=	35,
'easternredcedar' = 35,
'redmaple'	=	70,
'redpine'	=	70,
'redspruce'	=	75,
'riverbirch'	=	70,
'scarletoak'	=	70,
'scotchpine'	=	45,
'shagbarkhickory'	=	70,
'silvermaple'	=	70,
'softmaple' = 70,
'slipperyelm'	=	55,
'sugarmaple'	=	70,
'hardmaple' = 70,
'swampwhiteoak'	=	60,
'sweetgum'	=	100,
'sycamore'	=	85,
'tamarack'	=	60,
'easternlarch' = 60,
'virginiapine'	=	70,
'blackwalnut'	=	75,
'walnut' = 75,
'whiteash'	=	65,
'whitecedar'	=	175,
'northernwhitecedar' = 175,
'northernwhite-cedar' = 175,
'whiteoak'	=	90,
'whitepine'	=	135,
'easternwhitepine' = 135,
'whitespruce'	=	65,
'yellowbirch'	=	70,
'yellowpoplar'	=	90,
'tulippoplar' = 90,
'poplar' = 90
)



classes$LL <- NA
nonmatches = c('Species not matched')

m <- length(classes$V2)

for (j in 1:m){ 

total = 0
summ = 0
treeLL = 0
n <- length(classes$V2[[j]]) + 1

if (n == 0){print(j)}

for (i in 1:n){
  verify <- !is.na(lookup[classes$V2[[j]][i]])
    if (is.na(lookup[classes$V2[[j]][i]]) == TRUE){
      nonmatches = c(nonmatches, j, classes$V2[[j]][i])
      treeLL = 0
      }  else
        { treeLL <- lookup[classes$V2[[j]][i]] }
  summ <- summ + 1*treeLL
  verify = 1*verify
  total = total + verify
}


classes$LL[j] = summ/total
}

listnonmatches <- as.data.frame(nonmatches)


write.table(nyspecies,file=outputname,col.names=TRUE,row.names=FALSE,sep='\t')