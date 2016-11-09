# SSURGO_LL_MinMaxAvg.R
# Version = v0
#
# Prototype script that calculates the total average minimum, maximum, and average log lengths of tree species
# reported to be common in each SSURGO soil type region in New York State.
# 
# Dictionary is static for "grouped" tree species (e.g. "oaks," "maples")
# Some improvements could be made to make the script more simplified and dynamic.
# 
# K. Mosuela, kmosuela@dewberry.com
# 09.07.2016


#--- Clear workspace
rm(list=ls())

# install.packages('plyr')
library('plyr')

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "P:/Temp/KMosuela/NYSERDA/Work/Trees"

#---Specify the data set
treefile <- "vegcharsallnames.txt" #Dataset of tree species characteristics (shrubs and small trees removed)
vegclass <- "VEGClasses.txt" #Dataset of SSURGO soil types with correlated native tree species

#---Specify name of output file
outputtrees <- "generatedlookuptable.txt"
outputregions <- "SSURGO-LL_maxminavg.txt"

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
classes$V2 <- as.character(classes$V2) # Converts "factor" into character string
classes$V2 <- tolower(classes$V2) # Converts characters to all lowercase letters
classes$V2 <- gsub('[[:space:]]', '', classes$V2) # Removes any extra whitespace
classes$V2 <- strsplit(classes$V2, ',', fixed = FALSE, perl = FALSE, useBytes = FALSE) # Separates species (by comma ,) into list

####### Calculating the Averages for Groups WITH Exact Name Matches #########
# Only unique species are marked for averaging 
# (e.g. northern white cedar and white cedar are counted once between species)

cond <- nyspecies$Oak.Type == 'W'
whiteoaks <- mean(nyspecies[cond,'Average'])
#rwhiteoaks <- data.frame(charname = 'whiteoak', Average = whiteoaks)
#rwhiteoaks_2 <- data.frame(charname = 'whiteoaks', Average = whiteoaks)

cond <- nyspecies$Oak.Type == 'R'
redoaks <- mean(nyspecies[cond,'Average'])
rredoaks <- data.frame(charname = 'redoak', Average = redoaks)
rredoaks_2 <- data.frame(charname = 'redoaks', Average = whiteoaks)

rhickory <- data.frame(charname = 'hickory', Average = nyspecies$Average[nyspecies$charname=='shagbarkhickory'])
rhickory_2 <- data.frame(charname = 'hickories', Average = nyspecies$Average[nyspecies$charname=='shagbarkhickory'])

maples <- mean(nyspecies[grepl('maple',nyspecies$charname) == TRUE, 'Average'])
nyspecies$Maples[grepl('maple',nyspecies$charname) == TRUE] <- 1
rmaple <- data.frame(charname = 'maple', Average = maples)
rmaple_2 <- data.frame(charname = 'maples', Average = maples)

elms <- mean(nyspecies[grepl('elm',nyspecies$charname) == TRUE, 'Average'])
nyspecies$Elms[grepl('elm',nyspecies$charname) == TRUE] <- 1
relm <- data.frame(charname = 'elm', Average = elms)
relm_2 <- data.frame(charname = 'elms', Average = elms)

ash <- mean(nyspecies[grepl('ash',nyspecies$charname) == TRUE, 'Average'])
nyspecies$Ash[grepl('ash',nyspecies$charname) == TRUE] <- 1
rash <- data.frame(charname = 'ash', Average = ash)

spruce <- mean(nyspecies[grepl('spruce',nyspecies$charname) == TRUE, 'Average'])
nyspecies$Spruce[grepl('spruce',nyspecies$charname) == TRUE] <- 1
rspruce <- data.frame(charname = 'spruce', Average = spruce)

birch <- mean(nyspecies[grepl('birch',nyspecies$charname) == TRUE, 'Average'])
nyspecies$Birch[grepl('birch',nyspecies$charname) == TRUE] <- 1
rbirch <- data.frame(charname = 'birch', Average = birch)

walnuts <- mean(nyspecies[grepl('walnut',nyspecies$charname) == TRUE | grepl('butternut',nyspecies$charname) == TRUE , 'Average'])
nyspecies$Walnut[grepl('walnut',nyspecies$charname) == TRUE | grepl('butternut',nyspecies$charname) == TRUE] <- 1
rwalnut <- data.frame(charname = 'walnut', Average = walnuts)

oaks <- (whiteoaks + redoaks) / 2
roaks <- data.frame(charname = 'oaks', Average = oaks)
roaks_2 <- data.frame(charname = 'oak', Average = oaks)

pine <- mean(nyspecies[grepl('birch',nyspecies$charname) == TRUE & nyspecies$Unique==1, 'Average'])
rpine <- data.frame(charname = 'pine', Average = pine)

# Add new rows with "grouped" characteristics
nyspecies <- rbind.fill(nyspecies, rredoaks, rredoaks_2, rhickory, rhickory_2, rmaple, rmaple_2, relm, relm_2,
                        rash, rspruce, rbirch, rwalnut, roaks, roaks_2, rpine)

# Define the new rows
cond_first <- match('redoak', nyspecies$charname)
cond_last <- match('pine', nyspecies$charname)

# Make sure these new rows have max/min heights (so that the loops work later on)
nyspecies[cond_first:cond_last,'Height.Max'] <- nyspecies[cond_first:cond_last,'Average']
nyspecies[cond_first:cond_last,'Height.Min'] <- nyspecies[cond_first:cond_last,'Average']

####### Calculating the Averages for Groups WITHOUT Exact Name Matches #########
# Groups with exact name matches are accounted for in above lookup table
# Only unique species are marked for averaging 
# (e.g. northern white cedar and white cedar are counted once between species) 

  conifers <- mean(nyspecies[nyspecies$Conifer == 1 & !is.na(nyspecies$Name),'Average'])

  decidhard <- mean(nyspecies[nyspecies$Conifer != 1 & !is.na(nyspecies$Name),'Average'])

  #cond <- nyspecies$Oak.Type == 'W'
  #whiteoaks <- mean(nyspecies[cond,'Average'])
  # Not necessary -- "white oaks" or "white oak" as a group not referenced in SSURGO dataset
  
  cond <- nyspecies$Water == 1
  watertol <- mean(nyspecies[nyspecies$Water == 1 & !is.na(nyspecies$Name),'Average'])

##############################

# Set up a list of species that were not matched to a species on the lookup list
nonmatches = c('Species not matched')

# Determine the number of soil regions
m <- length(classes$V2)

# For each soil region...
for (j in 1:m){ 
  # Initialize variables
  total = 0
  totalmax = 0
  totalmin = 0
  summ = 0
  summax = 0
  summin = 0
  treeLL_avg = 0
  treeLL_max = 0
  treeLL_min = 0
  # Determine the number of species in each soil region (add 1 to prevent looping from 1:0)
  n <- length(classes$V2[[j]]) + 1

  # For each species within the soil region
    for (i in 1:n){
      # Find out if the species exists in the lookup list. If it doesn't exist, return 0/FALSE.
      key <- classes$V2[[j]][i]
      if (!is.na(key)){
      verify <- key %in% nyspecies$charname
        # If the species doesn't exist...
        if ((key %in% nyspecies$charname) == FALSE){
          # ...then add the name of the non-matching entry into a list, and make the height = 0
          nonmatches = c(nonmatches, j, key)
          treeLL_avg = 0
          treeLL_max = 0
          treeLL_min = 0
          # ...but if it does exist in the lookup...
          }  else
            # ...then record the average height
          { cond <- match(key,nyspecies$charname)
          treeLL_avg <- nyspecies$Average[cond]
          treeLL_max <- nyspecies$Height.Max[cond]
          treeLL_min <- nyspecies$Height.Min[cond]
          }
      }
      # Add the average height to the summation of the heights
      summ <- summ + 1*treeLL_avg
      summax <- summax + 1*treeLL_max
      summin <- summin + 1*treeLL_min
      # This makes sure that if the species doesn't exist, that entry doesn't cut into the average
      verify = 1*verify
      # Add up the dividend for calculating the average
      total = total + verify
    }
    ###### Adding Conditions for Non-Matching "Group" Nomenclature ######
      # Squeezing all the soil region information into one searchable chunk
      alltogether <- paste(classes$V2[[j]], collapse='')

      # Conifers
      if (grepl('conifer',alltogether) == TRUE){
        summ = summ + conifers
        summax = summax + conifers
        summin = summin + conifers
        total = total + 1
      }
      
      # Water-Tolerant
      if (grepl('wet',alltogether) == TRUE | grepl('water',alltogether) == TRUE | grepl('tolerant',alltogether) == TRUE){
        summ = summ + watertol
        summax = summax + watertol
        summin = summin + watertol
        total = total + 1
      }
     
      # Deciduous/Hardwood
      if (grepl('deciduous',alltogether) == TRUE | grepl('hardwood',alltogether) == TRUE){
        summ = summ + decidhard
        summax = summax + decidhard
        summin = summin + decidhard
        total = total + 1
      }
      
      # General Forest
      if (grepl('woodland',alltogether) == TRUE | grepl('forest',alltogether) == TRUE & grepl('hard',alltogether) == FALSE){
        summ = summ + mean(nyspecies$Average)
        summax = summax + mean(nyspecies$Average)
        summin = summin + mean(nyspecies$Average)
        total = total + 1
      }
    ###########################          
      
      # Calculate the average height of the trees in the soil region and input it into column 'LL'
      classes$LL_avg[j] = summ/total
      classes$LL_max[j] = summax/total
      classes$LL_min[j] = summin/total
}

# List of entries that are not tabulated into average tree heights
 listnonmatches <- as.data.frame(nonmatches)

outputsurgo <- classes[,c('V1','LL_avg', 'LL_max', 'LL_min')]
c('Name','LL_avg', 'LL_max', 'LL_min') -> colnames(outputsurgo)

troubleshoot <- classes[is.na(classes$LL_max),]


write.table(nyspecies,file=outputtrees,col.names=TRUE,row.names=FALSE,sep='\t')
write.table(outputsurgo,file=outputregions,col.names=TRUE,row.names=FALSE,sep='\t')