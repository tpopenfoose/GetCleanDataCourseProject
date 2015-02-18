library(dplyr, warn.conflicts=FALSE)

# see what is there
list.files("./data", recursive=TRUE)


##########################################################################################

ActivityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
names(ActivityLabels) <- c("ActivityID", "Activity")
ActivityLabels

FeatureLabels <- read.table("./data/UCI HAR Dataset/features.txt")
names(FeatureLabels) <- c("FeatureID", "Feature")
str(FeatureLabels)

FeatureLabels %>% filter(grepl("-mean\\()|-std\\()", Feature))

###########################################################################################

TestDataSet <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
names(TestDataSet) <- FeatureLabels$Feature
names(TestDataSet)
str(TestDataSet)
summary(TestDataSet)
dim(TestDataSet)
head(TestDataSet)

TestActivityLabelCode <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
head(TestActivityLabelCode)
dim(TestActivityLabelCode)
summary(TestActivityLabelCode)
unique(TestActivityLabelCode)
table(TestActivityLabelCode, useNA="ifany")
dim(TestActivityLabelCode)
names(TestActivityLabelCode) <- "ActivityID"

TestSubjectCode <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
table(TestSubjectCode, useNA="ifany")
dim(TestSubjectCode)
unique(TestSubjectCode)
dim(TestSubjectCode)
head(TestSubjectCode)
names(TestSubjectCode) <- "SubjectID"

names(TestDataSet)
head(data.frame(TestSubjectCode, TestActivityLabelCode, TestDataSet))
##########################################################################################

TrainDataSet <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
names(TrainDataSet) <- FeatureLabels$Feature
names(TrainDataSet)
str(TrainDataSet)
summary(TrainDataSet)

TrainActivityLabelCode <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
head(TrainActivityLabelCode)
dim(TrainActivityLabelCode)
summary(TrainActivityLabelCode)
unique(TrainActivityLabelCode)
table(TrainActivityLabelCode, useNA="ifany")
names(TrainActivityLabelCode) <- "ActivityID"

TrainSubjectCode <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
table(TrainSubjectCode, useNA="ifany")
dim(TrainSubjectCode)
unique(TrainSubjectCode)
names(TrainSubjectCode) <- "SubjectID"

TrainDataSet$Subject=TrainSubjectCode
TrainDataSet$ActivityLabelCode=TrainActivityLabelCode
names(TrainDataSet)

##########################################################################################

DataSet <- rbind(data.frame(TestSubjectCode, TestActivityLabelCode, TestDataSet),
                 data.frame(TrainSubjectCode, TrainActivityLabelCode, TrainDataSet))
dim(DataSet)
DataSet <- merge(DataSet, ActivityLabels)
head(DataSet)
##########################################################################################

dim(DataSet)

newDF <- DataSet %>% select(SubjectID, Activity, matches("*\\.mean\\.|*\\.std\\.")); names(newDF)
head(newDF)
summary(newDF)
unique(names(newDF))
names(newDF)
sum(duplicated(names(newDF)))

varNames <- names(newDF)[-(1:2)]
varNames
varNames <- sub("^t", "Time", varNames)
varNames <- sub("^f", "Freq", varNames)
varNames <- sub("BodyBody", "Body", varNames)
varNames <- sub(".mean..", "Mean", varNames)
varNames <- sub(".std..", "Std", varNames)
varNames <- sub(".X", "X", varNames)
varNames <- sub(".Y", "Y", varNames)
varNames <- sub(".Z", "Z", varNames)
names(newDF)[-(1:2)] <- varNames

#########################################################################################
dim(newDF)
IndTidyData <- newDF %>% group_by(SubjectID, Activity) %>% summarise_each(funs(mean))
write.table(IndTidyData, "IndependentTidyData.txt", row.name=FALSE)
dim(IndTidyData)
unique(IndTidyData$SubjectID)
unique(IndTidyData$Activity)
summary(IndTidyData)

##########################################################################################

df <- read.table("IndependentTidyData.txt", header = TRUE)
View(df)
dim(df)  # 180 68
unique(df[ , 1])  # 1:30
unique(df[ , 2])  # Levels: LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS WALKING_UPSTAIRS
names(df)
