## To run this script, both the "run_analysis.R" file and the provided "UCI HAR Dataset" folder
## should be placed in the current working directory in R.

# Read all requred files--------------------------------------------------------
features <- read.table("UCI HAR Dataset/features.txt")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merge the training and the test sets to create one data set-------------------
temp_data <- rbind(x_train, x_test)
features_vector <- features[,2]
colnames(temp_data) <- features_vector

# Extracts the measurements on the mean and std for each measurement------------
subset_mean_std <- temp_data[,grep("mean()|std()", features_vector)]

# adds subjects and activities to the dataset------------------------------------
subjects <- rbind(subject_train, subject_test)
activities <- rbind(y_train, y_test)
temp_data2 <- cbind(subjects, activities)
colnames(temp_data2) <- c("subject", "activity")

subset_mean_std <- cbind(temp_data2, subset_mean_std)

# Uses descriptive activity names to name the activities in the data set--------
labels_activ <- c('walking', 'walkingUpstairs', 'walkingDownstairs',
                  'sitting', 'standing', 'laying')
subset_mean_std$activity <- factor(subset_mean_std$activity, labels=labels_activ)

# removes temporary datasets from environment:
remove('x_train', 'x_test', 'temp_data', 'y_train', 'y_test', 'subject_train',
       'subject_test', 'temp_data2', 'activities', 'subjects')

# Labels the data set with descriptive variable names---------------------------
original_names <- grep("mean()|std()", features_vector, value=TRUE)
new_names <- gsub("-|\\()", "", original_names) # remove illegal characters
new_names <- gsub("BodyBody", "Body", new_names) # remove mistakes
new_names <- c("subject", "activity", new_names)
new_names <- make.names(new_names, unique=TRUE) # ensure syntactically valid names
colnames(subset_mean_std) <- new_names

# Creates an independent tidy data set with the average of each variable--------
# for each activity and each subject
library(dplyr)
group_data <- group_by(subset_mean_std, subject, activity)
tidy_data <- summarise_each(group_data, funs(mean(., na.rm = TRUE)))

# Writes the created tidy data set into a txt file------------------------------
write.table(tidy_data, file = "MyTidyData.txt", row.name=FALSE)
