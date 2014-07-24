human-activity-dataset
======================

The program run_analysis.R is written with assumption that "UCI HAR Dataset" is situated outside of the "human-activity-dataset" directory. 
and same level as "human-activity-dataset" (see File structure, for clarification)

File structure:
---------------
"human-activity-dataset"
 - README.md
 - run_analysis.R
"UCI HAR Dataset"
 - features.txt
 - activity_labels.txt
 - test/subject_test.txt
 - test/X_test.txt
 - test/y_test.txt
 - train/subject_train.txt
 - train/X_train.txt
 - train/y_train.txt
 
Before you run the program,
 1. make sure that your source folder looks like the file structure above. 
 2. Change your directory to "human-activity-dataset" and type source("run_analysis.R")
 3. Call run_analysis()
 
run_analysis.R will produce "tidyData1.csv" and "tinyData2.csv" and the variable names are described in CodeBook.md
 
To view the tinyData produced by run_analysis(), there are multiple options:
---------------------------------------------------------------------------
1. Open the file using read.csv in R:
    data <- read.csv("tinyData1.csv")
2. Open the file using a spreadsheet program. Double click on it to launch the tinyData in your spreadsheet program. 
 
