# Summarized Human Activity Recognition Using Smartphones Dataset
## Introduction
The Summarized Human Activity Recognition Using Smartphones Dataset **(SumHumanActivityData)** is a tidy dataset, obtained by processing the
Human Activity Recognition Using Smartphones Dataset **(HumanActivityData)**, which summarizes the averages and standard deviations for several variables
of the HumanActivityData files in terms of the subjects participating in the study and the activities performed by them.
General information and download links for the latter dataset can be found in
[Human Activity Recognition Using Smartphones Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

This repository corresponds to the final peer-graded assignment for the [Getting and Cleaning Data course](https://www.coursera.org/learn/data-cleaning) from [www.coursera.org](https://www.coursera.org).

This repository contains the next files:
- README.md: The file you are reading. Contains general information about the repository, the files in it and how they work.
- run_analysis.R: R script which produces the SumHumanActivityData.
- Summarized_Human_Activity_Data.txt: The Summarized Human Activity Recognition Using Smartphones Dataset (SumHumanActivityData).
- CodeBook.md: The code book for the SumHumanActivityData.

## Constructing the SumHumanActivityData
This section will describe how to use the run_analysis.R script and how it works.

The run_analysis.R script assumes you have downloaded the HumanActivityData. The data can be found in the link given at the beginning of this file. In the Getting and Cleaning Data course another link is given to this dataset: [HumanActivityData](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), which download the .zip file "getdata_projectfiles_UCI_HAR_Dataset.zip" to your computer.

In order for the script to work you must have unzipped this file directly in your working directory so ending up with a directory called "UCI HAR Dataset" which should also be in your working directory.

When running the run_analysis.R script you should end up with the file Summarized_Human_Activity_Data.txt in your working directory. Your global environment should end up with a tibble data frame called summarized.data, which is the one printed to the file Summarized_Human_Activity_Data.txt.

The run_analysis.R script relies on the next specifications in order to work.
1. R version 3.2.5.
2. RStudio 1.0.36.

You must also have installed the latest stable versions of the packages:
1. tidyverse (this package calls the packages dplyr, readr, among other creations of Hadley Wickham).
2. stringi
3. Packages downloaded by default in Rstudio 1.0.36.

The locales corresponding to the manipulation of strings are set to: en_US.UTF-8.

The run_analysis.R script is separated in 6 big pieces. The first one loads the needed data and the other five performs the operations as asked in the peer-graded assignment. The run_analysis.R script is complemented with a lot of comments explaining the totality of the code. In order to get a detailed knowledge of the script the run_analysis.R script should be read.

### Sections of the script
- **Importing the data:**\
This part is labeled by "IMPORTING THE PACKAGES TO USE" and "READING THE ALL THE IMPORTANT FILES FOR THE WORK" in the script. It loads the tidyverse and stringi packages and read the files X_train.txt, X_test.txt, subject_text.txt, subject_train.txt, y_test.txt, y_train.txt and activity_labels.txt by using the readr function read_table. Specifications are very simple and can be found directly in the script. For the activity and subject IDs columns, the columns names are provided to the data frames.
1. **Merging the test and train dataset:**\
First, it column binds the train and test data (for each there is a X_\*.txt, y_\*.txt and subject_\*.txt file, where the asterisk is replaced by test or train) by using the function bind_cols from dplyr. Then, the full.test.dataset and full.train.dataset are row binded by using the function bind_rows from dplyr into a data frame called human.activity.dataset.
2. **Extracting the measurements on the mean and standard deviation for each measurement:**\
The criteria for chosing the mean and standard deviation can be found in the CodeBook.md file. First, the script reads the 561 features of the data from the features.txt file. A character vector containing the full names for the human.activity.dataset tibble is created. With grep we find the indexes of this vector containing the next regular expression "SubjectID|ActivityID|mean\\(\\)|std\\(\\)" and store the indexes in selected.columns. Then, human.activity.dataset is updated by using select from dplyr with selected.columns as its second argument.
3. **Descriptive activity names:**\
Up to this point the activities in the human.activity.dataset are described by the variable ActivityID which is an integer. In this part, the script first creates a function called formatColumn which receives a character vector and returns the same character vector formatted in another way. The link between ActivityID and ActivityName are obtained from the activity_labels.txt file. formatColumn changes the activity names from the format WALKING_DOWNSTAIRS to the format WalkingDownstairs. By using this we update the activity.labels tibble (which contains information from activity_labels.txt) to format the ActivityName. Finally, we inner_join activity.labels with human.activity.dataset by ActivityID and take all the columns except for ActivityID, so we are left with the ActivityName column in human.activity.dataset.
4. **Labeling the dataset with descriptive variable names:**\
In this part, we are going to integrate the column names taken from features.txt to out tibble data frame. First, we update the ActivityID column name for ActivityName. Then, we treat the column names from the selected columns for part 2; for this we just extract the column names using the indexation from selected.columns as in part 2.\
We want to convert the names obtained from features.txt to sintactically valid names. The script first retains only the alphanumeric symbols for all column names. Then, we create a function called replacePattern which takes a string and look for matches within a 'pattern' character vector and replaces each match by its corresponding string in a 'replacement character' vector. This function relies heavily in the stri_replace_all_regex from the stringi package. By using this function, we reformat all the column names extracted from the features.txt file into a more understandable format. We then add the column names to human.activity.dataset.
5. **Summarizing the data by subject and activity:**\
An object called summarized.data is constructed by grouping human.activity.dataset by SubjectID and ActivityName (group_by function) and summarizing by taking the mean for each non grouped column (summarise_all function). Column names for summarized.data are updated by adding "Avg" at the end of each averaged measurement. Then, using the dplyr function write_delim, summarized.data is written to the file Summarized_Human_Activity_Data.txt. Finally, all the residual objects and functions are deleted from the Global Environment.

## Executing run_analysis.R
Your working directory must contain the "UCI HAR Dataset" directory, the required packages as explained above and the script run_analysis.R should be in top level of your working directory. If being so, just source the script and you must end with object summarized.data in your global environment and with this data copied to the file Summarized_Human_Activity_Data.txt in your working directory.

## Reading Summarized_Human_Activity_Data.txt
To read this text file the best choice is to use read_table2() from the readr package. The argument should be the path to the file and no further arguments are required.
