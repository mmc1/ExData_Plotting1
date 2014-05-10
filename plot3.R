# Download and unzip energy data file, then read as table into a dataframe
download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile="data.zip")
unzip("data.zip")
filename <- "household_power_consumption.txt"
colclasses <- c("character", "character", rep("numeric", 7))
df <- read.table(filename, header=TRUE, sep=";", na.strings="?", colClasses=colclasses)

# Convert date and time characters into POSIXct date/time variable and add to dataframe
df$datetime <- as.POSIXct(strptime(paste(df$Date, df$Time), format="%d/%m/%Y %H:%M:%S"))

# Subset the dataframe to the 2 days fo interest
start <- as.POSIXct(strptime("2007-02-01 00:00:00", format="%Y-%m-%d %H:%M:%S"))
end <- as.POSIXct(strptime("2007-02-03 00:00:00", format="%Y-%m-%d %H:%M:%S"))
dfs <- subset(df, subset=df$datetime>=start & df$datetime<end & !is.na(df$datetime))

# Remove large df from memory and save the subsetted df for later use if needed
# so you don't have to always read from the large dataset.
rm(df)
save(dfs, file="subset.RData")

# Create figure as png file
png(filename="figure\\plot3.png", width=480, height=480)
plot(dfs$datetime, dfs$Sub_metering_1, 
     xlab="",
     ylab="Energy sub metering",
     type="l",
     col="black")
lines(dfs$datetime, dfs$Sub_metering_2, col="red")
lines(dfs$datetime, dfs$Sub_metering_3, col="blue")
legend("topright", lty=1, col=c("black", "red", "blue"), legend=c(names(dfs)[7:9]))
dev.off()
