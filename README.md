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

The run_analysis.R script relies on the next specifications in order to work.
1. R version 3.2.5.
2. RStudio 1.0.36.
You must also have installed the latest stable versions of the packages:
1. tidyverse (this package calls the packages dplyr, readr, among other creations of Hadley Wickham).
2. stringi
3. Packages downloaded by default in Rstudio 1.0.36.
