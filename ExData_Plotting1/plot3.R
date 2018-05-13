### Exploratory Data Analysis, Coursera, Project 1, Plot 3.

## To run the script, place the "plot3.R" file in the current working directory.
## To run the script in RStudio, type in the console:
#source('plot3.R')

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


# Make a plot and save it as "plot3.png" file in the working directory----------
png(filename = "plot3.png", width=480, height=480)

# Make multi-line plot----------------------------------------------------------
plot(strptime(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S"),
     data$Sub_metering_1, type="l", xlab='',
     ylab="Energy sub metering")

lines(strptime(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S"),
      data$Sub_metering_2, col='red')

lines(strptime(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S"),
      data$Sub_metering_3, col='blue')

# Add a legend to the plot------------------------------------------------------
legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty=c(1,1,1), lwd=c(1,1,1))

dev.off()


