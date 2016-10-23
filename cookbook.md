# Code Book

Summarises the data fields in `tidy.txt`.

## Identifiers

* `subject` - ID of the test subject
* `activity` - Activity performed when the corresponding measurements were taken

## Data Transformations

```
library(data.table)
library(tidyr)
library(dplyr)
```
Load Libraries

```
pathIn <- file.path(path, ".")
dataSubjectTrain <- fread(file.path(pathIn, "train", "subject_train.txt"))
dataSubjectTest <- fread(file.path(pathIn, "test", "subject_test.txt"))

dataActivityTrain <- fread(file.path(pathIn, "train", "Y_train.txt"))
dataActivityTest <- fread(file.path(pathIn, "test", "Y_test.txt"))

dataTrain <- fread(file.path(pathIn, "train", "X_train.txt"))
dataTest <- fread(file.path(pathIn, "test", "X_test.txt"))
```
Fetch the data

```
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(dataSubject, "V1", "subject")
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
setnames(dataActivity, "V1", "activityNum")
```

```
dataSubject <- cbind(dataSubject, dataActivity)
data <- rbind(dataTrain, dataTest)
```
Merge the data sets and rename some columns


```
dataActivityNames <- fread(file.path(pathIn, "activity_labels.txt"))
setnames(dataActivityNames, names(dataActivityNames), c("activityNum", "activityName"))

dataSubject <- merge(dataSubject, dataActivityNames, by = "activityNum", all.x = TRUE)

dataFeatures <- fread(file.path(pathIn, "features.txt"))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))

```
Attach the labels




```
dataFeatures <- dataFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]
dataFeatures$featureCode <- dataFeatures[, paste0("V", featureNum)]

data <- data[, dataFeatures$featureCode, with = FALSE]  

data <- cbind(dataSubject, data)

setnames(data, dataFeatures$featureCode, dataFeatures$featureName)
```
Only choose the required firelds


```
tidy = melt(data, c("activityNum","subject","activityName"))
tidy <- dcast(tidy, subject + activityNum ~ variable, mean)
```
Create tidy data by melting data based on activies and subject then recasting it into means

```
write.table(tidy, "tidy.txt", row.names = FALSE, quote = FALSE)
```
Output the file

## Data Measurements

* `tBodyAccMeanX`
* `tBodyAccMeanY`
* `tBodyAccMeanZ`
* `tBodyAccStdX`
* `tBodyAccStdY`
* `tBodyAccStdZ`
* `tGravityAccMeanX`
* `tGravityAccMeanY`
* `tGravityAccMeanZ`
* `tGravityAccStdX`
* `tGravityAccStdY`
* `tGravityAccStdZ`
* `tBodyAccJerkMeanX`
* `tBodyAccJerkMeanY`
* `tBodyAccJerkMeanZ`
* `tBodyAccJerkStdX`
* `tBodyAccJerkStdY`
* `tBodyAccJerkStdZ`
* `tBodyGyroMeanX`
* `tBodyGyroMeanY`
* `tBodyGyroMeanZ`
* `tBodyGyroStdX`
* `tBodyGyroStdY`
* `tBodyGyroStdZ`
* `tBodyGyroJerkMeanX`
* `tBodyGyroJerkMeanY`
* `tBodyGyroJerkMeanZ`
* `tBodyGyroJerkStdX`
* `tBodyGyroJerkStdY`
* `tBodyGyroJerkStdZ`
* `tBodyAccMagMean`
* `tBodyAccMagStd`
* `tGravityAccMagMean`
* `tGravityAccMagStd`
* `tBodyAccJerkMagMean`
* `tBodyAccJerkMagStd`
* `tBodyGyroMagMean`
* `tBodyGyroMagStd`
* `tBodyGyroJerkMagMean`
* `tBodyGyroJerkMagStd`
* `fBodyAccMeanX`
* `fBodyAccMeanY`
* `fBodyAccMeanZ`
* `fBodyAccStdX`
* `fBodyAccStdY`
* `fBodyAccStdZ`
* `fBodyAccMeanFreqX`
* `fBodyAccMeanFreqY`
* `fBodyAccMeanFreqZ`
* `fBodyAccJerkMeanX`
* `fBodyAccJerkMeanY`
* `fBodyAccJerkMeanZ`
* `fBodyAccJerkStdX`
* `fBodyAccJerkStdY`
* `fBodyAccJerkStdZ`
* `fBodyAccJerkMeanFreqX`
* `fBodyAccJerkMeanFreqY`
* `fBodyAccJerkMeanFreqZ`
* `fBodyGyroMeanX`
* `fBodyGyroMeanY`
* `fBodyGyroMeanZ`
* `fBodyGyroStdX`
* `fBodyGyroStdY`
* `fBodyGyroStdZ`
* `fBodyGyroMeanFreqX`
* `fBodyGyroMeanFreqY`
* `fBodyGyroMeanFreqZ`
* `fBodyAccMagMean`
* `fBodyAccMagStd`
* `fBodyAccMagMeanFreq`
* `fBodyBodyAccJerkMagMean`
* `fBodyBodyAccJerkMagStd`
* `fBodyBodyAccJerkMagMeanFreq`
* `fBodyBodyGyroMagMean`
* `fBodyBodyGyroMagStd`
* `fBodyBodyGyroMagMeanFreq`
* `fBodyBodyGyroJerkMagMean`
* `fBodyBodyGyroJerkMagStd`
* `fBodyBodyGyroJerkMagMeanFreq`

## Activity Labels

* `WALKING` (value `1`): walking during the test
* `WALKING_UPSTAIRS` (value `2`): walking up a staircase during the test
* `WALKING_DOWNSTAIRS` (value `3`): walking down a staircase during the test
* `SITTING` (value `4`): sitting during the test
* `STANDING` (value `5`): standing during the test
* `LAYING` (value `6`): laying down during the test
