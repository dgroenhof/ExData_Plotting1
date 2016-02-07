###########################################################
# File:     plot1.R
# Purpose:  Creates plot1.png for Course Project 1
#           for Exploratory Data Analysis - Week 1
# Version:  1.0
# Input:    ZIP file containing Electric power 
#           consumption dataset
# Output:   plot1.png
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
png(filename = "plot1.png", width = 480, height = 480, bg = "transparent")

# Create the histogram
hist(hpc_sub$Global_active_power, xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "red", main = "Global Active Power")

# Close the graphic device, which saves the png file
dev.off()

# Clean up - Remove url.data from memory
rm(url.data)

