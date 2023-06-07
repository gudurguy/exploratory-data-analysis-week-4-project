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
baltimoreAggTotalsByYear <- aggregate(Emissions ~ year, NEI_baltimore, sum)

# plot 2
attach(baltimoreAggTotalsByYear)

# draw plot and save png
barplot( baltimoreAggTotalsByYear$Emissions ,
         names.arg=baltimoreAggTotalsByYear$year, 
         xlab="Year", 
         ylab="Total PM 2.5 Emissions (tons)",
         main="Total PM 2.5 Emissions for different years at Baltimore"
)

#save file
dev.copy(png, file = "plot2.png", height = 480, width = 480)
dev.off()
detach(baltimoreAggTotalsByYear)
