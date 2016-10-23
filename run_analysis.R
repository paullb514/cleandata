library(data.table)
library(tidyr)
library(dplyr)

path <- getwd()

pathIn <- file.path(path, "./UCI HAR Dataset/")
dataSubjectTrain <- fread(file.path(pathIn, "train", "subject_train.txt"))
dataSubjectTest <- fread(file.path(pathIn, "test", "subject_test.txt"))

dataActivityTrain <- fread(file.path(pathIn, "train", "Y_train.txt"))
dataActivityTest <- fread(file.path(pathIn, "test", "Y_test.txt"))

dataTrain <- fread(file.path(pathIn, "train", "X_train.txt"))
dataTest <- fread(file.path(pathIn, "test", "X_test.txt"))

dataMerge = rbind(dataTrain, dataTest)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(dataSubject, "V1", "subject")
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
setnames(dataActivity, "V1", "activityNum")

dataSubject <- cbind(dataSubject, dataActivity)


data <- rbind(dataTrain, dataTest)



dataActivityNames <- fread(file.path(pathIn, "activity_labels.txt"))
setnames(dataActivityNames, names(dataActivityNames), c("activityNum", "activityName"))

dataSubject <- merge(dataSubject, dataActivityNames, by = "activityNum", all.x = TRUE)






dataFeatures <- fread(file.path(pathIn, "features.txt"))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))

dataFeatures <- dataFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]


dataFeatures$featureCode <- dataFeatures[, paste0("V", featureNum)]
head(dataFeatures)

data <- data[, dataFeatures$featureCode, with = FALSE]  

data <- cbind(dataSubject, data)

setnames(data, dataFeatures$featureCode, dataFeatures$featureName)


tidy = melt(data, c("activityNum","subject","activityName"))
tidy <- dcast(tidy, subject + activityNum ~ variable, mean)

write.table(tidy, "tidy.txt", row.names = FALSE, quote = FALSE)
