README
================
Hui Xin
2024-02-09

# Project summary

The UC Irvine Human Activity Recognition dataset (UCI HAR dataset) is
built from the recordings of 30 subjects (aged 19-48 years) performing
activities of daily living while carrying a waist-mounted smartphone.
The smartphone contains an embedded accelerometer and gyroscope which is
used to capture 3-axial linear acceleration and 3-axial angular velocity
at a constant rate of 50Hz.

These signals were then pre-processed in the following order:

1.  Filtered using a median filter and a 3rd order low pass Butterworth
    filter with a corner frequency of 20 Hz to remove noise
2.  Sampled in fixed-width sliding windows of 2.56 sec and 50% overlap
    (128 readings/window)
3.  Further separated the acceleration signal into body and gravity
    acceleration signals using a Butterworth low-pass filter with a
    corner frequency of 0.3 Hz.
4.  Obtained a vector of features from each window by calculating
    variables from the time and frequency domain

The obtained dataset is then randomly partitioned into two sets: (1) 70%
of the volunteers was selected to generate the training data and (2) 30%
for the test data.

The purpose of this project is to clean this dataset and prepare tidy
data that can be used for later analysis.

# Repository contents

The
[huixinlau/UCIHARdataset](https://github.com/huixinlau/UCIHARdataset)
repository includes two files that can be used to generate tidy data
from the UCI HAR dataset:

- README.Rmd: Documentation explaining the project and how to use files
  contained in the repository
- run.analysis_R: R script to generate tidy data by extracting the mean
  and standard deviation values of each variable in the UCI HAR dataset
  and then summarizing them by subject and activity
- codebook.Rmd: Codebook that describes the variables in the tidied
  dataset

# Process

The UCI HAR dataset was downloaded from online and extracted into its
own file in the directory.

``` r
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR dataset.zip", method = "curl")
unzip("UCI HAR dataset.zip", exdir = "UCI HAR Dataset")
```

The UCI HAR dataset had 2 files (test & train), both of which included
the recordings, the subject identifier and activity performed. These
files are loaded into R and their structures are summarized.

``` r
#train_set
subject_train <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/train/subject_train.txt")
str(subject_train) 
X_train <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/train/X_train.txt")
str(X_train) 
Y_train <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/train/Y_train.txt")
str(Y_train)
```

``` r
#test_set
subject_test <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/test/subject_test.txt")
str(subject_test) 
X_test <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/test/X_test.txt")
str(X_test) 
Y_test <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/test/Y_test.txt")
str(Y_test)
```

Both files are combined to form a merged dataset (merged_set).

``` r
training_sets <- cbind(subject_train, Y_train, X_train)
test_sets <- cbind(subject_test, Y_test, X_test)
merged_set <- rbind(test_sets, training_sets)
```

The merged dataset contained 10,299 observations of 563 variables.
Variables that contained mean() or std() are extracted into a new
dataset (mean_std).

``` r
mean_std <- merged_set[ , c(1:8, 43:48, 83:88, 123:128, 163:168, 203, 204, 216, 217, 
                         229, 230, 242, 243, 255, 256, 268:273, 347:352, 426:431, 
                         505, 506, 518, 519, 531, 532, 544, 545)]
```

The activities which were coded by number in the dataset are replaced
with descriptive activity names.

``` r
activity <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", 
              "STANDING", "LAYING") 
mean_std$V1.1 <- activity[mean_std$V1.1]
```

The variable names of the UCI HARS dataset were stored in a separate
file from the test and train files. That file is loaded into R and
variable names containing mean() or std() were extracted into an R
object (features)

``` r
features <- read.table("C:/Users/Ailee/Downloads/datasciencecoursera/UCI HAR Dataset/features.txt")
features <- features$V2[grep("\\bmean()\\b|std()", features$V2)]
```

The variable names of features were renamed to provide more description
and clarity, and then added to the dataset.

``` r
desc <- gsub("-", ".",
        gsub("^t", "Time",
        gsub("^f", "Freq", 
        gsub("Acc", "Accelerometer",
        gsub("Gyro", "Gyroscope",
        gsub("Mag", "Magnitude", features))))))
desc <- c("Subject", "Activity", desc)
colnames(mean_std) <- desc
```

Using the dplyr package, the dataset is grouped by subject and activity.
Within each group, the dataset is further summarized to give us the mean
of each variable. This is stored into a new dataset (tidy_data) and
printed out as a txt file.

``` r
library(dplyr)
tidy_data <- mean_std %>% group_by(Subject, Activity) %>% summarise_all(mean)
write.table(tidy_data, file = "tidy_dataset.txt", row.name=FALSE)
```
