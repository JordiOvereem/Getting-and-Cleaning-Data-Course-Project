## Peer Graded Assignment: Getting and CLeaning Data Course Project - JOOV
## You should create one R script called run_analysis.R that does the following.
## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names. 
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# START
library(reshape2)
setwd("C:/Users/joov2/Desktop/ProgrammingAssignment Getting and Cleaning Data")
file <- "dataset.zip"

# DOWNLOAD AND UNZIP FILE, LOAD ACTIVITY LABELS AND FEATURES
if (!file.exists(file)) {
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, file)
}

if (!file.exists("UCI HAR Dataset")) {
  unzip(file)
}

actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
actLabels[,2] <- as.character(actLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# EXTRACT MEASUREMENTS ON MEAN AND STANDARD DEVIATION
data_needed <- grep(".*mean.*|.*std.*", features[,2])
data_needed.names <- features[data_needed,2]
data_needed.names = gsub('-mean', 'Mean', data_needed.names)
data_needed.names = gsub('[-()]', '', data_needed.names)

# LOAD, MERGE, AND LABEL TRAINING AND TEST DATA
training <- read.table("UCI HAR DATASET/train/X_train.txt") [data_needed]
trainingAct <- read.table("UCI HAR DATASET/train/Y_train.txt")
trainingSubj <- read.table("UCI HAR Dataset/train/subject_train.txt")
training <- cbind(trainingSubj, trainingAct, training)

test <- read.table("UCI HAR DATASET/test/X_test.txt") [data_needed]
testAct <- read.table("UCI HAR DATASET/test/Y_test.txt")
testSubj <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubj, testAct, test)

data <- rbind(training, test)
colnames(data) <- c("Subject", "Activity", data_needed.names)

# TURN ACTIVITIES AND SUBJECTS INTO FACTORS + WRITE TABLE
data$Activity <- factor(data$Activity, levels = actLabels[,1], labels = actLabels[,2])
data$Subject <- as.factor(data$Subject)
data_melted <- melt(data, id=c("Subject", "Activity"))
data_mean <- dcast(data_melted, Subject + Activity ~ variable, mean)

write.table(data_mean, "tidy.txt", row.names = FALSE, quote = FALSE)





