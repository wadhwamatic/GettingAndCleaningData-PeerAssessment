How to utilize the run_analysis.R functions

===========
 
The data used for this analysis was collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data will be referred to as the UCI HAR dataset.


### The raw data

To obtain the raw data and it’s associated documentation, visit here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 


### Required packages

The analysis requires the reshape2 library for the final steps which melt and cast the final tidy data


### Description of R function

The file run_analysis.R contains the following functions (and a brief description of each):

1. getTrainingData: extracts training data from the subject, x and y training files in the UCI HAR dataset
2. getTestData: extracts training data from the subject, x and y test files in the UCI HAR dataset
3. mergeData: merges the training and test data; calls functions 1 & 2 above
4. extractData: subsets the relevant columns from the merged data created by the mergeData function; only mean and std deviation variables kept along with identifiers
5. addActivityLabel: adds readable text describing the activities in the merged dataset, utilizing activity_labels.txt from the UCI HAR data files
6. createTidyData: takes the labeled dataset created in the addActivityLabel functions as an input; melts the data with identifiers and measurements separated; all measurements columns have their mean calculated by activity and subject and the data is restructured using the dcast function; this function calls exportTinyData as the final step
7. exportTinyData: simply takes the data from createTidyData and writes it to a text file called tidydata.txt


### Steps

The following steps should be followed to generate the final tidy dataset

1. Create a data frame which contains a merger of the test and training datasets by assigning the output of mergeData() to the object.  For example: >  data <- mergeData()
2. Create a subset of the data from the step above which includes just variables with “mean” or “std” (standard deviation) as measurement variables and identifiers (ActivityID and SubjectID).  This is done using the extractData() function.  For example:>  data2 <- extractData(data)
3. Add descriptive labels to the activities by merging the activity_labels.txt file to the extracted dataset using the addActivityLabel function.  Example:>  actData <- addActivityLabel(data2)
4. Get the mean value for each measurement in the dataset by Activity and Subject  using the createTidyData function.  This function expects the dataset as an argument and then returns the tidy data and saves it to a file called “tidydata.txt” in the current working directory.  Ex: >  tidyData <- createTidyData(actData)
