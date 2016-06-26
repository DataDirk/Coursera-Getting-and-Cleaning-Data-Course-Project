# Getting and Cleaning Data Project

## run_analysis.R


This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Loads the table of variables ("features") and creates vector with descriptive names
2. Loads the training & test datasets and merges them into a single dataset
3. Load the activity and feature info for training & test and merges them into a single dataset
4. Loads the subject dataset
5. It selects only those columns of the which contain a mean value or standard deviation
6. It merges subject, activity data and the selected columns into a single dataset
7. Creates a dataset "Summary_tbl" that contains the average of each variable for each           activity and each subject in a separate row.
8. It saves the result in the file "tidy_data.txt".