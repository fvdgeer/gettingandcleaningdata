#codebook for the tidy dataset that is created by the run_analysis.R file

Variables:
ActivityName (character): describes the activity that the person was doing during measurement
SubjectId    (int)      : in the range 1:30 identifying which person did the activity
xxx_mean (numeric)      : mean value for measure xxx
xxx_std: (numeric)      : standard deviation for measure xxx

Summary choises:
The measure values for all observations have been averaged by (ActivityName, SubjectId)
The raw data has been taken from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

More information:
Refer to http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones for further description of the data.
Also refer to Readme.md for all steps that have been applied to create the tidy dataset.