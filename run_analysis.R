# 1) Merges the training and the test sets to create one data set.

subject_test <- read.table('D:/370140/R Programming/Workspace 1_3rd July 2014/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt')

subject_train <- read.table('D:/370140/R Programming/Workspace 1_3rd July 2014/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt')

subject_merged <- rbind(subject_train, subject_test)

names(subject_merged) <- "subject"

subject_merged

X_test <- read.table('./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt')

X_train <- read.table('./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt')

X_merged  <- rbind(X_train, X_test)

y_test <- read.table('./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt')

y_train <- read.table('./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt')

y_merged  <- rbind(y_train, y_test)

# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table('./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt', header=FALSE, col.names=c('id', 'name'))

feature_selected_columns <- grep('mean\\(\\)|std\\(\\)', features$name)

filtered_dataset <- X_merged[, feature_selected_columns]

names(filtered_dataset) <- features[features$id %in% feature_selected_columns, 2]

filtered_dataset

# 3) Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table('./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt', header=FALSE, col.names=c('id', 'name'))

# 4) Appropriately labels the data set with descriptive activity names. 

y_merged[, 1] = activity_labels[y_merged[, 1], 2]

names(y_merged) <- "activity"

# 5.1) Creates an intermediate dataset with all required measurements.

whole_dataset <- cbind(subject_merged, y_merged, filtered_dataset)

write.csv(whole_dataset, "./whole_dataset_with_descriptive_activity_names.csv")


# 5.2) Creates the final, independent tidy data set with the average of each variable for each activity and each subject.

measurements <- whole_dataset[, 3:dim(whole_dataset)[2]]

tidy_dataset <- aggregate(measurements, list(whole_dataset$subject, whole_dataset$activity), mean)
names(tidy_dataset)[1:2] <- c('subject', 'activity')
write.csv(tidy_dataset, "./final_tidy_dataset.csv")
write.table(tidy_dataset, "./final_tidy_dataset.txt")
