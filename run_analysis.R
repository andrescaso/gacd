## 0.- Set Up directory
setwd("C:/Andres/Teoria/Cursos/Getting and Cleaning Data/gacd")

## 1.- Read the data
subject_test <- read_csv("UCI HAR Dataset/test/subject_test.txt", col_names = FALSE)
X_test <- read_table2("UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
y_test <- read_csv("UCI HAR Dataset/test/y_test.txt", col_names = FALSE)
subject_train <- read_csv("UCI HAR Dataset/train/subject_train.txt", col_names = FALSE)
y_train <- read_csv("UCI HAR Dataset/train/y_train.txt", col_names = FALSE)
X_train <- read_table2("UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
features <- read_table2("UCI HAR Dataset/features.txt", col_names = FALSE)
activity_labels <- read_table2("UCI HAR Dataset/activity_labels.txt", col_names = FALSE)

## 2.- Create a subset only with the measurements on the mean 
## and standard deviation for each measurement and assign tne variables names.
n1 <- grep("mean",features$X2)
n2 <- grep("std",features$X2)
n3 <- c(n1,n2)
n4 <- grep("mean",features$X2, value = T)
n5 <- grep("std",features$X2, value = T)
n6 <- c(n4,n5)
library(data.table)
setnames(X_test, names(X_test[n3]), n6)
setnames(X_train, names(X_train[n3]), n6)
X_test <- X_test %>% select(all_of(n6))
X_train <- X_train %>% select(all_of(n6))
setnames(y_test, "X1", "activity_labels")
setnames(y_train, "X1", "activity_labels")
X_test <- cbind(y_test, X_test)
X_train <- cbind(y_train, X_train)
setnames(subject_test, "X1", "subject")
setnames(subject_train, "X1", "subject")
X_test <- cbind(subject_test, X_test)
X_train <- cbind(subject_train, X_train)
X <- rbind(X_test,X_train)  ## To merge the train and test data frame
X$activity_labels[X$activity_labels == 1] <- "WALKING"
X$activity_labels[X$activity_labels == 2] <- "WALKING_UPSTAIRS"
X$activity_labels[X$activity_labels == 3] <- "WALKING_DOWNSTAIRS"
X$activity_labels[X$activity_labels == 4] <- "SITTING"
X$activity_labels[X$activity_labels == 5] <- "STANDING"
X$activity_labels[X$activity_labels == 6] <- "LAYING"

## 3.- creates a tidy data set with the average of each variable 
## for each activity and each subject.

avgtable <- X %>% group_by(subject, activity_labels) %>% summarise_each(funs(mean))