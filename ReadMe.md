 # run_analysis.R

  Author:  Lawrence Brown
  Date:    11 Oct 2020

  Scripts for processing data from:
  Human Activity Recognition Using Smartphones Dataset
  Version 1.0

  Source data for the scripts:
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

  A full description is available at the site where the data was obtained:
  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


### tidyColumnNames

#### Data Output
`tidyColumnNames` takes a vector of character strings and returns the vector with all the punctuation removed from each string
  
#### Usage
>`tidyColumnNames(colNames)`

#### Arguments 
**colNames** - A vector of character strings

#### Details 
Removes the following characters:
! ' # S % & ' ( ) * + , - . / : ; < = > ? @ [ / ] ^ _ { | } ~

###  getActivityLabels

#### Data Output
`getActivityLabels` reads the activity labels from a file and returns as a data frame of activities. 

```
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING
```
#### Usage
>`getActivityLabels(fname)`

#### Arguments
**fname** - Name of file to read with activity labels, e.g. `activity_labels.txt`

### extractColumns

#### Data Output
`extractColumns` subset data frame to extract only those columns specified by a regex search string on the column names    

#### Usage
```
extractColumns(searchString, dataFrame)
extractColumns(searchString = "mean", dataFrame)
```
  
#### Arguments 
**searchString** - String defining search criteria identifying columns to return, e.g., "[mean()|std()]"

**dataFrame** - Data frame in which to extract columns

#### Details
Format for regex is perl. 

### addSubjectData 

#### Data Output 
`addSubjectData` adds the subject information from both the train and test groups in a returned data frame.  Returns original data frame with subject data added as first column.
  
#### Usage
```
addSubjectData(fname_train, fname_test, dataFrame, nrow = 20) 
addSubjectData(fname_train, fname_test, dataFrame)
```
  
#### Arguments
**nrow** - Number of rows to read from input files. Default is -1 (all rows). 

#### Details
Subject id data is added as the first column of the data frame with column name 'subject'

### addActivityData 

#### Data Output 
`addActivityData` adds the training activities for each subject from both the 
training and test groups. Returns the original data frame with activity data added as first column.

#### Usage
```
addActivityData(fname_train, fname_test, fname_activity, dataFrame, nrow = 20) 
addActivityData(fname_train, fname_test, fname_activity, dataFrame)
```

#### Arguments
**fname_train**     Training set of activities, e.g. "y_train.txt"
 
**fname_test**      Test set of activities, e.g., "y_test.txt"

**fname_activity** - Activity labels that map from an acitivity id (1, 2, 3,...) to a meaningful label (WALKING, WALKING_UPSTAIRS)

**dataFrame** - Data frame in which to add activity information

**nrow** - Number of rows to read from input files.  Default is -1 (all rows). 

#### Details
Activity is added to the first column of the provided data frame with column name 'activity'.  The activities are converted to categories (factors).  

### addColumnNames 

#### Data Output 
`addColumnNames` sets the column names for all the features in the data frame. Returns the original data frame with column names set base on information in the features file. 

#### Usage
>`addColumnNames(fname, dataFrame)`

#### Arguments

**fname** - List of features in which assign the column names, e.g., "features.txt"

**dataFrame** - Data frame in which to assign column names

#### Details

Assumes that the data frame is the raw data, such that 1st column in the  data frame corresponds to the first feature.  The column names should be set before adding any other columns to the data frame. 

###  buildAveFeatureDataFrame 

#### Data Output
`buildAveFeatureDataFrame` builds a data frame that summarizes the mean features for each individual based on activity. Returns a new data frame with features means grouped by individual and activity. 
  
#### Usage
>`buildAveFeatureDataFrame(dataFrame)`

#### Arguments

**dataFrame** - Data frame in which to summarize the features means 

#### Details
The column name for the features are modified by adding 'm' to the beginning of the column (feature), indicating mean. 

###  getData 

#### Data Output 
`getData` retrieves the training data and testing data as a data frame, appending the test data after the train data. 

#### Usage
```
getData(fname_train, fname_test, nrow = 20) 
getData(fname_train, fname_test)
```

#### Arguments 
**fname_train** - Training file data
 
**fname_test** - Test file data  

**nrow** - Number of rows to read from input files. Default is -1 (all rows).

### readData 

#### Data Output 
`readData`  Reads a text file of data and returns the result as a data frame. 

#### Usage
```
readData(fname, header = TRUE, nrow = 20) 
readData(fname)
```

#### Arguments
**fname** - Text file to read
 
**header** - Boolean whether the file has header row.  Default is FALSE. 

**nrow** - Nnumber of rows to read from input file. Default is -1 (all rows).

###  writeDataFrame 

#### Data Output
`writeData`  Writes a data frame to an output file as text. 

#### Usage
>`writeData(df, fname)` 

#### Arguments

**df** - Data frame to write to file

**fname** - Name of the file to write
 
#### Details
The data is written comma separated.  Column names are written to the file, but not row names.

####  buildDataFrame 

#### Data Output
`buildDataFrame`  Creates a tidy data (data frame) from the Human Activity Recognition Using Smartphones Dataset

#### Usage
```
buildDataFrame(fname_colnames, fname_activityLabels, fname_train, fname_test, 
               fname_trainActivity, fname_testActivity, fname_trainSubject, 
               fname_testSubject, strexp = "mean", nrow=20) 
buildDataFrame(fname_colnames, fname_activityLabels, fname_train, fname_test, 
               fname_trainActivity, fname_testActivity, fname_trainSubject, 
               fname_testSubject)
```

#### Arguments 
**fname_colnames** - List of features in which assign the column names, e.g., "features.txt"

**fname_activityLabels** - Activity labels that map from an acitivity id (1, 2, 3,...) to a meaningful label (WALKING, WALKING_UPSTAIRS)

**fname_train** - Training set of activities, e.g. "X_train.txt"
 
**fname_test** - Test set of activities, e.g., "X_test.txt"

**fname_trainActivity** - Training set of activity ids, e.g., "y_train.txt".

**fname_testActivity** - Training set of activity ids, e.g., "y_test.txt".
 
**fname_trainSubject** - Training set of subject ids, e.g. "subject_train.txt"

**fname_testSubject** - Test set of subject ids, e.g. "subject_test.txt"

**strexp** - String filter for features (columns to keep). Default value is "mean\\(\\)|std\\(\\)"

**rnow** - The number of rows to process from the Smartphones Dataset. Default is -1, all rows.  

**Details**
Merges the training and the test sets to create one data set.
Appropriately labels the data set with descriptive variable names for columns.
Extracts only the measurements on the mean and standard deviation for each measurement.
Adds subject information to the data set. 
Adds activity information for each subject to the data set.  

### unitTest

Simple unit test of scripts looking at only 20 rows of Smartphone data. 

### unitTest2

Unit test of scripts looking at all SmartPhone data. 
