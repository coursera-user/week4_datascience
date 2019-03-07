library(dplyr)

## Read feature names from text file and define relevant feature
feature_names <- read.csv("./UCI HAR Dataset/new_features.txt", sep = "", stringsAsFactors = FALSE, header = FALSE) # read feature names from txt file
feature_names <- gsub("-", "_", feature_names[, c("V2")]) # replace dash with underscore
feature_names <- gsub("tBodyAcc", "time_body_accelaration", feature_names) # replace dash with underscore
feature_names <- gsub("fBodyAcc", "fft_body_accelaration", feature_names) # replace dash with underscore
feature_names <- gsub("tGravityAcc", "time_gravity_accelaration", feature_names) # replace dash with underscore
feature_names <- gsub("fGravityAcc", "fft_gravity_accelaration", feature_names) # replace dash with underscore

ids <- c(grep("mean\\(\\)", feature_names), grep("std()", feature_names) ) #get all relevant feature ids
feature_names <- gsub("[\\)\\(]", "", feature_names) # remove brackets
relevant_features <- feature_names[ids]


## Read activity names from text file
activity_names <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep = "", stringsAsFactors = FALSE, header = FALSE) # read activity names from txt file
names(activity_names) <- c("label", "activity")


## Define training and testing vectors
train_subjects <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep ="", header = FALSE, stringsAsFactors = FALSE, col.names = c("subject_id"))
train_x <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep ="", header = FALSE, stringsAsFactors = FALSE, col.names = feature_names)
train_y <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep ="", header = FALSE, stringsAsFactors = FALSE, col.names = c("label"))

test_subjects <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep ="", header = FALSE, stringsAsFactors = FALSE, col.names = c("subject_id"))
test_x <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep ="", header = FALSE, stringsAsFactors = FALSE, col.names = feature_names)
test_y <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep ="", header = FALSE, stringsAsFactors = FALSE, col.names = c("label"))

## Define training and test dataframes
train_df <- cbind(train_subjects, train_x[, relevant_features], train_y)
test_df <- cbind(test_subjects, test_x[,  relevant_features], test_y)

## Adjust activity names
train_df <- merge(train_df, activity_names, by = "label", all.x = TRUE)
test_df <- merge(test_df, activity_names, by = "label", all.x = TRUE)

# Merge training and testing dataframe
df <- rbind(train_df, test_df)

# Get tidydf
mean_cols <- grep("mean", relevant_features, value = T)
tidy_df <- df[, c("subject_id", mean_cols, "activity")] %>% group_by(subject_id, activity) %>% summarize_all(list(mean))

# write table
write.table(tidy_df, file = "output.txt", row.name=FALSE)

