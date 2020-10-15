 ## run_analysis.R

  Author:  Lawrence Brown
  Date:    11 Oct 2020

  Scripts for processing data from: 
    Human Activity Recognition Using Smartphones Dataset
    Version 1.0

  Source data for the scripts:
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

  A full description is available at the site where the data was obtained:
  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


##  tidyColumnNames

###  Data Output

`tidyColumnNames` takes a vector of character strings and returns the vector with all the punctuation removed from each string
  
###  Usage
>`tidyColumnNames(colNames)`

### Arguments 
**colNames**	a vector of character strings

###  Details 
Removes the following characters:
! ' # S % & ' ( ) * + , - . / : ; < = > ? @ [ / ] ^ _ { | } ~


##  getActivityLabels
`getActivityLabels` reads the activity labels from a file and returns as a data frame of activities. 

1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

### Arguments
>  fname   name of file to read with activity labels, e.g. activity_labels.txt

#  extractColumns

  Subset data frame to extract only those columns specified
  by a regex search string on the column names.    
  
  Arguments: 

     searchString    string defining search criteria identifying
                     columns to return, e.g., "[mean()|std()]"

     dataFrame       data frame in which to extract columns

  Returns: data frame of on only columns specified

  Details:

  Format for regex is perl. 


#  addSubjectData 

  Adds the subject information from both the train and test groups
  to the data frame.    
  
  Arguments: 

     fname_train     Training set of subject ids, e.g. "subject_train.txt"
 
     fname_test      Test set of subject ids, e.g., "subject_test.txt"

     dataFrame       data frame in which to add subject information

     nrow            number of rows to read from input files

  Returns: original data frame with subject data added as first column

  Details:

  Subject id data is added as the first column of the data frame
  with column name 'subject'


#  addActivityData 

  Adds the training activities for each subject from both the 
  training and test groups.
  
  Arguments: 

     fname_train     Training set of activities, e.g. "y_train.txt"
 
     fname_test      Test set of activities, e.g., "y_test.txt"

     fname_activity  Activity labels that map from an acitivity id (1, 2, 3,...)
                     to a meaningful label (WALKING, WALKING_UPSTAIRS)

     dataFrame       data frame in which to add activity information

     nrow            number of rows to read from input files

  Returns:  original data frame with activity data added as first column

  Details:

  Activity is added to the first column of the provided data frame
  with column name 'activity'.  The activities are converted to categories
  (factors).  



#  addColumnNames 

  Sets the column names for all the features in the data frame.
  
  Arguments: 

     fname        List of features in which assign the column names, 
                  e.g., "features.txt"

     dataFrame    data frame in which to assign column names

  Returns:  original data frame with column names set base on information 
            in the features file 

  Details:

  Assumes that the data frame is the raw data, such that 1st column in the
  data frame corresponds to the first feature.  The column names should
  be set before adding any other columns to the data frame. 

#  buildAveFeatureDataFrame 

  Builds a data frame that summarizes the mean features for each individual 
  based on activity.  
  
  Arguments: 

     dataFrame    data frame in which to summarize the features means 

  Returns:  a new data frame with features means grouped by individual
            and activity. 

  Details:

  The column name for the features are modified by adding 'm' to the 
  beginning of the column (feature), indicating mean. 



#  getData 

  Data Output 

  Gets the training data and testing data as a data frame, 
  appending the test data after the train data. 

  Usage
  
     getData(f1, f2, nrow = 20)
	 getData(f1, f2)
  
  Arguments 

     fname_train     Training file data
 
     fname_test      Test file data  

     nrow            number of rows to read from input files



#  readData 

  Reads a text file of data and returns the result as a data frame. 
  
  Arguments: 

     fname     Text file to read
 
     header    Boolean whether the file has header row 

     nrow      number of rows to read from input file

  Returns:  the data from the file as a data frame

#  writeDataFrame 

  Writes a data frame to an output file as text 
  
  Arguments: 

     df        Data frame to write to file

     fname     Name of the file to write
 
     header    Boolean whether the file has header row 

  Details:

  The data is written comma separated.  Column names are written to the 
  file, but not row names. 


#  buildDataFrame 

  Creates a tidy data (data frame) from the 
  Human Activity Recognition Using Smartphones Dataset 
  
  Arguments: 

     fname_colnames         List of features in which assign the column names, 
                            e.g., "features.txt"

     fname_activityLabels   Activity labels that map from an acitivity id (1, 2, 3,...)
                            to a meaningful label (WALKING, WALKING_UPSTAIRS)

     fname_train            Training set of activities, e.g. "X_train.txt"
 
     fname_test             Test set of activities, e.g., "X_test.txt"

     fname_trainActivity    Training set of activity ids, e.g., "y_train.txt".

     fname_testActivity     Training set of activity ids, e.g., "y_test.txt".
 
     fname_trainSubject     Training set of subject ids, e.g. "subject_train.txt"

     fname_testSubject      Test set of subject ids, e.g. "subject_test.txt"

     strexp                 String filter for features (columns to keep)
                            Default value is "mean\\(\\)|std\\(\\)"

     rnow                   The number of rows to process from the Smartphones Dataset.
                            Default is -1, all rows.  

  Returns:  data frame of tidy data from Smartphones Dataset

  Details:

    Merges the training and the test sets to create one data set.
    Appropriately labels the data set with descriptive variable names for columns.
    Extracts only the measurements on the mean and standard deviation for each measurement.
    Adds subject information to the data set. 
    Adds activity information for each subject to the data set.  


# unitTest

 Simple unit test of scripts looking at only 20 rows of data. 

     
# unitTest2

 Unit test of scripts looking at all data. 

