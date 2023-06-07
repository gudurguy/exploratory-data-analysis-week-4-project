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


# aggregate total emissions by year
aggTotalsByYear <- aggregate(Emissions ~ year, NEI, sum)

# plot 1
attach(aggTotalsByYear)

barplot( aggTotalsByYear$Emissions ,
         names.arg=aggTotalsByYear$year, 
         xlab="Year", 
         ylab="Total PM 2.5 Emissions (tons)",
         main="Total PM 2.5 Emissions for different years"
)

#save file
dev.copy(png, file = "plot1.png", height = 480, width = 480)
dev.off()
detach(aggTotalsByYear)