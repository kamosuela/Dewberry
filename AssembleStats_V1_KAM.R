# merge_files.r
#
# Overview: Merge subset of files in a directory 
#

# S. Lawler, slawler@dewberry.com
# 6.1.2016

#--- Clear workspace
rm(list=ls())


#---Assign Path & Working Directory
MYDIR = "P:\\Temp\\NEWYORK\\STATISTICS"
setwd(MYDIR)


#---In this directory, read out and list the Directories (folders)
dirs  <- list.dirs()

#norm_B_dirs <- dirs[grep(glob2rx("*/B*/BatchResults"), dirs)]
#norm_C_dirs <- dirs[grep(glob2rx("*/C*/BatchResults"), dirs)]

#---Grab the directories in the main directory that have the characteristics below
proj_B_dirs <- dirs[grep(glob2rx("*/B*/Results"), dirs)]
proj_C_dirs <- dirs[grep(glob2rx("*/C*/Results"), dirs)]



#---Assign Current Directory & Ensemble Scenario 
#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

directories = proj_B_dirs
ensemble <- "pr45_25_49*"
savefile = file.path(MYDIR,"B_pr45_25_49.txt")



#---RUN FILE

#---the "j in directories" will loop through each of the items in directories (items in list!!!)

for (j in directories){
    
    files <- list.files(j) 
    files_w_path <- file.path(j,files)[grep(glob2rx(ensemble), files)]
    
    #---"files" is the list of files ("list.files") from j
    #---"glob2rx" will select from "files" those that fit the "ensemble" parameters
    #---"file.path" quickly gives the file path by combining the directory "j" and the file name "files"
    #---[] after the "file.path" limits the scope of the files that are being processed.
    #---Imagine the [] as an indexing filename <- pr45_50_74_Q500.txt

    for (i in files_w_path){
        filename = strsplit((i), '[.]')[[1]][2]
        filename <- strsplit(filename, split  = 'Results/')[[1]][2]
    #---These string splits strip the long file name into just what we want.
    #---"strsplit" splits a string by the characters you specify. [1], etc. chooses the piece.
    
        if(i==files_w_path[1]){
            firstfile <- read.table(i,sep = '\t', header = TRUE) 
            #---This reads the file 'i' by tab separations with headers.
            mytable  <- data.frame(firstfile$Name,firstfile$Mean)
            #---This creates a data frame (table essentially) that is made up of
            #---the file's 2 columns named "Name" and "Mean"
            colnames(mytable) <- c('Name', substr(filename,12,18) )
            #---The column names for mytable is 'Name' and the file name stripped from chars 12-18
        
        }else{
            nextfile  <- read.table(i,sep = '\t', header = TRUE)
            #---Must READ the table and assign it into the code before using it
            nextmean  <- data.frame(filename = nextfile$Mean)
            #---Finds only the column in the table named "Mean"
            colnames(nextmean) <-substr(filename,12,18)
            #---This itty bitty single-column table "nextmean" has the stripped string name (Q's)
            mytable   <- cbind(mytable, nextmean)
            #---appends the itty bitty table/column to the main column
            }
       
       }
        if (j==directories[1]){
            write.table(mytable,file = savefile, quote = FALSE,row.names = FALSE)
          #---Writes the table and saves as file with name "savefile" in the existing directory
            print(length(mytable$Name))
            print('Part 1 Done')
        }else{
            print(length(mytable$Name))
            write.table(mytable,file = savefile, quote = FALSE,row.names = FALSE, append = TRUE, col.names=FALSE)
            print('Part 2 Done')
            
    } 

}





