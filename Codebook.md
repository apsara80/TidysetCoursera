##Codebook

###Getting and Cleaning Data - Final Project



**Project Background**

This project is the final assignment of the Coursera course "Getting and Cleaning Data." The purpose of the assignment is to demonstrate one's ability to collect, work with, and clean a data set. 


**Raw Data**

The data used for this project were collected from the experiments that were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each participant performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. For more information on the experiements, visit [here] (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
The complete dataset can be downloaded from [here] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

**Data Load**

The R script downloads the above dataset (a zip file), and unzips the file in the working directory. The eight files containing the necessary information for this project are then loaded to workspace. 

- ***testsubject*** a data frame containing the data from the file 'subject_test.txt' (2947 obs. of 1 variable). Shows subject identification numbers in the test group.

- ***testx*** a data frame containing the data from the file 'X_test.txt' (2947 obs. of 561 variables). Shows all the measurements from the wearable device for the test group.

- ***testy*** a data frame containing the data from the file 'y_test.txt' (2947 obs. of 1 variable). Shows activity labels for the test group.

- ***trainsubject*** a data frame containing the data from the file 'subject_train.txt' (7352 obs. of 1 variable). Shows subject identification numbers in the train group.

- ***trainx*** a data frame containing the data from the file 'X_train.txt' (7352 obs. of 561 variables). Shows all the measurements from the wearable device for the train group.

- ***trainy*** a data frame containing the data from the file 'y_train.txt' (7352 obs. of 1 variable). Shows activity labels for the train group.

- ***labels*** a data frame containing the data from the file 'activity_labels.txt' (6 obs. of 2 variables). Shows the six levels of activities.

- ***measures*** a data frame containing the data from the file 'features.txt' (561 obs. of 2 variables). Shows the names of each measurement.


**Data Transformation** 

1. Merging data

	- ***test*** a data frame combining the three data frames of the test group by column: *testsubject*, *testy*, and *testx* (2947 obs. of 563 variables)

	- ***train*** a data frame combining the three data frames of the train group by column: *trainsubject*, *trainy*, and *trainx* (7352 obs. of 563 variables)

	- ***combined*** a data frame combining the two groups by row: *test* and *train*


2. Extracting variables 

	The following codes assign variable names for the first column ("subject") and the second column ("activity") in the *combined* data frame.

	`colnames(combined)[1] <- "subject"`
	`colnames(combined)[2] <- "activity"`

	In the *measures* data frame, the measurement names are listed vertically in a column, so the following code tanspose that data frame, aligning the measurement names horizontally (in a row). The measurement names are then saved as a character vector named *measure_names*.

	`measure_names <- t(measures)[2, ]`

	The following codes identify only the measurement names containing "mean()" and "std()" in the *measure_names* vector, and save the indices as numeric vectors named *means* and *stds*. 

	`means <- which (grepl("\\<mean()\\>", measure_names))`
`stds <- which(grepl("\\<std()\\>", measure_names))`

	Since the measurements are binded after the first two columns ('subject' and 'activity') in the *combined* data frame, adding two to the column indices in *means* and *stds* provides the correct columns for all variables containing 'mean()' and 'std()' in the *combined* data frame. The new column indices are saved as numeric vectors called *means_col* and *stds_col*.

	`means_col <- means + 2` 
	`stds_col <- stds + 2`

	Subsetting only the variables needed from the *combined* data frame, the *extract* data frame is created with the following code.

	`extract <- combined [, c(1,2,means_col, stds_col)]`

3. Renaming variables 

	Activity names are updated from numeric values to character strings (more descriptive) based on the *labels* table.

	`extract$activity <- labels$V2 [match (extract$activity, labels$V1)]`

	Measurement names for the means and standard deviations used for this project are saved as character vectors *means_desc* and *stds_desc*.

	`means_desc <- measure_names[means]`
	`stds_desc <- measure_names[stds]`

	Variable names are updated in the *extract* data frame using those measurement names.

	`colnames(extract) <- c("subject", "activity", means_desc, stds_desc)`

	The following codes update the measurement names to be more descriptive.

	`names(extract) <- gsub("[()]", "", names(extract))`
	`names(extract) <- gsub("^t", "Time", names(extract))`
	`names(extract) <- gsub("^f", "FreqDomainSignal", names(extract))`
	`names(extract) <- gsub("Acc", "Accelerometer", names(extract))`
	`names(extract) <- gsub("Gyro", "Gyroscope", names(extract))`
	`names(extract) <- gsub("Mag", "Magnitude", names(extract))`

All variable names in the final data set *extract* are as follows: 

* subject
* activity
* TimeBodyAccelerometer-mean-X
* TimeBodyAccelerometer-mean-Y
* TimeBodyAccelerometer-mean-Z
* TimeGravityAccelerometer-mean-X
* TimeGravityAccelerometer-mean-Y
* TimeGravityAccelerometer-mean-Z
* TimeBodyAccelerometerJerk-mean-X
* TimeBodyAccelerometerJerk-mean-Y
* TimeBodyAccelerometerJerk-mean-Z
* TimeBodyGyroscope-mean-X
* TimeBodyGyroscope-mean-Y
* TimeBodyGyroscope-mean-Z
* TimeBodyGyroscopeJerk-mean-X
* TimeBodyGyroscopeJerk-mean-Y
* TimeBodyGyroscopeJerk-mean-Z
* TimeBodyAccelerometerMagnitude-mean
* TimeGravityAccelerometerMagnitude-mean
* TimeBodyAccelerometerJerkMagnitude-mean
* TimeBodyGyroscopeMagnitude-mean
* TimeBodyGyroscopeJerkMagnitude-mean
* FreqDomainSignalBodyAccelerometer-mean-X
* FreqDomainSignalBodyAccelerometer-mean-Y
* FreqDomainSignalBodyAccelerometer-mean-Z
* FreqDomainSignalBodyAccelerometerJerk-mean-X
* FreqDomainSignalBodyAccelerometerJerk-mean-Y
* FreqDomainSignalBodyAccelerometerJerk-mean-Z
* FreqDomainSignalBodyGyroscope-mean-X
* FreqDomainSignalBodyGyroscope-mean-Y
* FreqDomainSignalBodyGyroscope-mean-Z
* FreqDomainSignalBodyAccelerometerMagnitude-mean
* FreqDomainSignalBodyBodyAccelerometerJerkMagnitude-mean
* FreqDomainSignalBodyBodyGyroscopeMagnitude-mean
* FreqDomainSignalBodyBodyGyroscopeJerkMagnitude-mean
* TimeBodyAccelerometer-std-X
* TimeBodyAccelerometer-std-Y
* TimeBodyAccelerometer-std-Z
* TimeGravityAccelerometer-std-X
* TimeGravityAccelerometer-std-Y
* TimeGravityAccelerometer-std-Z
* TimeBodyAccelerometerJerk-std-X
* TimeBodyAccelerometerJerk-std-Y
* TimeBodyAccelerometerJerk-std-Z
* TimeBodyGyroscope-std-X
* TimeBodyGyroscope-std-Y
* TimeBodyGyroscope-std-Z
* TimeBodyGyroscopeJerk-std-X
* TimeBodyGyroscopeJerk-std-Y
* TimeBodyGyroscopeJerk-std-Z
* TimeBodyAccelerometerMagnitude-std
* TimeGravityAccelerometerMagnitude-std
* TimeBodyAccelerometerJerkMagnitude-std
* TimeBodyGyroscopeMagnitude-std
* TimeBodyGyroscopeJerkMagnitude-std
* FreqDomainSignalBodyAccelerometer-std-X
* FreqDomainSignalBodyAccelerometer-std-Y
* FreqDomainSignalBodyAccelerometer-std-Z
* FreqDomainSignalBodyAccelerometerJerk-std-X
* FreqDomainSignalBodyAccelerometerJerk-std-Y
* FreqDomainSignalBodyAccelerometerJerk-std-Z
* FreqDomainSignalBodyGyroscope-std-X
* FreqDomainSignalBodyGyroscope-std-Y
* FreqDomainSignalBodyGyroscope-std-Z
* FreqDomainSignalBodyAccelerometerMagnitude-std
* FreqDomainSignalBodyBodyAccelerometerJerkMagnitude-std
* FreqDomainSignalBodyBodyGyroscopeMagnitude-std
* FreqDomainSignalBodyBodyGyroscopeJerkMagnitude-std

**Tidy data set**

Using the 'dplyr' package, the *extract* data frame is grouped by subject and by activity, creating a new data frame with averages of each measurement per group. The tidy data set is saved as a text file ("tidyset.txt") in the working directory.  

	library(dplyr)
	tbl_df(extract)
	tidyset <- 
        extract %>%
        group_by (subject, activity) %>% 
        summarise_all (funs(mean))
	write.table (tidyset, "tidyset.txt", row.name=FALSE)