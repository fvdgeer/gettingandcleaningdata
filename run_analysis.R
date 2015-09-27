# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Data File: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Data Desc: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Part 0: Prepare
library(dplyr)
setwd("c:/klant/coursera/getting and cleaning data/data")
destinationDir = "./UCI HAR Dataset"
if (dir.exists(destinationDir)) {
    unlink(destinationDir, recursive = TRUE)
}

# Get the data
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url = dataUrl, destfile = "./UCI HAR Dataset.zip", mode="wb")
unzip("./UCI HAR Dataset.zip", exdir=".")

# The column names of the dataset have been provided in a separate file; get them
featureNames <- read.table(file="./UCI HAR Dataset/features.txt", col.names = c("FeatureId", "FeatureName"), colClasses = c("integer", "character"), header=FALSE)
# Transform the exact names into valid column names:
# a. remove ()
# b. remove trailing )
# c. replace any of the remaining characters -,() by _
# Note: this is for task #4
featureNames <- mutate(featureNames, ColumnName=gsub("[-,()]", "_", gsub(")$", "", gsub("()", "", FeatureName, fixed = TRUE))))

# The activity names have been specified in a separate data file
activityNames <- read.table(file="./UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityId", "ActivityName"), colClasses = c("integer", "character"), header=FALSE)

# Read the training dataset
trainSubjects <- read.table(file="./UCI HAR Dataset/train/subject_train.txt", col.names = "SubjectId", colClasses = c("integer"), header=FALSE)
trainActivities <- read.table(file="./UCI HAR Dataset/train/y_train.txt", col.names = "ActivityId", colClasses = c("integer"), header=FALSE)
trainFeatures <- read.table(file="./UCI HAR Dataset/train/x_train.txt", col.names = featureNames$ColumnName, colClasses = c("numeric"), header=FALSE, comment.char = "")
trainingSet = cbind(trainFeatures, trainSubjects, trainActivities)

# Read the test dataset
testSubjects <- read.table(file="./UCI HAR Dataset/test/subject_test.txt", col.names = "SubjectId", colClasses = c("integer"), header=FALSE)
testActivities <- read.table(file="./UCI HAR Dataset/test/y_test.txt", col.names = "ActivityId", colClasses = c("integer"), header=FALSE)
testFeatures <- read.table(file="./UCI HAR Dataset/test/x_test.txt", col.names = featureNames$ColumnName, colClasses = c("numeric"), header=FALSE, comment.char = "")
testSet = cbind(testFeatures, testSubjects, testActivities)

#1 Merges the training and the test sets to create one data set.
dataset1 <- rbind(trainingSet, testSet)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
dataset2 <- cbind(select(dataset1, ends_with("mean", ignore.case = FALSE)), select(dataset1, ends_with("std", ignore.case = FALSE)), select(dataset1, SubjectId, ActivityId))

# 3. Uses descriptive activity names to name the activities in the data set
dataset3 <- merge(dataset2, activityNames, by="ActivityId", suffixes = c("", ".y"))

# 4. Appropriately labels the data set with descriptive variable names. 
# This has already been done during load by specifying col.names

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
meltedSet <- melt(dataset3, id.vars=c("ActivityName", "SubjectId"), measure.vars = 2:19)
tidySet <- dcast(meltedSet, ActivityName + SubjectId ~ variable, mean)
write.table(tidySet, file="./tidySet.txt", row.names = FALSE)