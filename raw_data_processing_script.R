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
hist(steps_by_day)

## Calculate the means for each day. 
tapply(activity_data$steps, activity_data$date, FUN=mean, na.rm=TRUE)
