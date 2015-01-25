
library("dplyr")
# Download and extract the files
# Store the path in a variable

# Read test data file
test_data <- read.table("UCI HAR Dataset/test/X_test.txt", stringsAsFactors=FALSE)
# Read the activity data for test
test_activities <- read.table("UCI HAR Dataset/test/y_test.txt", stringsAsFactors=FALSE)
# Read the subjects data for test
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt", stringsAsFactors=FALSE)

# Read training data file
train_data <- read.table("UCI HAR Dataset/train/X_train.txt", stringsAsFactors=FALSE)
# Read the activity data for training
train_activities <- read.table("UCI HAR Dataset/train/y_train.txt", stringsAsFactors=FALSE)
# Read the subjects data for training
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt", stringsAsFactors=FALSE)


# Read features file to create column headers
features<-read.table("UCI HAR Dataset/features.txt")

# Read the activity names
act_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Create a vector with the activity names to be attached to the test data set
test_act_labels <- act_labels[test_activities[,1],2]

# Create a vector with the activity names to be attached to the training data set
train_act_labels <- act_labels[train_activities[,1],2]

# Get a list of column names and IDs which represent 
# a mean or standard deviation for a measurement
col_ids <- features[grepl("mean|std", features$V2), 1:2]

# Extract the relevant columns from each data set
sub_test <- select(test_data, col_ids[1])
sub_train <- select(train_data, col_ids[1])

# Rename the columns in each data set
names(sub_test)<-col_ids$V2
names(sub_train)<-col_ids$V2

# Add a new column  to indicate the source data set
# Unnecessary and causes problems while grouping
#sub_test <- mutate(sub_test, src_data_set="test")
#sub_train <- mutate(sub_train, src_data_set="train")

# Add the activity labels to each data set
sub_train <- cbind(train_act_labels, sub_train)
sub_test <- cbind(test_act_labels, sub_test)
# Renaming the new columns to be identical in the two data frames to avoid problems 
# while merging (rbinding) them
names(sub_test)[1] <- "activity_label"
names(sub_train)[1] <- "activity_label"

# Add the subject columns to each data set
sub_test <- cbind(test_subjects, sub_test)
sub_train <- cbind(train_subjects, sub_train)
# Renaming the new columns to be identical in the two data frames to avoid problems 
# while merging (rbinding) them
names(sub_test)[1] <- "subject"
names(sub_train)[1] <- "subject"


# Merge the data sets
#full_set<-merge(sub_test, sub_train, all=TRUE)
full_set<-rbind(sub_train, sub_test)

# Make the feature names more readable
names(full_set) <- gsub("\\(|\\)", "", names(full_set))
names(full_set)  <- gsub("-", "_", names(full_set))
names(full_set)  <- gsub(",", "_", names(full_set))


# 5. From the data set in step 4, creates a second, 
#    independent tidy data set with the average of each variable for each 
#    activity and each subject.

# Creating the new dataframe to calculate averages
#grouped_dataset <- group_by(full_set, "activity_label", "subjects")
new_dataset<-tbl_df(full_set)
gpd_dt<-group_by(new_dataset, subject, activity_label)
# Calculate means for each vriable except grouping variables (activity names and subjects)
grouped_means <- gpd_dt %>% summarise_each(funs(mean))

# Write results into a file
write.table(grouped_means, file = "group_avgs.txt", row.name=FALSE)












# y_test.txt : activity labels (match the number with activity_labels.txt)
# ANY MISSING VALUES IN X_test.txt?

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# select(from both test files, labeled using the features.txt, where the column name !contains! either mean or std)

# 3. Uses descriptive activity names to name the activities in the data set
# use mutate to rename the columns

# 4. Appropriately labels the data set with descriptive variable names. 
# use mutate to rename the columns

# 5. From the data set in step 4, creates a second, 
#    independent tidy data set with the average of each variable for each activity and each subject.
