### Exploratory Data Analysis, Coursera, Project 1, Plot 1.

## To run the script, place the "plot1.R" file in the current working directory.
## To run the script in RStudio, type in the console:
#source('plot1.R')

# download and unzip data into working directory--------------------------------
dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataUrl, "power_consumption.zip")
unzip("power_consumption.zip")

### the above code could be skipped (commented out)
### if "household_power_consumption.txt" file is already in the working directory.


# read required data from file--------------------------------------------------
data <- read.table("household_power_consumption.txt",
                   sep=";", dec=".", na.strings="?", nrows=2880, skip=66637)

colnames(data) <- c('Date', 'Time', 'Global_active_power',
                    'Global_reactive_power', 'Voltage', 'Global_intensity',
                    'Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')


# Make a histogram and save it as "plot1.png" file in the working directory-----
png(filename = "plot1.png", width=480, height=480)
hist(data$Global_active_power, col="red", main="Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()


