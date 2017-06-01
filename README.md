# Getting and Cleaning Data - Course Project

### This repository contains a script called "run_analysis.r", which does the following:

1. Download and unzip the data for the final project of the "Getting and Cleaning Data" course
2. Load all the files regarding test and train datasets, and rename the variables
3. Extract only variables of the mean and standard deviation
4. Merge test and train datasets into one large dataset called "large_set"
5. Group the large dataset by "subject" and "activity" and calculate the mean for each of the measurement variables
6. Assign the result of last step to a variable called "mean_set"
7. Write the "mean_set" table into a text file called "tidy_data.txt", which is the final output of the script.
