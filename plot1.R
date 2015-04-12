fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataDirName <- "."
fileName <- "household_power_consumption.zip"

dataDates <- c(as.Date("2007-02-01",format="%Y-%m-%d"),as.Date("2007-02-02",format="%Y-%m-%d"))

# START PROG

fileDestination <- paste(dataDirName, fileName, sep="/")

# skip directory and file creation if it already exists
if (!file.exists(fileDestination)) {

  # create data directory if it doesn't exist
  if (!file.exists(dataDirName)) {
    dir.create(dataDirName)
  }

  # download data file
  download.file(fileUrl, destfile=fileDestination, method="curl")
  
  # extract file
  unzip(fileDestination)
}

# read values
df <- read.table("household_power_consumption.txt", header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")
df$formattedDate <- as.Date(df$Date , "%d/%m/%Y")

# filter data
graphData <- df[df$formattedDate %in% dataDates ,]

# create plot image
png(file="plot1.png", width=480, height=480, units="px", pointsize=12, bg="white", res=NA)
globalActivePower <- as.numeric(graphData$Global_active_power)
hist(globalActivePower, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")
dev.off()
