##Download and unzip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR dataset.zip", method = "curl")
unzip("UCI HAR dataset.zip", exdir = "UCI HAR Dataset")

##Load and summarise the training and test sets
subject_train <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/train/subject_train.txt")
str(subject_train) #dataframe with integer variable
X_train <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/train/X_train.txt")
str(X_train) #dataframe with numeric variables
Y_train <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/train/Y_train.txt")
str(Y_train) #dataframe with integer variable

subject_test <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/test/subject_test.txt")
str(subject_test) #dataframe with integer variable
X_test <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/test/X_test.txt")
str(X_test) #dataframe with numeric variable
Y_test <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/test/Y_test.txt")
str(Y_test) #dataframe with integer variable

##Merge the training and test sets
training_sets <- cbind(subject_train, Y_train, X_train)
test_sets <- cbind(subject_test, Y_test, X_test)
merged_set <- rbind(test_sets, training_sets)

##Extract columns containing mean() and std()
mean_std <- merged_set[ , c(1:8, 43:48, 83:88, 123:128, 163:168, 203, 204, 216, 217, 
                         229, 230, 242, 243, 255, 256, 268:273, 347:352, 426:431, 
                         505, 506, 518, 519, 531, 532, 544, 545)]

##Name the values in the activities column (2nd column)
activity <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", 
              "STANDING", "LAYING") 
mean_std$V1.1 <- activity[mean_std$V1.1]

##Load the features file containing variable names
features <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/features.txt")
##Extract variable names containing mean() and std()
features <- features$V2[grep("\\bmean()\\b|std()", features$V2)]
##Add more description to variable names
desc <- gsub("-", ".",
        gsub("^t", "Time",
        gsub("^f", "Freq", 
        gsub("Acc", "Accelerometer",
        gsub("Gyro", "Gyroscope",
        gsub("Mag", "Magnitude", features))))))
##Label all columns with descriptive variable names
desc <- c("Subject", "Activity", desc)
colnames(mean_std) <- desc

##Group data by subject and activity, then summarise the mean of each variable
library(dplyr)
tidy_data <- mean_std %>% group_by(Subject, Activity) %>% summarise_all(mean)
##Print result as a txt file (tidy dataset)
write.table(tidy_data, file = "tidy_dataset.txt", row.name=FALSE)