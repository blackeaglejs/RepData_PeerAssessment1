## Set working directory. You can set this to whatever you want. 
setwd("~/dev/datasciencecoursera/RepData_PeerAssessment1")

## Load knitr package (in case you don't already have it.) 
install.packages("knitr")
library(knitr)

## Download the data.
fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(fileUrl, "repdata_data_activity.zip", method="curl")

## Unzip the data. 
unzip("repdata_data_activity.zip")

## Read in the data 
activity_data <- read.csv("activity.csv")

## Convert the "date" variable to date class.
activity_data$date <- as.Date(activity_data$date)

## Create a histogram of steps by day. 
steps_by_day <- tapply(activity_data$steps, activity_data$date, FUN=sum, na.rm=TRUE)
hist(steps_by_day, main = "Steps per day", xlab = "Number of Steps", ylab= "Number of Days")

## Calculate the mean and median steps per day. 
mean(steps_by_day)
median(steps_by_day)

## Create a time series plot. 
steps_by_interval <- tapply(activity_data$steps, activity_data$interval, FUN=mean, na.rm = TRUE)
plot(steps_by_interval, 
     type="l", 
     main="Steps during each interval", 
     xlab = "Interval", 
     ylab = "Average steps taken")

## Get the interval with the maximum.
max_index <- activity_data$interval[which.max(steps_by_interval)]

## Calculate the number of NAs in the dataset.
NA_values <- is.na(activity_data$steps)
NA_count <- sum(NA_values)

## Replace the missing value with the mean for that interval. 
## I am going to use the dplyr package as other solutions are too cumbersome at this point.
library(dplyr)

activity_data_grouped <- activity_data %>%
      group_by(interval) %>%
      summarize(mean_steps_per_day=mean(steps))

activity_data_replaced <- activity_data

for (i in 1:nrow(activity_data_replaced)) {
      if (is.na(activity_data_replaced$steps[i])) {
            # Find the index value for when the interval matches the average
            index_value <- which(activity_data_replaced$interval[i] == activity_data_grouped$interval)
            # Assign the value to replace the NA
            activity_data_replaced$steps[i] <- activity_data_grouped[index_value,]$mean_steps_per_day
      }
}

## Make sure the date is still a date. 
activity_data_replaced$date <- as.Date(activity_data_replaced$date)

## Plot a new histogram. 
activity_data_replaced_by_day <- activity_data_replaced %>%
      group_by(date) %>%
      summarize(step_sum=sum(steps))

hist(activity_data_replaced_by_day$step_sum, 
     xlab = "Number of steps",
     ylab = "Number of days",
     main = "Steps per day")

## Get the mean and median.
activity_data_repl_mean <- mean(activity_data_replaced_by_day$step_sum, na.rm=TRUE)
activity_data_repl_median <- median(activity_data_replaced_by_day$step_sum, na.rm=TRUE)
