###########################################################
# File:     plot3.R
# Purpose:  Creates plot3.png for Course Project 1
#           for Exploratory Data Analysis - Week 1
# Version:  1.0
# Input:    ZIP file containing Electric power 
#           consumption dataset
# Output:   plot3.png
# Author:   Dick Groenhof
###########################################################

# url.data contains the URL for the source dataset zipfile
url.data <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Check if source file exists, if not:
# * Download the zipfile
# * Unzip the zipfile
# * Rename the dataset textfile
# * Delete zipfile
if(!file.exists("hpc.txt")) {
    cat("hpc.txt doesn't exist")
    download.file(url.data, "hpc.zip",quiet = TRUE)
    unzip("hpc.zip")
    file.rename("household_power_consumption.txt", "hpc.txt")
    file.remove("hpc.zip")
}

# Load the total dataset in memory
hpc <- read.table("./hpc.txt", header=TRUE, sep=";", na.strings=c("?"))

# Create the subset dataset
hpc_sub <- subset(hpc, Date == "1/2/2007" | Date == "2/2/2007",Date:Sub_metering_3)

# Remove full dataset from memory
rm(hpc)

# Create additional column combining 'Date' and 'Time' column to
# 'DateTime' (POSIXlt format)
hpc_sub$DateTime <- as.POSIXct(paste(hpc_sub$Date, hpc_sub$Time), format = "%d/%m/%Y %H:%M:%S")

# Convert the 'Date' column to Date format
hpc_sub$Date <- as.Date(hpc_sub[,1],"%d/%m/%Y")

# Convert the 'Time' column to POSIXct format
hpc_sub$Time <- strptime(hpc_sub[,2], "%H:%M:%S")

# Open the png graphic device
png(filename = "plot3.png", width = 480, height = 480, bg = "transparent")

# Create the line plot
plot(hpc_sub$DateTime, hpc_sub$Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "l")
points(hpc_sub$DateTime, hpc_sub$Sub_metering_2, col = "red", type = "l")
points(hpc_sub$DateTime, hpc_sub$Sub_metering_3, col = "blue", type = "l")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = c(1, 1, 1))

# Close the graphic device, which saves the png file
dev.off()

# Clean up - Remove url.data from memory
rm(url.data)

