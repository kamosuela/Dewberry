#--- Clear workspace
#rm(list=ls())


#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#
jurisname = paste0("BombayTown_")

#---Assign Path & Working Directory
MYDIR <- "P:/Admin/CNMS/CNMS_2016/DATA_SETS/Region2_DataSets/NY/Franklin_NY_36033/FIRMpanels"
setwd(MYDIR)

#========================================================#
#-------------------USER INPUT END-----------------------#
#========================================================#


#---In this directory, read out and list the file names
files <- list.files(MYDIR)
zipfiles <- files[grep(glob2rx("*.zip"), files)]
nzipfiles = length(zipfiles)
print(nzipfiles)

for (i in zipfiles)
{
  zipname = strsplit((i), '[.]')[[1]][1]
}

#find wheren zipnames = folder names, unlist those zip files


for (j in 1:nzipfiles)
  {
  unzip(zipfiles[j],exdir=zipname[j])
  unzipfiles <- list.files(zipname[j])
  unzipfiles <- unzipfiles[grep(glob2rx("*.tif"), unzipfiles)]
  nunzipfiles = length(unzipfiles)
  
  for (k in 1:nunzipfiles)
  {
    from = file.path(zipname[j],unzipfiles[k])
    to = paste0(MYDIR,'/',jurisname,unzipfiles[k])
    file.rename(from,to)
    print(unzipfiles[k])
  }
  
# file.remove(file.path(MYDIR,zipname[j]))
#  file.remove(zipname[j])
  
  unlink(zipname[j])
  unlink(paste0(zipname[j],'.zip'))

  #  unlink(paste0(zipname[j],'.tif'))
}

