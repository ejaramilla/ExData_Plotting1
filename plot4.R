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
datetime <- strptime(paste(graphData$Date, graphData$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 
globalActivePower <- as.numeric(graphData$Global_active_power)
globalReactivePower <- as.numeric(graphData$Global_reactive_power)
voltage <- as.numeric(graphData$Voltage)
Submetering1 <- as.numeric(graphData$Sub_metering_1)
Submetering2 <- as.numeric(graphData$Sub_metering_2)
Submetering3 <- as.numeric(graphData$Sub_metering_3)
png("plot4.png", width=480, height=480)
par(mfrow = c(2, 2)) 
plot(datetime, globalActivePower, type="l", xlab="", ylab="Global Active Power", cex=0.2)
plot(datetime, voltage, type="l", xlab="datetime", ylab="Voltage")
plot(datetime, Submetering1, type="l", ylab="Energy sub metering", xlab="")
lines(datetime, Submetering2, type="l", col="red")
lines(datetime, Submetering3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=, lwd=2.5, col=c("black", "red", "blue"), bty="o")
plot(datetime, globalReactivePower, type="l", xlab="datetime", ylab="Global_reactive_power")
dev.off()

