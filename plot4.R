#load ggplot
library(ggplot2)

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
if(!exists("SCC")){
  SCC <- readRDS("Source_Classification_Code.rds")
}

# merge  two data sets if not existing
if(!exists("NEISCC"))
NEISCC <- merge(NEI, SCC, by = "SCC")

#coal related emmisions
coalData <- grepl(pattern = 'coal', x = NEISCC$EI.Sector , ignore.case = TRUE )
NEISCC_coalData <- NEISCC[coalData,]

# aggregate by sum the total emissions by year
aggTotalsByYear <- aggregate(Emissions ~ year, NEISCC_coalData, sum)

# plot 4
attach(aggTotalsByYear)

# draw plot and save png
g <- ggplot(aggTotalsByYear, aes(factor(year), Emissions))

g <- g + geom_bar(stat="Identity") +
  xlab("Years") +
  ylab("Total PM 2.5 Emissions (tons)") +
  ggtitle("Total Coal Combustion Related Emissions - Years 1999 to 2008")
print(g)

#save file
dev.copy(png, file = "plot4.png", height = 480, width = 480)
dev.off()
detach(aggTotalsByYear)
