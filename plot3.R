#load ggplot
library(ggplot2)

# remove user defined function from env
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

# subsetting baltimore data 
NEI_baltimore <- subset(NEI, fips == "24510")

# aggregate by sum the total emissions by year
baltimoreAggTotalsByYear <- aggregate(Emissions ~ year + type, NEI_baltimore, sum)

# plot 3
attach(baltimoreAggTotalsByYear)

# draw plot and save png
g <- ggplot(baltimoreAggTotalsByYear, aes(year, Emissions, color = type))

g <- g + geom_line() + xlab("Year") +  ylab("Total PM 2.5 Emissions (tons)") +
            ggtitle("Total Emissions at Baltimore - Years 1999 to 2008")
print(g)

#save file
dev.copy(png, file = "plot3.png", height = 480, width = 480)
dev.off()
detach(baltimoreAggTotalsByYear)
