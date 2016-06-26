################# run_analysis.R ####################
# R script to solve Week 4 assignment from Coursera Getting & Cleaning Data Course 
# Results_tbl contains the measurements on the mean and standard deviation for each measurement
# Summary_tbl contains the additional dataset with average of each variable for each activity and each subject.
# Step 1: load various data
# Step 2: subset the measurement data
# Step 3: combine data into single table Results_tbl
# Step 4: create summary table Summary_tbl

library(dplyr)
library(tidyr)
rm(list = ls()) # clear workspace


#### Step 1: Read in table of variables ("features") and create vector with descriptive names
feature_names<-read.table("./UCI HAR Dataset/features.txt",header = FALSE, sep = "", colClasses=c("numeric","character"))[,2]

# determine which variables contain mean or standard deviation data (this 
# will be used below to subset appropriate columns from all measurements)
meanstd_colid<-grep("mean\\(\\)|std\\(\\)",feature_names)

# remove special characters from feature names to improve legibility
feature_names<-gsub("-","",feature_names);feature_names<-gsub("\\(\\)","",feature_names)

#### Step 1: Load Measurements from Training & Test Datasets
# First load train and test data into tbls, then merge and name
X_train_raw<-read.table("./UCI HAR Dataset/train/X_train.txt",header = FALSE, sep = "")
X_test_raw<-read.table("./UCI HAR Dataset/test/X_test.txt",header = FALSE, sep = "")
X_total<-rbind(X_train_raw, X_test_raw) # merge train & test data into a single table
names(X_total)<-feature_names # use feature names from above to name columns in table

#### Step 1: Load Activity Data
# 1) load activities for train & test dataset, 2) combine into single vector, 3) assign activity label to each activity code
# (acitivity codes are taken from file "activity_labels.txt")
y_train_raw<-read.table("./UCI HAR Dataset/train/y_train.txt",header = FALSE, sep = "", col.names="Activity")
y_test_raw<-read.table("./UCI HAR Dataset/test/y_test.txt",header = FALSE, sep = "", col.names="Activity")
y_total<-rbind(y_train_raw, y_test_raw)

y_total[y_total==1] = "WALKING"
y_total[y_total==2] = "WALKING_UPSTAIRS"
y_total[y_total==3] = "WALKING_DOWNSTAIRS"
y_total[y_total==4] = "SITTING"
y_total[y_total==5] = "STANDING"
y_total[y_total==6] = "LAYING"


#### Step 1: Load Subjects Data
# Load subject data from train & test dataset, indicate dataset in 2nd column and merge vectors
subjects_train<-read.table("./UCI HAR Dataset/train/subject_train.txt",header = FALSE, sep = "",col.names="Subject")
subjects_train[,2]="TRAIN"              # create 2nd column indicating this data is from the TRAIN dataset
names(subjects_train)[2]<-"Dataset"     # name that 2nd column "DATASET"

subjects_test<-read.table("./UCI HAR Dataset/test/subject_test.txt",header = FALSE, sep = "",col.names="Subject")
subjects_test[,2]="TEST"                # create 2nd column indicating this data is from the TEST dataset
names(subjects_test)[2]<-"Dataset"      # name that 2nd column "DATASET"
subjects_total<-rbind(subjects_train, subjects_test)

#### Step 2 & 3: Subset meaurements to extract or mean & std Merge Subject, Acvtivities & Measurement Results into a single table
x_data<-X_total[meanstd_colid]  # subset by selecting columns with selection vector for mean() & std()
Results_ungathered<-bind_cols(subjects_total,y_total, x_data)   # create a single table 
Results_tbl<-gather(Results_ungathered, key=Measurement, value=Result ,4:69)    #reshape data to tidy data


#### Step 4: Create Table (Summary_tbl) with means for each veriable of each activity per subject
Results_grouped<-group_by(Results_tbl,Subject, Activity, Measurement)   # group by subject, activity, measurement
Summary_tbl<-summarise_each(Results_grouped,funs(mean), Result) # create summary table
names(Summary_tbl)[4]="Average"

write.table(Summary_tbl, "tidy_data.txt", row.names = FALSE, quote = FALSE)

