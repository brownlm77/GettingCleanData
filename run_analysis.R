#  run_analysis.R
#
#  Author:  Lawrence Brown
#  Date:    11 Oct 2020
#
#  Scripts for processing data from: 
#    Human Activity Recognition Using Smartphones Dataset
#    Version 1.0
#
#  Source data for the scripts:
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
#  A full description is available at the site where the data was obtained:
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#


library(dplyr)



#  tidyColumnNames
#
#  Removes all punctuation characters from a character string
#
#  Arguments: 
#  
#    colNames     a vector of character strings
#
#  Return:  vector of character strings
#
#  Details: 
#  
#  Removes the following characters:
#      ! ' # S % & ' ( ) * + , - . / : ; < = > ? @ [ / ] ^ _ { | } ~
#

tidyColumnNames <- function(colNames) {
      colNames <- gsub("[[:punct:]]","", colNames)  
      colNames <- tolower(colNames)
      return(colNames)
}

#  getActivityLabels
#  
#  Reads the activity labels from a file and returns as a 
#  data frame. 
#
#  Arguments: 
#
#     fname   name of file to read with activity labels, 
#             e.g. activity_labels.txt
#
#  Returns: data frame of activities
#
#  1 WALKING
#  2 WALKING_UPSTAIRS
#  3 WALKING_DOWNSTAIRS
#  4 SITTING
#  5 STANDING
#  6 LAYING

getActivityLabels <- function(fname) {
        labels <- readData(fname)  
        colnames(labels) <- c("id", "Activity")
        return(labels)
}

#  extractColumns
#
#  Subset data frame to extract only those columns specified
#  by a regex search string on the column names.    
#  
#  Arguments: 
#
#     searchString    string defining search criteria identifying
#                     columns to return, e.g., "[mean()|std()]"
#
#     dataFrame       data frame in which to extract columns
#
#  Returns: data frame of on only columns specified
#
#  Details:
#
#  Format for regex is perl. 
#

extractColumns <- function(searchString, dataFrame) {
        colNames <- colnames(dataFrame)
        keep <- grepl(searchString, colNames, perl=TRUE)
        dataFrame <- dataFrame[,keep]
        return(dataFrame)
}

#  addSubjectData 
#
#  Adds the subject information from both the train and test groups
#  to the data frame.    
#  
#  Arguments: 
#
#     fname_train     Training set of subject ids, e.g. "subject_train.txt"
# 
#     fname_test      Test set of subject ids, e.g., "subject_test.txt"
#
#     dataFrame       data frame in which to add subject information
#
#     nrow            number of rows to read from input files
#
#  Returns: original data frame with subject data added as first column
#
#  Details:
#
#  Subject id data is added as the first column of the data frame
#  with column name 'subject'

addSubjectData <- function(fname_train = fname_trainSubject, 
                           fname_test = fname_testSubject, 
                           dataFrame, nrow=-1) {
        
        # Combine subject data from train and test sets
        trainSubjectData <- readData(fname_train, header=FALSE, nrow=nrow)
        testSubjectData <- readData(fname_test, header=FALSE, nrow=nrow)
        combindedSubjectData <- rbind(trainSubjectData, testSubjectData) 
        
        # Add descriptive column label 
        colnames(combindedSubjectData) <- "subject"        
        
        # Add Subject as first column to data frame
        dataFrame <- cbind(combindedSubjectData, dataFrame)         
        return(dataFrame)       
}

#  addActivityData 
#
#  Adds the training activities for each subject from both the 
#  training and test groups.
#  
#  Arguments: 
#
#     fname_train     Training set of activities, e.g. "y_train.txt"
# 
#     fname_test      Test set of activities, e.g., "y_test.txt"
#
#     fname_activity  Activity labels that map from an acitivity id (1, 2, 3,...)
#                     to a meaningful label (WALKING, WALKING_UPSTAIRS)
#
#     dataFrame       data frame in which to add activity information
#
#     nrow            number of rows to read from input files
#
#  Returns:  original data frame with activity data added as first column
#
#  Details:
#
#  Activity is added to the first column of the provided data frame
#  with column name 'activity'.  The activities are converted to categories
#  (factors).  

addActivityData <- function(fname_train = fname_trainActivity,
                            fname_test = fname_testActivity,
                            fname_activity = fname_activityLabels,
                            dataFrame, nrow=-1) {

        trainActivityData <- readData(fname_train, header=FALSE, nrow=nrow)
        testActivityData <- readData(fname_test, header=FALSE, nrow=nrow)
        
        combindedActivityData <- rbind(trainActivityData, testActivityData)        
        
        # Covert activities to descriptive labels and convert to factor
        labels = getActivityLabels(fname_activity)
        activity <- factor(combindedActivityData[,1], 
                           levels = c(1:nrow(labels)),
                           label = labels$Activity)
        
        # Add Activity as first column to data frame
        dataFrame <- cbind(activity, dataFrame)
        colnames(dataFrame[1]) <- "activity"
        return(dataFrame)        
}

#  addColumnNames 
#
#  Sets the column names for all the features in the data frame.
#  
#  Arguments: 
#
#     fname        List of features in which assign the column names, 
#                  e.g., "features.txt"
#
#     dataFrame    data frame in which to assign column names
#
#  Returns:  original data frame with column names set base on information 
#            in the features file 
#
#  Details:
#
#  Assumes that the data frame is the raw data, such that 1st column in the
#  data frame corresponds to the first feature.  The column names should
#  be set before adding any other columns to the data frame. 

addColumnNames <- function(fname=fname_colnames, dataFrame) {
        labels <- read.table(fname)        
        
        # Column names (features) are in the 2nd column
        colnames(dataFrame) <- labels[,2]
        return(dataFrame)
}

#  buildAveFeatureDataFrame 
#
#  Builds a data frame that summarizes the mean features for each individual 
#  based on activity.  
#  
#  Arguments: 
#
#     dataFrame    data frame in which to summarize the features means 
#
#  Returns:  a new data frame with features means grouped by individual
#            and activity. 
#
#  Details:
#
#  The column name for the features are modified by adding 'm' to the 
#  beginning of the column (feature), indicating mean. 

buildAveFeatureDataFrame <- function(dataFrame) {
        n <- ncol(dataFrame)
        nf <- ncol(dataFrame)-2   # Number of features in dataframe         
        
        # Group data by:  subject and activity 
        grouped_df <- group_by(dataFrame, subject, activity)
        
        # Calculate the mean of each feature column, grouped by subject, activity
        new_df <- summarize_at(grouped_df, c(1:nf), mean, na.rm = TRUE)
        
        # Add m to beginning of every feature name for the mean
        colnames(new_df)[3:n] <- paste0("m", colnames(new_df)[3:n])
        
        
        # Convert back to just a simply data frame and return
        return(as.data.frame(new_df))
}

#  getData 
#
#  Gets the training data and testing data as a data frame, 
#  appending the test data after the train data. 
#  
#  Arguments: 
#
#     fname_train     Training file data
# 
#     fname_test      Test file data  
#
#     nrow            number of rows to read from input files
#
#  Returns:  data frame of combined data

getData <-function(fname_train = fname_train, 
                   fname_test=fname_test, 
                   nrow=-1) {

        train <- readData(fname_train, header=FALSE, nrow=nrow)
        test <- readData(fname_test, header=FALSE, nrow=nrow) 
        
        # Append test data to the end train data (bottom of data frame)
        combinded <- rbind(train, test)
        return(combinded)
}

#  readData 
#
#  Reads a text file of data and returns the result as a data frame. 
#  
#  Arguments: 
#
#     fname     Text file to read
# 
#     header    Boolean whether the file has header row 
#
#     nrow      number of rows to read from input file
#
#  Returns:  the data from the file as a data frame

readData <-function(fname, header=FALSE, nrow=-1) {
        con <- file(fname, open="rt")
        on.exit(close(con))
        df = read.table(con, header=header, nrow=nrow) 
        return(df)
}

#  writeDataFrame 
#
#  Writes a data frame to an output file as text 
#  
#  Arguments: 
#
#     df        Data frame to write to file
#
#     fname     Name of the file to write
# 
#  Details:
#
#  The data is written comma separated.  Column names are written to the 
#  file, but not row names. 

writeDataFrame <- function(df, fname) {
        con <- file(fname, "wt")
        on.exit(close(con))
        write.table(df, con, row.names=FALSE, 
                    col.names=TRUE, sep=",", quote=FALSE)
}

#  buildDataFrame 
#
#  Creates a tidy data (data frame) from the 
#  Human Activity Recognition Using Smartphones Dataset 
#  
#  Arguments: 
#
#     fname_colnames         List of features in which assign the column names, 
#                            e.g., "features.txt"
#
#     fname_activityLabels   Activity labels that map from an acitivity id (1, 2, 3,...)
#                            to a meaningful label (WALKING, WALKING_UPSTAIRS)
#
#     fname_train            Training set of activities, e.g. "X_train.txt"
# 
#     fname_test             Test set of activities, e.g., "X_test.txt"
#
#     fname_trainActivity    Training set of activity ids, e.g., "y_train.txt".
#
#     fname_testActivity     Training set of activity ids, e.g., "y_test.txt".
# 
#     fname_trainSubject     Training set of subject ids, e.g. "subject_train.txt"
#
#     fname_testSubject      Test set of subject ids, e.g. "subject_test.txt"
#
#     strexp                 String filter for features (columns to keep)
#                            Default value is "mean\\(\\)|std\\(\\)"
#
#     rnow                   The number of rows to process from the Smartphones Dataset.
#                            Default is -1, all rows.  
#
#  Returns:  data frame of tidy data from Smartphones Dataset
#
#  Details:
#
#    Merges the training and the test sets to create one data set.
#    Appropriately labels the data set with descriptive variable names for columns.
#    Extracts only the measurements on the mean and standard deviation for each measurement.
#    Adds subject information to the data set. 
#    Adds activity information for each subject to the data set.  

buildDataFrame <- function(fname_colnames,
                           fname_activityLabels,
                           fname_train,
                           fname_test,
                           fname_trainActivity,
                           fname_testActivity,
                           fname_trainSubject,
                           fname_testSubject,
                           strexp = "mean\\(\\)|std\\(\\)", 
                           nrow=-1) {

        # Merges the training and the test sets to create one data set.
        df <- getData(fname_train, fname_test, nrow)
        
        # Appropriately labels the data set with descriptive variable names for columns.
        df <- addColumnNames(fname_colnames, df)
        
        # Extracts only the measurements on the mean and standard deviation for each measurement.
        # Pass is regular expression string that looks for [mean()|std()]
        df <- extractColumns(strexp, df)
        
        # Not that have columns of interest, clean up the column names
        colnames(df) <- tidyColumnNames(colnames(df))
        
        # Add activity data to the Data Frame
        df <- addActivityData(fname_trainActivity,
                              fname_testActivity, 
                              fname_activityLabels, 
                              df, nrow) 
        
        # Add subject data to Data Frame
        df <- addSubjectData(fname_trainSubject, fname_testSubject, df, nrow)  
        
        return(df)
}

# unitTest
#
# Simple unit test of scripts looking at only 20 rows of data. 


unitTest <- function(nrow = 20) {
  
        # Input filenames 
        fname_colnames       <- "./data/UCI HAR Dataset/features.txt"
        fname_activityLabels <- "./data/UCI HAR Dataset/activity_labels.txt"
        fname_train          <- "./data/UCI HAR Dataset/train/X_train.txt"
        fname_test           <- "./data/UCI HAR Dataset/test/X_test.txt"
        fname_trainActivity  <- "./data/UCI HAR Dataset/train/y_train.txt"
        fname_testActivity   <- "./data/UCI HAR Dataset/test/y_test.txt"
        fname_trainSubject   <- "./data/UCI HAR Dataset/train/subject_train.txt"
        fname_testSubject    <- "./data/UCI HAR Dataset/test/subject_test.txt"
   
        # Output filenames
        fname_analysis       <- "./data/UCI HAR Dataset/analysis.txt"
        fname_manalysis      <- "./data/UCI HAR Dataset/mean_analysis.txt"  
  
  
        df <- buildDataFrame(fname_colnames,
                             fname_activityLabels,
                             fname_train,
                             fname_test,
                             fname_trainActivity,
                             fname_testActivity,
                             fname_trainSubject,
                             fname_testSubject,
                             nrow = nrow)
        print(df[,1:5])
        writeDataFrame(df, fname_analysis)
        avedf <- buildAveFeatureDataFrame(df)
        writeDataFrame(avedf, fname_manalysis)
        return(avedf)
}
        
# unitTest2
#
# Unit test of scripts looking at all data. 

unitTest2 <- function() {
        avedf = unitTest(nrow = -1)
        return(avedf)
}