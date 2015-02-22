library(dplyr, warn.conflicts=FALSE)

## see what is there
## assume all the data is in the directory of "./data/UCI HAR Dataset/" from the working directory
list.files("./data", recursive=TRUE)


## read in the feature labels (will be used for both test and training data)
FeatureLabels <- read.table("./data/UCI HAR Dataset/features.txt")
names(FeatureLabels) <- c("FeatureID", "Feature")


## read in the obvservations for the test data
TestDataSet <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
## now name the test data variables using the feature labels
names(TestDataSet) <- FeatureLabels$Feature

## read in the activity label for each observation of the test data
TestActivityLabelCode <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
## name the ActivityID variable of the TestActivityLabels
names(TestActivityLabelCode) <- "ActivityID"

## read in the code for which subject was associated with each test observation
TestSubjectCode <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
## name the SubjectID variable of the TestSubjectsCodes
names(TestSubjectCode) <- "SubjectID"


## read in the obvservations for the training data
TrainDataSet <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
## now name the training data variables using the feature labels
names(TrainDataSet) <- FeatureLabels$Feature

## read in the activity label for each observation of the training data
TrainActivityLabelCode <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
## name the ActivityID variable of the TrainActivityLabels
names(TrainActivityLabelCode) <- "ActivityID"

## read in the code for which subject was associated with each training observation
TrainSubjectCode <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
## name the SubjectID variable of the TrainSubjectsCodes
names(TrainSubjectCode) <- "SubjectID"



## 1. merge the test and traing data sets to make one data set
DataSet <- rbind(data.frame(TestSubjectCode, TestActivityLabelCode, TestDataSet),
                 data.frame(TrainSubjectCode, TrainActivityLabelCode, TrainDataSet))


## 2. extract only the mean and std of each variable observation
DataSet <- DataSet %>% select(SubjectID, ActivityID, matches("*\\.mean\\.|*\\.std\\."))


## read in the activity labels
ActivityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
## name the activity variable labels
names(ActivityLabels) <- c("ActivityID", "Activity")
## 3. merge the activity labels to the main data set
DataSet <- merge(DataSet, ActivityLabels)


## 4. appropriately label the data set with descriptive variable names
## get the current feature variable names
varNames <- names(DataSet)[-(1:2)]
## change leading t to Time (for time based variables)
varNames <- sub("^t", "Time", varNames)
## change leading f to Freq (for frequency based variables)
varNames <- sub("^f", "Freq", varNames)
## clean up the doubled
varNames <- sub("BodyBody", "Body", varNames)
## finish cleaning
varNames <- sub(".mean..", "Mean", varNames)
varNames <- sub(".std..", "Std", varNames)
varNames <- sub(".X", "X", varNames)
varNames <- sub(".Y", "Y", varNames)
varNames <- sub(".Z", "Z", varNames)
## now rename the data set with descriptive variable names
names(DataSet)[-(1:2)] <- varNames


## 5. create independent tidy data set with average of each variable for each activity and each subject
IndTidyData <- DataSet %>% select(-matches("ActivityID")) %>%
    group_by(SubjectID, Activity) %>% summarise_each(funs(mean))


## 6. write table of the independent tidy data to text file
write.table(IndTidyData, "IndependentTidyData.txt", row.name=FALSE)
