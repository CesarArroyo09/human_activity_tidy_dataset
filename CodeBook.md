# Code Book for the Summarized Human Activity Recognition Using Smartphones Dataset
## Introduction
The Summarized Human Activity Recognition Using Smartphones Dataset **(SumHumanActivityData)** is a tidy dataset, obtained by processing the
Human Activity Recognition Using Smartphones Dataset **(HumanActivityData)**, which summarizes the averages and standard deviations for several variables
of the HumanActivityData files in terms of the subjects participating in the study and the activities performed by them.
General information and download links for the latter dataset can be found in
[Human Activity Recognition Using Smartphones Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
Because this Code Book is about an already existing dataset, some of the information have been extracted from the next files:
- README.txt.
- features_info.txt.
- features.txt.

These files come with the HumanActivityData that can be downloaded in
[Human Activity Recognition Using Smartphones Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

This Code Book describes the variables within the SumHumanActivityData and the meaning of them.

## Raw data
The raw data for the SumHumanActivityData is actually already processed data. This data was obtained from accelerometeres and
gyroscopes inside smartphones for certain subjects performing several activities (as walking, walking downstairs, laying,
among others). The data was then processed and this is the data composing the HumanActivityData.

From the README.txt file within HumanActivityData:
>For each record it is provided:
>
>- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
>- Triaxial Angular velocity from the gyroscope. 
>- A 561-feature vector with time and frequency domain variables. 
>- Its activity label. 
>- An identifier of the subject who carried out the experiment.

The 561-feacture vector contains the values of the variables obtained from the experiment. The names for each component of this
vector can be found in the features.txt file within HumanActivityData.

In the HumanActivityData, the data was separated into the **test** dataset and the **train** dataset, containing the 30 and 70
percent of the observations respectively. For each of these datasets separate files for the subjects IDs and for the activity IDs
was supplied.

In the files containing the measurements X_test.txt and X_train.txt, we find in each row a 561-feature vector containing the
quantities of interest. These quantities are separated in time domain signals (indicated with a 't' prefix) and frequency domain
signals (obtained by performing a Fast Fourier Transform and indicated with a 'f' prefix). The time domain signals are already
averages since they were first collected and from the raw data they were processed and averaged over windows of time; the same
is for the frequency domain signals. As described in the features_info.txt file, the next variables are obtained:
> List 1: Physical Variables in the Experiment
> ---
>- tBodyAcc-XYZ: Linear acceleration (the suffix XYZ indicate measurements were taken in the X, Y and Z directions).
>- tGravityAcc-XYZ: Gravity Acceleration.
>- tBodyAccJerk-XYZ: Rate of change of linear acceleration.
>- tBodyGyro-XYZ: Angular velocity.
>- tBodyGyroJerk-XYZ: Rate of change of angular velocity.
>- tBodyAccMag: Magnitude of the linear acceleration.
>- tGravityAccMag: Magnitude of the gravity acceleration.
>- tBodyAccJerkMag: Magnitude of the tate of change of linear acceleration.
>- tBodyGyroMag: Magnitude of the angular velocity.
>- tBodyGyroJerkMag: Magnitude of the rate of change of the angular velocity.
>
> These ones are the same as above but after the Fast Fourier Transform was applied, so they are in the frequency domain.
>- fBodyAcc-XYZ:
>- fBodyAccJerk-XYZ
>- fBodyGyro-XYZ
>- fBodyAccMag
>- fBodyAccJerkMag
>- fBodyGyroMag
>- fBodyGyroJerkMag

For each of these quantities, it was obtained (also found in the features_info.txt file):
> List 2: Statistical quantities for Physical Variables
> -----------------------------------------------------
>- mean(): Mean value
>- std(): Standard deviation
>- mad(): Median absolute deviation 
>- max(): Largest value in array
>- min(): Smallest value in array
>- sma(): Signal magnitude area
>- energy(): Energy measure. Sum of the squares divided by the number of values. 
>- iqr(): Interquartile range 
>- entropy(): Signal entropy
>- arCoeff(): Autorregresion coefficients with Burg order equal to 4
>- correlation(): correlation coefficient between two signals
>- maxInds(): index of the frequency component with largest magnitude
>- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
>- skewness(): skewness of the frequency domain signal 
>- kurtosis(): kurtosis of the frequency domain signal 
>- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
>- angle(): Angle between to vectors.
Several other quantities were computed but they are not presented here. For each of the physical quantities, there is a
correspondent statistical quantity. So for the linear acceleration in the X direction as a time domain signal we have the
variables **tBodyAcc-mean()-X** and **tBodyAcc-std()-X**.

## Processed data
The data in the SumHumanActivityData is obtained by merging the train and test datasets. Also, the subjects IDs and activities
IDs information are all put together into one dataset. From there we extract the variables in List 1 containing "mean()" and "std()" in
their names, where the meaning of this variables is specified in List 2. Although there were other variable names containing
the string "Mean" in their names we didn't take them because they corresponded to "MeanFreq" variables which is an average of
the set of frequencies used in the Fourier Transform, and being so, they are not measurements. The variable "angle()" also
contains "Mean" quantities but we didn't take them because this variable is not an average but is the angle between several
"mean()" vectors. Also, the angle variable can be constructed from the data. Using the activity_labels.txt files we change the
activities IDs by their correspondent activity names formatted in a nice way. The data is then grouped by SubjectID and by
ActivityName the physical variables are collapsed by taking the average of these quantities by the grouping specified.

The variable names for the SumHumanActivityData are in the first line of the file Summarized_Human_Activity_Data.txt which is separated in the next way. The first two columns which are called SubjectID and
ActivityName.
- SubjectID: Integer containing the ID of the subject performing the different tests. It ranges from 1 to 30.
- ActivityName: Character indicating the activity performed. Can take the values Walking, WalkingUpstairs, WalkingDownstairs,
Sitting, Standing or Laying.

The meaning of the next 66 variables names can be constructed from the next list which specifies the meaning of each of the
strings that can be found in the name of a variable.

List 3: Semantics of the strings found in the variable names for SumHumanActivityData
--------
This list of semantics does not apply to the SubjectID and ActivityName variables which are described above.
- t, f: Each variable starts with one of these two strings. 't' prefix is for the time domain signals and 'f' prefix is for the frequency domain signals.
- Body, Gravity: The data is about the smartphone (in the Body of the person) or from gravity (the gravitational attraction from Earth). Only one of these two appears in each name.
- Accel, AngularVel: Means we are talking about linear acceleration (Accel) or angular velocity (AngularVel). Only one of these two appear in each name and AngularVel only appears in 'Body' variables.
- Jerk: Means the variable is the rate of change of the variable specified by the previous strings in the same variable name. Example: "tBodyAccelJerkMeanXDirAvg" is rate of change of linear acceleration of the body in time domain (describing only the first four substrings).
- Magnitude: Means we are talking about the magnitude (Euclidean norm) of the vector which name is specified by the previous strings in the same variable name. Example: "tBodyAccelMagnitudeMeanAvg" is the magnitude of the body acceleration vector in time domain (describing only the first four substrings).
- Mean, StandarDev: This means this variable was obtained by the average of variables containing "mean()" or "std()", respectively, in the raw data HumanActivityData. This is just renaming the specification given in List 2.
- XDir, YDir, ZDir: Means is the component in the specified direction of the vector specified by the previous strings in the same variable name. Example: "tGravityAccelMeanYDirAvg" is the mean in the Y component of the gravity acceleration vector in time domain (describing only the first five substrings).
- Avg: Contained in all the variable names. Means this is the average of the variable in the raw data specified by the previous strings for that ActivityName (activity performed) and SubjectID (person performing the activity).
