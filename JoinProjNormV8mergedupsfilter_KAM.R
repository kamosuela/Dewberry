#--- Clear workspace
rm(list=ls())

#========================================================#
#---------------------USER INPUT-------------------------#
#========================================================#

#---Assign Path & Working Directory
MYDIR <- "P:/Temp/NEWYORK/STATISTICS"
setwd(MYDIR)

normfile <- "B_NormalFlows.csv"
projfile <- "B_pr45_75_99.txt"


#========================================================#
#-------------------USER INPUT END-----------------------#
#========================================================#

#read files into a data frame
norm <- read.csv(normfile, sep="", header=TRUE)
proj <- read.table(projfile, sep="", header=TRUE)

#merge based on bridge ID (name)
merge <- merge(x = norm, y = proj, by = "Name")

#remove rows where the first column (Names) are duplicated -- via [(blank=allrows),col#]
join <- merge[!duplicated(merge[,1]) , ]

#calculation for change
change_1_25 = join$Q1_25.y/join$Q1_25.x
change_1_5 = join$Q1_5.y/join$Q1_5.x
change_2 = join$Q2.y/join$Q2.x
change_5 = join$Q5.y/join$Q5.x
change_10 = join$Q10.y/join$Q10.x
change_25 = join$Q25.y/join$Q25.x
change_50 = join$Q50.y/join$Q50.x
change_100 = join$Q2.y/join$Q100.x
change_200 = join$Q200.y/join$Q200.x
change_500 = join$Q500.y/join$Q500.x

#dataframe
change <- cbind(join$Name,change_1_25,change_2,change_5,change_10,change_25,change_50,
                change_100,change_200,change_500)
colnames(change) <- c('Name','change_1_25','change_2','change_5','change_10','change_25',
                'change_50','change_100','change_200','change_500')
head(change)

#writing the dataframe to file
filename <- strsplit(projfile, '[.]')[[1]][1]
filesave <- paste0('change_',filename,'.txt')
write.table(change, filesave, sep="\t")



