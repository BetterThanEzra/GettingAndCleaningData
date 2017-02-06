##FEATURE SELECTION


###Secondary Analysis

A secondary analysis was performed on the Intial Analysis Dataset. 

Training and test data was recombined, along with corresponding activity and subject data. Activity codes were replaced with corresponding labels. All variables based on estimations of mean and standard deviation we kept.

Finally, values for each feature were averaged for activity performed by each subject. 


###Features
Features are represented in the following way:
```
example_feature
       feature_contents
```

####Features of Secondary Analysis in "average_variables_per_subject_and_activity.csv"

```

activity 
       WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
subject
      integer 1..30
tBodyAcc-mean()-X
      decimal (-1,1)
tBodyAcc-mean()-Y
      decimal (-1,1)
tBodyAcc-mean()-Z
      decimal (-1,1)
tGravityAcc-mean()-X
      decimal (-1,1)
tGravityAcc-mean()-Y
      decimal (-1,1)
tGravityAcc-mean()-Z
      decimal (-1,1)
tBodyAccJerk-mean()-X
      decimal (-1,1)
tBodyAccJerk-mean()-Y
      decimal (-1,1)
tBodyAccJerk-mean()-Z
      decimal (-1,1)
tBodyGyro-mean()-X
      decimal (-1,1)
tBodyGyro-mean()-Y
      decimal (-1,1)
tBodyGyro-mean()-Z
      decimal (-1,1)
tBodyGyroJerk-mean()-X
      decimal (-1,1)
tBodyGyroJerk-mean()-Y
      decimal (-1,1)
tBodyGyroJerk-mean()-Z
      decimal (-1,1)
tBodyAccMag-mean()
      decimal (-1,1)
tGravityAccMag-mean()
      decimal (-1,1)
tBodyAccJerkMag-mean()
      decimal (-1,1)
tBodyGyroMag-mean()
      decimal (-1,1)
tBodyGyroJerkMag-mean()
      decimal (-1,1)
fBodyAcc-mean()-X
      decimal (-1,1)
fBodyAcc-mean()-Y
      decimal (-1,1)
fBodyAcc-mean()-Z
      decimal (-1,1)
fBodyAcc-meanFreq()-X
      decimal (-1,1)
fBodyAcc-meanFreq()-Y
      decimal (-1,1)
fBodyAcc-meanFreq()-Z
      decimal (-1,1)
fBodyAccJerk-mean()-X
      decimal (-1,1)
fBodyAccJerk-mean()-Y
      decimal (-1,1)
fBodyAccJerk-mean()-Z
      decimal (-1,1)
fBodyAccJerk-meanFreq()-X
      decimal (-1,1)
fBodyAccJerk-meanFreq()-Y
      decimal (-1,1)
fBodyAccJerk-meanFreq()-Z
      decimal (-1,1)
fBodyGyro-mean()-X
      decimal (-1,1)
fBodyGyro-mean()-Y
      decimal (-1,1)
fBodyGyro-mean()-Z
      decimal (-1,1)
fBodyGyro-meanFreq()-X
      decimal (-1,1)
fBodyGyro-meanFreq()-Y
      decimal (-1,1)
fBodyGyro-meanFreq()-Z
      decimal (-1,1)
fBodyAccMag-mean()
      decimal (-1,1)
fBodyAccMag-meanFreq()
      decimal (-1,1)
fBodyBodyAccJerkMag-mean()
      decimal (-1,1)
fBodyBodyAccJerkMag-meanFreq()
      decimal (-1,1)
fBodyBodyGyroMag-mean()
      decimal (-1,1)
fBodyBodyGyroMag-meanFreq()
      decimal (-1,1)
fBodyBodyGyroJerkMag-mean()
      decimal (-1,1)
fBodyBodyGyroJerkMag-meanFreq()
      decimal (-1,1)
angle(tBodyAccMean,gravity)
      decimal (-1,1)
angle(tBodyAccJerkMean),gravityMean)
      decimal (-1,1)
angle(tBodyGyroMean,gravityMean)
      decimal (-1,1)
angle(tBodyGyroJerkMean,gravityMean)
      decimal (-1,1)
angle(X,gravityMean)
      decimal (-1,1)
angle(Y,gravityMean)
      decimal (-1,1)
angle(Z,gravityMean)
      decimal (-1,1)
tBodyAcc-std()-X
      decimal (-1,1)
tBodyAcc-std()-Y
      decimal (-1,1)
tBodyAcc-std()-Z
      decimal (-1,1)
tGravityAcc-std()-X
      decimal (-1,1)
tGravityAcc-std()-Y
      decimal (-1,1)
tGravityAcc-std()-Z
      decimal (-1,1)
tBodyAccJerk-std()-X
      decimal (-1,1)
tBodyAccJerk-std()-Y
      decimal (-1,1)
tBodyAccJerk-std()-Z
      decimal (-1,1)
tBodyGyro-std()-X
      decimal (-1,1)
tBodyGyro-std()-Y
      decimal (-1,1)
tBodyGyro-std()-Z
      decimal (-1,1)
tBodyGyroJerk-std()-X
      decimal (-1,1)
tBodyGyroJerk-std()-Y
      decimal (-1,1)
tBodyGyroJerk-std()-Z
      decimal (-1,1)
tBodyAccMag-std()
      decimal (-1,1)
tGravityAccMag-std()
      decimal (-1,1)
tBodyAccJerkMag-std()
      decimal (-1,1)
tBodyGyroMag-std()
      decimal (-1,1)
tBodyGyroJerkMag-std()
      decimal (-1,1)
fBodyAcc-std()-X
      decimal (-1,1)
fBodyAcc-std()-Y
      decimal (-1,1)
fBodyAcc-std()-Z
      decimal (-1,1)
fBodyAccJerk-std()-X
      decimal (-1,1)
fBodyAccJerk-std()-Y
      decimal (-1,1)
fBodyAccJerk-std()-Z
      decimal (-1,1)
fBodyGyro-std()-X
      decimal (-1,1)
fBodyGyro-std()-Y
      decimal (-1,1)
fBodyGyro-std()-Z
      decimal (-1,1)
fBodyAccMag-std()
      decimal (-1,1)
fBodyBodyAccJerkMag-std()
      decimal (-1,1)
fBodyBodyGyroMag-std()
      decimal (-1,1)
fBodyBodyGyroJerkMag-std()
      decimal (-1,1)
```

The list of variables of each feature vector is also available in 'analysis_features.txt'

The secondary analysis was based on the following...

Initial Analysis Dataset
========================
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

A Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'
