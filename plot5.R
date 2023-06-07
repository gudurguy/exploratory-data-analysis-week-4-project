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

# subsetting baltimore data for on road
NEI_baltimore_onroad <- subset(NEI, fips == "24510" & type == "ON-ROAD")

# aggregate by sum the total emissions by year
baltimoreAggTotalsByYear <- aggregate(Emissions ~ year, NEI_baltimore_onroad, sum)

# plot 5
attach(baltimoreAggTotalsByYear)

# draw plot and save png
barplot( baltimoreAggTotalsByYear$Emissions ,
         names.arg=baltimoreAggTotalsByYear$year, 
         xlab="Years", 
         ylab="Total PM 2.5 Emissions (tons)",
         main="Total PM 2.5 Motor Vehicle Emissions at Baltimore - Years 1999 to 2008"
)
#save file
dev.copy(png, file = "plot5.png", height = 720, width = 720)
dev.off()
detach(baltimoreAggTotalsByYear)
