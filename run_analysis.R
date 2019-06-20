# download files
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file (url, destfile = "data.zip", method="curl")
temp <- "./data.zip"
unzip(temp, overwrite="TRUE")

# read in datasets
testsubject <- read.table(file="./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
testx <- read.table(file="./UCI HAR Dataset/test/X_test.txt", header=FALSE)
testy <- read.table(file="./UCI HAR Dataset/test/y_test.txt", header=FALSE)
trainsubject <- read.table(file="./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
trainx <- read.table(file="./UCI HAR Dataset/train/X_train.txt", header=FALSE)
trainy <- read.table(file="./UCI HAR Dataset/train/y_train.txt", header=FALSE)

# read in labels and measures
labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)
measures <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
measure_names <- t(measures)[2, ] #transpose measures and get variable names

# combine test and train datasets
test <- cbind (testsubject, testy, testx)
train <- cbind (trainsubject, trainy, trainx)
colnames(test)[1] <- "subject" # change column names to indicate subject and activity
colnames(test)[2] <- "activity"
colnames(train)[1] <- "subject"
colnames(train)[2] <- "activity"
combined <- rbind(test, train)

# extarct means and stds 
means <- which (grepl("\\<mean()\\>", measure_names))
stds <- which(grepl("\\<std()\\>", measure_names))
means_col <- means + 2 # add two to get column indices in the combined dataframe
stds_col <- stds + 2
extract <- combined[ , c(1,2,means_col, stds_col)]

# update variable names/values
extract$activity <- labels$V2 [match (extract$activity, labels$V1)]
means_desc <- measure_names[means]
stds_desc <- measure_names[stds]
colnames(extract) <- c("subject", "activity", means_desc, stds_desc)

# change variable names to be more descriptive
names(extract) <- gsub("[()]", "", names(extract))
names(extract) <- gsub("^t", "Time", names(extract))
names(extract) <- gsub("^f", "FreqDomainSignal", names(extract))
names(extract) <- gsub("Acc", "Accelerometer", names(extract))
names(extract) <- gsub("Gyro", "Gyroscope", names(extract))
names(extract) <- gsub("Mag", "Magnitude", names(extract))

# get averages of each measure by subject and by activity
library(dplyr)
tbl_df(extract)
tidyset <- 
        extract %>%
        group_by (subject, activity) %>% 
        summarise_all (funs(mean)) 
write.table (tidyset, "tidyset.txt", row.name=FALSE)
