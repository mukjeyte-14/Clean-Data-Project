library(plyr)
library(dplyr)

# Step 1
# Merge the training and test sets to create one data set
###############################################################################

x_train <- read.table("train/X_train.txt")
dim(x_train) # 7352 561
head(x_train)
y_train <- read.table("train/y_train.txt")
table(y_train)
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
dim(x_test) # 2947*561
y_test <- read.table("test/y_test.txt")
table(y_test)
subject_test <- read.table("test/subject_test.txt")

# create 'x' data set
x_data <- rbind(x_train, x_test)
dim(x_data) # 10299*561
# create 'y' data set
y_data <- rbind(y_train, y_test)
dim(y_data) # 10299*1

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)
dim(subject_data) # 10299*1

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

features <- read.table("features.txt")
dim(features)  # 561*2

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
length(mean_and_std_features ) # 66

# subset the desired columns
x_data <- x_data[, mean_and_std_features]
dim(x_data) # 10299*66

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]

# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table("activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)