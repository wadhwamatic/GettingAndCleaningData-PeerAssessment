# Getting and Cleaning Data: Course project for Amit Wadhwa, April 2014

# See README.md for further instructions and CodeBook.md for documenation of final tiny data

# Assume data is extracted to folder as noted below:
setwd("data/UCI HAR Dataset")

# This function extracts the training data from 3 files

getTrainingData <- function() {
        # get column headers from features file
        dataCols <- read.table("features.txt", header=FALSE, as.is=TRUE, col.names=c("MeasureID", "MeasureName"))
        
        # get subject data
        filePath <- file.path("train/subject_train.txt")
        subjectData <- read.table(filePath, header=FALSE, col.names=c("SubjectID"))
        
        # get y data
        filePath <- file.path("train/y_train.txt")
        yData <- read.table(filePath, header=FALSE, col.names=c("ActivityID"))
        
        # get x data
        filePath <- file.path("train/X_train.txt")
        trainingData <- read.table(filePath, header=FALSE, col.names=dataCols$MeasureName)
        
        # add the activity id and subject id columns
        trainingData$ActivityID <- yData$ActivityID
        trainingData$SubjectID <- subjectData$SubjectID
        
        # return the data
        trainingData
}

# This function extracts the test data from 3 files

getTestData <- function() {
        # get column headers from features file
        dataCols <- read.table("features.txt", header=FALSE, as.is=TRUE, col.names=c("MeasureID", "MeasureName"))
        
        # get subject data
        filePath <- file.path("test/subject_test.txt")
        subjectData <- read.table(filePath, header=FALSE, col.names=c("SubjectID"))
        
        # get y data
        filePath <- file.path("test/y_test.txt")
        yData <- read.table(filePath, header=FALSE, col.names=c("ActivityID"))
        
        # get x data
        filePath <- file.path("test/X_test.txt")
        testData <- read.table(filePath, header=FALSE, col.names=dataCols$MeasureName)
        
        # add the activity id and subject id columns
        testData$ActivityID <- yData$ActivityID
        testData$SubjectID <- subjectData$SubjectID
        
        # return the data
        testData
}


# 1. Merge the training and the test sets to create one data set.

mergeData <- function() {
        # merge datasets (add rows using rbind)
        masterData <- rbind(getTrainingData(), getTestData())
        masterData
}

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

extractData <- function(data) {
        
        # create vector of columns to keep based on mean and std.deviation
        cNames <- colnames(data)
        colKeep <- grep("mean|std",cNames,ignore.case=TRUE, value=TRUE)
                
        # for later steps, need to keep the activity and subject IDs
        #colKeep <- paste(colKeep, "ActivityID", "SubjectID")
        
        keepMore <- c("ActivityID", "SubjectID")
        colKeep <- append(keepMore, colKeep)
        
        # create data frame with just columns for activity, subject, mean & std.deviation vars
        reducedData <- data[, colKeep]
        reducedData
}

# 3. Use descriptive activity names to name the activities in the data set
# &
# 4. Appropriately label the data set with descriptive activity names

addActivityLabel <- function(data) {
        # open labels and assign column names
        
        activityLabels <- read.table("activity_labels.txt", header=FALSE, as.is=TRUE, col.names=c("ActivityID", "ActivityName"))
        activityLabels$ActivityName <- as.factor(activityLabels$ActivityName)
        
        # merge on ActivityID (default ok here)
        act <- merge(activityLabels, data)
        act
}

# 5. Create a second, independent tidy data set with the average of each variable for each 
#    activity and each subject. Save the tidy data.

# This function melts and recasts the working dataset to form a tidy dataset
createTidyData <- function(data) {
        library(reshape2)
        
        # provide input variables for melt function
        identifiers = c("ActivityID", "ActivityName", "SubjectID")
        
        # set all the other variables as measurements
        measurements = setdiff(colnames(data), identifiers)
        
        # melt it!
        meltData <- melt(data, id=identifiers, measure.vars=measurements)
        
        # recast the melted data with mean values by subject and activity 
        tidyData <- dcast(meltData, SubjectID +  ActivityID + ActivityName ~ variable, mean) 
        
        # save the output data
        exportTinyData(tidyData)
        tidyData
}

# write the tidy data
exportTinyData <- function(data) {
        write.table(data, file = "tidydata.txt")
}