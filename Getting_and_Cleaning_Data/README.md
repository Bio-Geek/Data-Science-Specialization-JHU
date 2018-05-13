Course Project. Getting and Cleaning Data. Coursera.
----------------------------------------------------
**Files presented in this project:**

* run_analysis.R

* MyTidyData_codebook

* MyTidyData_codebook.pdf


**The run_analysis.R script does the following:**

1) Merges the training and the test sets to create one data set.

2) Extracts only the measurements on the mean and standard deviation for each
   measurement.
   
3) Uses descriptive activity names to name the activities in the data set.

4) Appropriately labels the data set with descriptive variable names.

5) From the data set in step 4, creates a second, independent tidy data set
   with the average of each variable for each activity and each subject.
   The final data set is created using "dplyr" package. 
   The data set meets the principeles of tidy data per "Tidy Data" paper 
   by Hadley Wickham.

6) Data set is uploaded as "MyTidyData.txt" file created with write.table() using row.name=FALSE.


* To run the script, the provided "UCI HAR Dataset" folder and "run_analysis.R"
file should be placed in the current working directory in R.

* To run the file in RStudio type 'source("run_analysis.r")' in the console.

* For viewing the tidy data set, the resulting txt file can be read into R with read.table:

If downloading the file from Coursera, please save the provided file link 'MyTidyData' as 
"YouFavoriteFileName.txt" in the current working directory.
To read the file in R:

data <- read.table("YouFavoriteFileName.txt")

* For description of tidy data file content please refer to the codebook "MyTidyData_codebook".

The original "UCI HAR Dataset" is located as a .zip file at the following url:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
