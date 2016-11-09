# MergeDBF.R
# Version = v1
#
# This script merges dbf files (i.e. appends columns) based on a key value.
# It repeats the script across all batches, then zips (as a tar file) and deletes the source files.
# 
# 
# K. Mosuela, kmosuela@dewberry.com
# 6.30.2016

 #--- Clear workspace
  rm(list=ls())
  
  library('foreign')
  
  #========================================================#
  #---------------------USER INPUT-------------------------#
  #========================================================#
  
  #---Assign Path & Working Directory
  workdir <- 'W:/CCSI/TECH/NYSERDA/InfrastructureVulnerability/Task8/DATA/StreamStats/ZS_Corrections'
  
  #---Specify name of output file
  outputname <- 'AllMerged.txt'
  outputdbf <- 'AllMerged.dbf'
  
  #---Specify common identifier by which to join data
  key <- 'Name'
  
  #---Specify folders in which dbf files are nested
  nest <- 'dbf'
  
  
  #========================================================#
  #-------------------USER INPUT END-----------------------#
  #========================================================#
  
  # set the working directory
  setwd(workdir)
  listdirs <- dir(workdir, include.dirs = FALSE, full.names = TRUE)
  dirnames <- dir(workdir, include.dirs = FALSE, full.names = FALSE)
  ndirs <- length(listdirs)
  
  for (j in 1:ndirs){
    inpath <- paste0(listdirs[j],'/',nest)
    setwd(inpath)
    print(listdirs[j])
  
    for (i in 1:30){
      
      filename <- paste0('Merge',i,'.dbf')
      
      if (i == 1){
        core <- read.dbf(filename)
      }
      
      else{
        appendthis <- read.dbf(filename)
        core <- merge(x = core, y = appendthis, by = key, all.x = FALSE)
      }
    }
    write.table(core,file=outputname,col.names=TRUE,row.names=FALSE,sep='\t')
    write.dbf(core,outputname)
    
    zipname <- paste0(dirnames[j],'_dbf','.tgz')
    zippath <- file.path(workdir,dirnames[j],zipname)
    
    setwd(file.path(workdir,dirnames[j],nest))
    filelist <- list.files()
    # ziplist <- filelist[grep(glob2rx("Merge*"), filelist)]
    
    file.copy(outputname, file.path(listdirs[j],outputname))
    file.copy(outputdbf, file.path(listdirs[j],outputdbf))
    unlink(outputname)
    unlink(outputdbf)
    
    print(getwd())
    tar(tarfile = zippath, compression='gzip')
    
    unlink(file.path(workdir,dirnames[j],nest), recursive = TRUE)

  }
  
