summary(outputsurgo[,2])

#need to use this syntax when replacing values with NA
dt$LL_avg[dt$LL_avg==0] <- NA

png('P:/Temp/KMosuela/NYSERDA/Work/Trees/TreeHeightBoxPlot.png')
boxplot(outputsurgo[,2], ylab = 'Average Height (LL)', main = 'Box Plot of LL')
dev.off()