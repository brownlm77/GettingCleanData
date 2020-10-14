run_analysis.R
===============
The R file, run_analysis.R, provides a script for processing (anlayzing) 
data from: 
 
    Human Activity Recognition Using Smartphones Dataset
    Version 1.0

Source data for the scripts:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description of the original data is available at the site where the data was 
obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


These scripts can perform the following actions: 

1. Merges the training and the test sets to create one data set.
2. Labels the data set with descriptive variable names for columns. 
3. Extracts only the measurements on the mean and standard deviation for each measurement.
4. Adds subject information to the data set. 
5. Adds activity information for each subject to the data set.  

Files
==================

The dataset using the following input files:

- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'train/subject_train.txt', test/subject_test.txt: Each row identifies the subject who 
performed the activity for each window sample and ranges from 1 to 30.  

And produces two output files:

- 'analysis.txt':  Combined train and test data for features analyzed. 
- 'mean_analysis.txt'  Mean of features summarized by activity and subject. 

Notes
===========================

The output files are comma-separated text, containing a single header row with the 
column labels. In both output files, the subject id is the first column and the 
second column is Smartphone activity. 

To produce the output file, analysis.txt:

1. The test set, X_test.txt was appended to end of (after) the train set, X_train.txt
2. The the column labels were assigned to the data from features.txt
3. To support tidy data, the features names were changed from the original my removing all punctuation and changing to lowers case
4. The columns were dropped that didn't have a match for mean() or std() in the column name
5. The activities from y_test.txt was appended to end of (after) the subjects in y_train.txt
6. The activities numbers were converted to labels using activity_labels.txt and added as the first column of the data set
7. The subjects in file y_test.txt was appended to the subjects in y_train.txt and added as the first column of the data set

To produce the output file, mean_analysis.txt:

1. The data set for analysis.txt was grouped by subject and activity, and the means of the feature calculated
2. The letter 'm' was added to the beginning of each feature name to indicate mean 


Following is the modification of the original feature labels to tidy feature labels


| Original       | Modified     | 
| :------------- | :----------: | 
| tBodyAcc-mean()-X            | tbodyaccmeanx |
| tBodyAcc-mean()-Y            | tbodyaccmeany |
| tBodyAcc-mean()-Z            |  tbodyaccmeanz | 
| tBodyAcc-std()-X             |  tbodyaccstdx |
| tBodyAcc-std()-Y             |  tbodyaccstdy |
| tBodyAcc-std()-Z             |  tbodyaccstdz |
| tGravityAcc-mean()-X         |  tgravityaccmeanx |
| tGravityAcc-mean()-Y         |  tgravityaccmeany |
| tGravityAcc-mean()-Z         |  tgravityaccmeanz |
| tGravityAcc-std()-X          |  tgravityaccstdx |
| tGravityAcc-std()-Y          |  tgravityaccstdy |
| tGravityAcc-std()-Z          |  tgravityaccstdz |
| tBodyAccJerk-mean()-X        |  tbodyaccjerkmeanx | 
| tBodyAccJerk-mean()-Y        |  tbodyaccjerkmeany | 
| tBodyAccJerk-mean()-Z        |  tbodyaccjerkmeanz | 
| tBodyAccJerk-std()-X         |  tbodyaccjerkstdx | 
| tBodyAccJerk-std()-Y         |  tbodyaccjerkstdy | 
| tBodyAccJerk-std()-Z         |  tbodyaccjerkstdz | 
| tBodyGyro-mean()-X           |  tbodygyromeanx | 
| tBodyGyro-mean()-Y           |  tbodygyromeany | 
| tBodyGyro-mean()-Z           |  tbodygyromeanz | 
| tBodyGyro-std()-X            |  tbodygyrostdx | 
| tBodyGyro-std()-Y            |  tbodygyrostdy | 
| tBodyGyro-std()-Z            |  tbodygyrostdz | 
| tBodyGyroJerk-mean()-X       |  tbodygyrojerkmeanx | 
| tBodyGyroJerk-mean()-Y       |  tbodygyrojerkmeany | 
| tBodyGyroJerk-mean()-Z       |  tbodygyrojerkmeanz | 
| tBodyGyroJerk-std()-X        |  tbodygyrojerkstdx | 
| tBodyGyroJerk-std()-Y        |  tbodygyrojerkstdy  | 
| tBodyGyroJerk-std()-Z        |  tbodygyrojerkstdz | 
| tBodyAccMag-mean()           |  tbodyaccmagmean | 
| tBodyAccMag-std()            |  tbodyaccmagstd | 
| tGravityAccMag-mean()        |  tgravityaccmagmean | 
| tGravityAccMag-std()         |  tgravityaccmagstd | 
| tBodyAccJerkMag-mean()       |  tbodyaccjerkmagmean | 
| tBodyAccJerkMag-std()        |  tbodyaccjerkmagstd | 
| tBodyGyroMag-mean()          |  tbodygyromagmean | 
| tBodyGyroMag-std()           |  tbodygyromagstd | 
| tBodyGyroJerkMag-mean()      |  tbodygyrojerkmagmean | 
| tBodyGyroJerkMag-std()       |  tbodygyrojerkmagstd | 
| fBodyAcc-mean()-X            |  fbodyaccmeanx | 
| fBodyAcc-mean()-Y            |  fbodyaccmeany | 
| fBodyAcc-mean()-Z            |  fbodyaccmeanz | 
| fBodyAcc-std()-X             |  fbodyaccstdx | 
| fBodyAcc-std()-Y             |  fbodyaccstdy | 
| fBodyAcc-std()-Z             |  fbodyaccstdz | 
| fBodyAccJerk-mean()-X        |  fbodyaccjerkmeanx | 
| fBodyAccJerk-mean()-Y        |  fbodyaccjerkmeany | 
| fBodyAccJerk-mean()-Z        |  fbodyaccjerkmeanz | 
| fBodyAccJerk-std()-X         |  fbodyaccjerkstdx | 
| fBodyAccJerk-std()-Y         |  fbodyaccjerkstdy | 
| fBodyAccJerk-std()-Z         |  fbodyaccjerkstdz | 
| fBodyGyro-mean()-X           |  fbodygyromeanx | 
| fBodyGyro-mean()-Y           |  fbodygyromeany | 
| fBodyGyro-mean()-Z           |  fbodygyromeanz | 
| fBodyGyro-std()-X            |  fbodygyrostdx | 
| fBodyGyro-std()-Y            |  fbodygyrostdy | 
| fBodyGyro-std()-Z            |  fbodygyrostdz | 
| fBodyAccMag-mean()           |  fbodyaccmagmean | 
| fBodyAccMag-std()            |  fbodyaccmagstd | 
| fBodyBodyAccJerkMag-mean()   |  fbodybodyaccjerkmagmean | 
| fBodyBodyAccJerkMag-std()    |  fbodybodyaccjerkmagstd | 
| fBodyBodyGyroMag-mean()      |  fbodybodygyromagmean | 
| fBodyBodyGyroMag-std()       |  fbodybodygyromagstd | 
| fBodyBodyGyroJerkMag-mean()  |  fbodybodygyrojerkmagmean | 
| fBodyBodyGyroJerkMag-std()   |  fbodybodygyrojerkmagstd | 
