# user defined function to download data
downloadData <- function() {
  # Zip file name
  destFilename <- "Dataset.zip"

  # URL for the Zip File
  URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

  # Checking if the zip file is already in the local file system. 
  # If not, download it from the URL and unzip it
  if (!file.exists(destFilename)){
    download.file(URL, destFilename, method="curl")
    unzip(destFilename)
  }  
}
