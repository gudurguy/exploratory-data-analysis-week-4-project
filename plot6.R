# remove user defined function from env if there is one
if(exists("downloadData")){
  rm(downloadData)
}
# source the download data function from R script
downloadFile <- paste(getwd(), "dataDownload.R", sep ="/")
source(downloadFile)

# now run user defined function for downloading data
downloadData() 

# read two unzipped files using readRDS function if not read already
if(!exists("NEI")) {
  NEI <- readRDS("summarySCC_PM25.rds")
}

# subsetting baltimore data from motor vehicles (on road)
NEI_baltimore_onroad <- subset(NEI, fips == "24510" & type == "ON-ROAD")

# subsetting los angeles data from motor vehicles (on road)
NEI_la_onroad <- subset(NEI, fips == "06037" & type == "ON-ROAD")

# aggregate by sum the total emissions by year
baltimoreAggTotalsByYear <- aggregate(Emissions ~ year, NEI_baltimore_onroad, sum)
laAggTotalsByYear <- aggregate(Emissions ~ year, NEI_la_onroad, sum)

# plot 6
attach(baltimoreAggTotalsByYear)
attach(laAggTotalsByYear)

# draw plot and save png
range <- range(baltimoreAggTotalsByYear$Emissions, laAggTotalsByYear$Emissions)

plot(x = baltimoreAggTotalsByYear$year , y = baltimoreAggTotalsByYear$Emissions, 
     type = "p", pch = 18, col = "red", 
     ylab = "PM 2.5 Emission (in tons)", xlab = "Year",  ylim = range, 
     main = "Motor vehicle related PM2.5 Emission in LA & Baltimore from 1999 to 2008")
lines(x =baltimoreAggTotalsByYear$year, y = baltimoreAggTotalsByYear$Emissions, col = "red")

# Draw la emissions
points(x = laAggTotalsByYear$year, y = laAggTotalsByYear$Emissions, pch = 18, col = "green")
lines(x =laAggTotalsByYear$year, y = laAggTotalsByYear$Emission, col = "green")

# Draw Legends
legend("right", legend = c("LA", "Baltimore"), pch = 18, lty=1, col = c("green", "red"), title = "City")

#save file
dev.copy(png, file = "plot6.png", height = 480, width = 480)
dev.off()
detach(baltimoreAggTotalsByYear)
detach(laAggTotalsByYear)