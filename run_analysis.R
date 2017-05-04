# run_analysis.R
# This script performs the required steps as described in the peer-graded
# assignment for the Getting and Cleaning Data course in www.coursera.org.
#
# The script assumes you have unzip the data file
# "getdata_projectfiles_UCI HAR Dataset.zip" in your working directory. This is
# your working directory contains a directory called "UCI HAR Dataset".
#
# This script also assumes you have the tidyverse packages installed.
# tidyverse is a set of packages which work very nice together. This is because
# they share a lot of common internal features. The tidyverse is a proposal of
# the very well known Hadley Wickham and includes several packages used in the
# Data Science specialization courses from www.coursera.org.
# The tidyverse contanins, among several other packages, the packages
#  1. dplyr
#  2. readr
#  3. tidyr

# -----------------------------------------------------------------------------
# IMPORTING THE PACKAGES TO USE
# -----------------------------------------------------------------------------

# Importing the tidyverse and the stringi package
library(tidyverse)
library(stringi)

# -----------------------------------------------------------------------------
# READING THE ALL THE IMPORTANT FILES FOR THE WORK
# -----------------------------------------------------------------------------

# Reading the train and test files
# By default the columns are read as doubles with no headers in the read file
train.dataset <- read_table("UCI HAR Dataset/train/X_train.txt",
                            col_names = FALSE, na = "N/A",
                            col_types = cols(.default = col_double()))
test.dataset  <- read_table("UCI HAR Dataset/test/X_test.txt", 
                            col_names = FALSE, na = "N/A",
                            col_types = cols(.default = col_double()))

# Reading the activity labels
# The columns are parse as according to the activity.labels.cols variable
# The columns types are known just by simple inspection of the file
activity.labels.cols <- cols(ActivityID = col_integer(),
                             ActivityName = col_character())
activity.labels <- read_table("UCI HAR Dataset/activity_labels.txt",
                              col_names = c("ActivityID", "ActivityName"),
                              col_types = activity.labels.cols)

# Reading the activity and subject files for test and train
# These files contain activity ID's and subject ID's which match each row of
# the dataset. There are activity and subject files for the test.dataset and
# the train.dataset respectively. The names as descriptive by its own
test.subject.ids   <- read_table("UCI HAR Dataset/test/subject_test.txt",
                                 col_names = "SubjectID")
test.activity.ids  <- read_table("UCI HAR Dataset/test/y_test.txt",
                                 col_names = "ActivityID")
train.subject.ids  <- read_table("UCI HAR Dataset/train/subject_train.txt",
                                 col_names = "SubjectID")
train.activity.ids <- read_table("UCI HAR Dataset/train/y_train.txt",
                                 col_names = "ActivityID")

# -----------------------------------------------------------------------------
# 1. MERGING THE TEST AND TRAIN DATASETS
# -----------------------------------------------------------------------------

# We just use the bind_cols() and bind_rows() functions from the dplyr package
# These are very efficient and produces tibbles data frames

# We first get together the activity and subject ids for the test and train
# datasets
full.test.dataset  <- bind_cols(test.subject.ids, test.activity.ids,
                                test.dataset)
full.train.dataset <- bind_cols(train.subject.ids, train.activity.ids,
                                train.dataset)

# Then, we construct the full human activity dataset by row binding the two
# data frames
human.activity.dataset <- bind_rows(full.test.dataset, full.train.dataset)

# -----------------------------------------------------------------------------
# 2. EXTRACTING THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH
#    MEASUREMENT
# -----------------------------------------------------------------------------

# We first import the column names as given in the information that comes with
# the data. Then, we construct a character vector containing the full names of
# the columns. These are still not processed, this is, they are not valid
# column names. However, they allow us to extract the columns we need
col.names         <- read.table("UCI HAR Dataset/features.txt",
                                stringsAsFactors = FALSE)[, 2]
full.column.names <- c(colnames(human.activity.dataset)[1:2], col.names)

# We now look for the positions within the full.column.names vector containing
# the words SubjectID, ActivityID and the mean() and std() variables.
# We do not extract the columns containing mean frequencies, since they depend
# on the process of the Fast Fourier Transform, so they are not measurements.
# Nor do we extract the angles between average vectors, since they are not
# exactly measurements and can be computed from the extracted data.
selected.columns <- grep("SubjectID|ActivityID|mean\\(\\)|std\\(\\)",
                         full.column.names)

# Now we extract the columns from the full human.activity.dataset
# The name of our dataset will still be human.activity.dataset along the whole
# script.
human.activity.dataset <- select(human.activity.dataset, selected.columns)

# -----------------------------------------------------------------------------
# 3. DESCRIPTIVE ACTIVITY NAMES
# -----------------------------------------------------------------------------

# In this part of the script we are going to change the data in the column
# ActivityID for the human.activity.dataset, which is integer, to descriptive
# factor variables.
# For that we have loaded the activity labels from files which come with the
# original data. The activity labels are in the tibble data frame
# activity.labels.

# We first clean up the activity names a to friendlier format.
# We define the function format.column which format strings in the ActivityName
# column.
formatColumn <- function(column) {
  # Returns the character vector column, which must be formatted as letters
  # separated by underscores (_), in a format where strings separated by single
  # space and with all words starting in capital letters and the rest of
  # letters are lower case.
  #
  # Args:
  #   column: The character vector to be formatted.
  #
  # Returns:
  #   The column formatted in the way described above.
  
  # Prepare useful objects
  nrow <- length(column)
  formatted.strings <- character(nrow)
  # Format the column
  for(i in 1:nrow) {
    splitted.string      <- strsplit(column[i], "_")[[1]]
    formatted.strings[i] <- paste(stri_trans_totitle(splitted.string),
                                  sep = "", collapse = "")
  }
  # Returns the formatted column
  formatted.strings
}

# We now transform the names of the activities in the activity.labels data.
# And we also apply several transformations by using the dplyr grammar in order
# to clean up the human.activity.dataset with the ActivityName column in
# appropiated format.
activity.labels        <- mutate(activity.labels, ActivityName = 
                                 formatColumn(ActivityName))
human.activity.dataset <- activity.labels %>% 
                          inner_join(human.activity.dataset,
                                     by = "ActivityID") %>% 
                          select(SubjectID, ActivityName, X1:X543)

# -----------------------------------------------------------------------------
# 4. LABELING THE DATASET WITH  DESCRIPTIVE VARIABLE NAMES
# -----------------------------------------------------------------------------

# In this part we label the dataset with descriptive variable names. This is,
# we construct a character vector containing the appropriate column names for
# our human activity dataset.
# We take as the base the full.column.names and start from there.

# The index for the column names we want are already in selected.columns
selected.columns.names <- full.column.names[selected.columns]

# We also have "replaced" the ActivityID column by the equivalent ActivityName
# column
selected.columns.names[2] <- "ActivityName"

# We now process the selected.columns.names character vector in order to create
# sintactically valid column names for our human.activity.dataset.
# Eliminate non alphanumeric characters
selected.columns.names <- stri_replace_all_regex(selected.columns.names,
                                                 "[^[:alnum:]]", "")

# We introduce now a function to replace substrings within a string vector.

replacePattern <- function(str, pattern, replacement) {
  # A function which in the string str replace every appearence of a substring
  # in pattern by its correspondent string in replacement.
  # The arguments pattern and replacement should have the same length.
  #
  # Args:
  #   str: The string in which patterns are going to be find and replaced.
  #   pattern: A character vector containing all patterns to look for.
  #   replacement: A character containing all the replacements strings to do.
  #
  # Returns:
  #   The string str with all patterns in pattern replaced by its correspondent
  #   replacement string in replacement.
  #
  # Special recomendations:
  # One should be very careful when using this function, since we are looping
  # over the pattern and replacement vectors. An later pattern can be contained
  # in an already replaced pattern so producing and unwanted result.
  
  n.pattern <- length(pattern)
  for(i in 1:n.pattern) {
    str <- stri_replace_all_regex(str, pattern[i], replacement[i])
  }
  str
}

# Define the patter and replacement vectors
pattern     <- c("mean", "std", "Acc", "Mag", "Gyro", "X", "Y", "Z", "BodyBody")
replacement <- c("Mean", "StandardDev", "Accel", "Magnitude", "AngularVel",
                 "XDir", "YDir", "ZDir", "Body")

# Format the column names
selected.columns.names <- sapply(as.list(selected.columns.names),
                                 replacePattern, pattern = pattern,
                                 replacement = replacement)

# Assing column names to the human.activity.dataset
colnames(human.activity.dataset) <- selected.columns.names

# -----------------------------------------------------------------------------
# 5. SUMMARIZING THE DATA BY SUBJECT AND ACTIVITY
# -----------------------------------------------------------------------------

# In this part we summarize the human.activity.dataset by subject and activity.
# This is a very simple process using the dplyr grammar.
summarized.data <- human.activity.dataset %>%
                   group_by(SubjectID, ActivityName) %>%
                   summarise_all(mean)

# We change the columns names since these are now the averages of the original
# columns of the human.activity.dataset
selected.columns.names[3:68] <- sapply(as.list(selected.columns.names[3:68]),
                                       replacePattern, "$", "Avg")
colnames(summarized.data)[3:68] <- selected.columns.names[3:68]

# Finally, we write our tibble data frame in .txt file.
write_delim(summarized.data, "./Summarized_Human_Activity_Data.txt")

# At last, we eliminate the residual objects
rm(activity.labels.cols, train.dataset, test.dataset, test.subject.ids,
   test.activity.ids, train.subject.ids, train.activity.ids, full.test.dataset,
   full.train.dataset, col.names, activity.labels, full.column.names, pattern,
   replacement, selected.columns, selected.columns.names, formatColumn,
   replacePattern)