# Loading libraries
library(dplyr)

# Load Test datasets
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Load Train datasets
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Read data description
variable_names <- read.table("./UCI HAR Dataset/features.txt")

# Read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 1) Merging of the two datas
X_combine <- rbind(x_test, x_train)
y_combine <- rbind(y_test, y_train)
sub_combine <- rbind(subject_test, subject_train)

# 2) Extract mean and sd for each measurement
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_combine <- X_combine[,selected_var[,1]]

# 3) Use descriptive activity names to name the
# activities in the data set
colnames(y_combine) <- "activity"
y_combine$activitylabel <- factor(y_combine$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_combine[,-1]

# 4) Label the dataset with descriptive variable name
colnames(X_combine) <- variable_names[selected_var[,1],2]


# 5) From the data set in step 4, create a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(sub_combine) <- "subject"
total <- cbind(X_combine, activitylabel, sub_combine)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

