# SSURGOTreeSpeciesLL.R
# Version = v0
#
# Prototype script that calculates the total average log length of tree species
# reported to be common in each SSURGO soil type region in New York State.
# 
# Dictionary (aka lookup table or hash table) is static and only applicable to datasets specified.
# Some improvements could be made to make the dictionary more expansive and dynamic to fit a variety of data.
# 
# K. Mosuela, kmosuela@dewberry.com
# 8.23.2016


#--- Clear workspace
rm(list=ls())

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
dir <- "P:/Temp/KMosuela/NYSERDA/Work/Trees"

#---Specify the data set
treefile <- "vegcharsallnames.txt" #Dataset of tree species characteristics (shrubs and small trees removed)
vegclass <- "VEGClasses.txt" #Dataset of SSURGO soil types with correlated native tree species

#---Specify name of output file
outputtrees <- "limitedlookuptable.txt"
outputregions <- "SSURGO-LL.txt"

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

# Create lookup table of height averages based on name
# 
# The following lookup table includes "also known as" names 
# and tree "groups" (e.g. oaks, maples, birches) that have exact matches to entries in the SSURGO dataset.
# Sample source code for developing the average heights of tree groups (e.g. oaks, maples, birches) 
# can be found at SSURGODigestV5CalculatingGroupAveragesDebug.R
#
# NOTE: With this lookup table, only ONE value can be associated with the key/name.
# Check the "Hash" package for developing larger and more complex lookup tables.
# 
lookup <- c(
'americanbeech'	= 70,
'beech' = 70,
'americanelm'	=	87.5,
'swampelm' = 87.5,
'atlanticwhitecedar' = 120,
'balsamfir'	=	50,
'fir' = 50,
'basswood'	=	70,
'blackash'	=	50,
'blackbirch'	=	62.5,
'blackcherry'	=	50,
'blackspruce' = 60,
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
'butternut' = 45,
'whiteash'	=	65,
'whitecedar'	=	175,
'northernwhitecedar' = 175,
'northernwhite-cedar' = 175,
'whiteoak'	=	90,
'whitepine'	=	135,
'easternwhitepine' = 135,
'whitespruce'	=	65,
'yellowbirch'	=	70,
'swampbirch' = 70,
'yellowpoplar'	=	90,
'tulippoplar' = 90,
'poplar' = 90,
'redoak' = 67.5,
'redoaks' = 67.5,
'hickory' = 70,
'hickories' = 70,
'maple' = 70,
'maples' = 70,
'elm' = 76.66667,
'elms' = 76.66667,
'ash' = 53.3333,
'spruce' = 66.66667,
'birch' = 66.78571,
'walnut' = 60,
'oak' = 68.75,
'oaks' = 68.75,
'pine' = 82.14286
)

####### Calculating the Averages for Groups WITHOUT Exact Name Matches #########
# Groups with exact name matches are accounted for in above lookup table
# Only unique species are marked for averaging 
# (e.g. northern white cedar and white cedar are counted once between species) 

  cond <- nyspecies$Conifer == 1
  conifers <- mean(nyspecies[cond,'Average'])

  cond <- nyspecies$Conifer != 1
  decidhard <- mean(nyspecies[cond,'Average'])

  #cond <- nyspecies$Oak.Type == 'W'
  #whiteoaks <- mean(nyspecies[cond,'Average'])
  # Not necessary -- "white oaks" or "white oak" as a group not referenced in SSURGO dataset
  
  cond <- nyspecies$Water == 1
  watertol <- mean(nyspecies[cond,'Average'])

##############################

# Set up the table for inserting average heights
classes$LL <- NA

# Set up a list of species that were not matched to a species on the lookup list
nonmatches = c('Species not matched')

# Determine the number of soil regions
m <- length(classes$V2)

# For each soil region...
for (j in 1:m){ 
  # Initialize variables
  total = 0
  summ = 0
  treeLL = 0
  # Determine the number of species in each soil region (add 1 to prevent looping from 1:0)
  n <- length(classes$V2[[j]]) + 1

  # For each species within the soil region
    for (i in 1:n){
      # Find out if the species exists in the lookup list. If it doesn't exist, return 0/FALSE.
      verify <- !is.na(lookup[classes$V2[[j]][i]])
        # If the species doesn't exist...
        if (is.na(lookup[classes$V2[[j]][i]]) == TRUE){
          # ...then add the name of the non-matching entry into a list, and make the height = 0
          nonmatches = c(nonmatches, j, classes$V2[[j]][i])
          treeLL = 0
          # ...but if it does exist in the lookup...
          }  else
            # ...then record the average height
          { treeLL <- lookup[classes$V2[[j]][i]] }
    
      # Add the average height to the summation of the heights
      summ <- summ + 1*treeLL
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
        total = total + 1
      }
      
      # Water-Tolerant
      if (grepl('wet',alltogether) == TRUE | grepl('water',alltogether) == TRUE | grepl('tolerant',alltogether) == TRUE){
        summ = summ + watertol
        total = total + 1
      }
     
      # Deciduous/Hardwood
      if (grepl('deciduous',alltogether) == TRUE | grepl('hardwood',alltogether) == TRUE){
        summ = summ + decidhard
        total = total + 1
      }
      
      # General Forest
      if (grepl('woodland',alltogether) == TRUE | grepl('forest',alltogether) == TRUE & grepl('hard',alltogether) == FALSE){
        summ = summ + mean(nyspecies$Average)
        total = total + 1
      }
    ###########################          
      
      # Calculate the average height of the trees in the soil region and input it into column 'LL'
      classes$LL[j] = summ/total
      
  }

# List of entries that are not tabulated into average tree heights
 listnonmatches <- as.data.frame(nonmatches)

outputsurgo <- classes[,c('V1','LL')]

write.table(nyspecies,file=outputtrees,col.names=TRUE,row.names=FALSE,sep='\t')
write.table(outputsurgo,file=outputregions,col.names=FALSE,row.names=FALSE,sep='\t')