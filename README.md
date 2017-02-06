##Getting and Cleaning Data - Week 4 Assigment

###Instructions

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

Review criteria:

1. The submitted data set is tidy.
2. The Github repo contains the required scripts.
3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
4. The README that explains the analysis files is clear and understandable.
5. The work submitted for this project is the work of the student who submitted it.

###Getting and Cleaning Data Course Project
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 

1. A tidy data set as described below
2. A link to a Github repository with your script for performing the analysis
3. A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
4. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/) . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

---

##run_analysis.R

This R script called run_analysis.R does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

This analysis asumes the working directory contains the folder "/UCI HAR Dataset/" with the files extracted from the .zip downloaded at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

* /UCI HAR Dataset/
* /UCI HAR Dataset/activity_labels.txt
* /UCI HAR Dataset/features.txt
* /UCI HAR Dataset/features_info.txt
* /UCI HAR Dataset/README.txt        
* /UCI HAR Dataset/test/subject_test.txt
* /UCI HAR Dataset/test/X_test.txt
* /UCI HAR Dataset/test/y_test.txt
* /UCI HAR Dataset/test/Inertial Signals (UNUSED)
* /UCI HAR Dataset/train/subject_train.txt
* /UCI HAR Dataset/train/X_train.txt
* /UCI HAR Dataset/train/y_test.txt
* /UCI HAR Dataset/train/Inertial Signals (UNUSED)


This block is extraneous to the assigment, but it may be handy. By setting `confirm_directory = TRUE` we can confirm the working driectory contains the correct files

```r

confirm_directory = TRUE

if(confirm_directory){
        
        if(any(dir()=="test") &
           
           any(dir()=="train") &
           
           any(dir()=="README.txt") &
             
           any(dir()=="features_info.txt") &
           
            any(dir()=="features.txt") &
           
            any(dir()=="activity_labels.txt")
           
           ) {
                
                 print("Looks like working directory contains the correct files.")
       
       } else if(any(dir()=="UCI HAR Dataset")){
                
                # returns specific folder index from list of working directory contents
                
                dir_index <- which(dir()=="UCI HAR Dataset")    
                
                
                # sets working directory 
                
                setwd(dir()[dir_index])                         
               
                print("Working directory set to '/UCI HAR Dataset'")
      
      } else {
      
              print("data files not found in working directory")
              
      }
}
  
 ```

This analysis makes use of the "readr" package, as part of the tidyvrese. https://github.com/tidyverse/readr. This is another extra code block where we check if "readr" is not installed and download & install it if necessary.

Note: `require` returns `TRUE` if a package is installed and loaded. 

```r        
if(!require("readr")){ 
        
        if (!"readr" %in% installed.packages()) install.packages("readr")
                
        library(readr)
}
```

Okay, let's get to it then.
###1. Merge the training and the test sets to create one data set.  

```r
        Load features to use as labels.
        
        features<- readLines("features.txt")
        
        
        #Use length of features to set number of columns in fixed width file
        
        number_of_columns <- length(features)
        
        
        # Upon examination, "X_test.txt" is a fixed width file, with columns 16 characters wide.
        # To create column of width 16 chars long, with the number of columns equal to the number of features,
        # we use the following readr package command. Note that we can also add column names at this time.
        
        col_widths <- fwf_widths( rep(16, number_of_columns), features)
        
        
        #Use readr to create the "test" data frame.
        
        Xtest_df <- read_fwf("test/X_test.txt", col_widths)
        
        
        #Combine test labels data with test data.
        
        Xtest_df <- cbind("Activity" = readLines("test/y_test.txt"), Xtest_df)
        
        #Combine test subjects data with test data.
        
        Xtest_df <- cbind("Subject" = readLines("test/subject_test.txt"), Xtest_df)
        
        
        #Rinse and repeat for training data.
        
        Xtrain_df <- read_fwf("train/X_train.txt", col_widths)
        
        Xtrain_df <- cbind("Activity" = readLines("train/y_train.txt"), Xtrain_df)
        
        Xtrain_df <- cbind("Subject" = readLines("train/subject_train.txt"), Xtrain_df)
       
        
        #Now combine the data frames to complete requirement #1.
        
        combined_df <- rbind(Xtest_df, Xtrain_df)
```        


##2. Extract only the measurements on the mean and standard deviation for each measurement.     
       
We use `grepl` to return a list of booleans, based on the existance of a regular expresion with the list elements passed.
In this case, we are passing the list of column labels, and the booleans are used to subset the combined data frame, `combined_df`.

```r        
        means_df <- combined_df[ grepl("[mM]ean", labels(combined_df)[[2]]) ]
        
        std_df <- combined_df[ grepl("std", labels(combined_df)[[2]]) ]
        
        extracted_df <- cbind(means_df, std_df)
```        
     
##3. Use descriptive activity names to name the activities in the data set.  

```r
        #First, recombine the activity column.
        
        extracted_df <- cbind("Activity" = combined_df$"Activity", "Subject" = combined_df$"Subject",extracted_df)
        
        
        #Create a data from of the activity lables.
        
        activity_labels_df <- read.delim("activity_labels.txt", sep = " ", header = FALSE, col.names = c("Activity", "Activity_Label"))

        
        #Merge the dataframes along the "Activity" column. Note that doing so also arranges vales in ascending values of "Activity".
        
        labeled_extracted_df <- merge(activity_labels_df, extracted_df, by.y = "Activity", by.x = "Activity")
        
        
        #Finally we remove the "Activity" column for being unnessesary. We keep only `Activty_Label`, which contains the descriptive activty names.
        
        labeled_extracted_df <- within(labeled_extracted_df, rm("Activity"))
        
```        
   
##4. Appropriately labels the data set with descriptive variable names. 

Each feature name is descriptive, but contains an unnessesary leading number, to be removed. The regular expression (first argument of `gsub`), finds numbers (`[0123456789]`) that occur one or more times (`+`) before a space (`" "`) and `gsub` replaces it with `""` (no characters)

```r

        old_feature_names <- colnames(labeled_extracted_df)
        
        tidy_feature_names <- gsub("[0123456789]+ ", "", old_feature_names )
        
        colnames(labeled_extracted_df) <- tidy_feature_names
        
        #Let's save this tidy data set. It represents the completion of requirements 1-4.
        
        write.csv(labeled_extracted_df, "tidy_data_set.csv", sep = ",", row.names=FALSE)
```

Nice! Now...
      
##5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
     
Our method is to subset `labeled_extracted_df` on each subject, then each activity, then build a new dataframe with averages (means) of the subsetted data. Given's R's many elegant conveniences, there may be a more compact way to do this, but the good 'ol, nested `for` loop will get the job done, and is easily readable.

```r
        #The results are attached to an initially empty dataframe, so begin by creating an empty dataframe of the 
        #appropriate width to `rbind` our results to, after every loop.
        
        final_results_df <-as.data.frame( rep( list(double(0)), each = length(labeled_extracted_df)) )
```        
        
Alright, now the heavy lifting...
```r        
        #Get count of unique values in the "Subject" column and loop that many times.
        
        for(i in 1:length(unique(labeled_extracted_df$"Subject"))){
             
                    #Of the vector of unique values in "Subject" select the i-th one of them.
                
                    subject_val <- unique(labeled_extracted_df$"Subject")[i]     
             
                    #Subset labeled_extracted_df, for all rows containing the specific unique.  
                
                    subject_df <- labeled_extracted_df[ labeled_extracted_df$"Subject"==subject_val, ]
                
             
                    #Repeat this above process for unique values in "Activity_Label", subsetting the previously subset dataframe.
            
                    for(j in 1:length(unique(labeled_extracted_df$"Activity_Label"))) {
                     
                            activity_val <- unique(labeled_extracted_df$"Activity_Label")[j]
                     
                            sub_act_df <- subject_df[ subject_df$"Activity_Label"==activity_val,]
                    
                            
                            
                            #This `if` test is proably unnessesary, but it makes sure we are not adding empty rows to the dataframe.
                            #Empty rows would be a result of certain subjects not performing certain activities.                         

                            if(length(sub_act_df) > 0){
                             
                                      #Non-averaging columns are removed so the remaining columns may be easily averaged.
                             
                                      sub_act_df <- within(sub_act_df, rm("Activity_Label"))
                            
                                      sub_act_df <- within(sub_act_df, rm("Subject"))
                     
                             
                                      #Create a dataframe of averages of columns (defult is tall, not wide).
                             
                                      avgs_df <- data.frame(colMeans(sub_act_df))
                             
                                      #Transpose so data is wide, not tall.
                             
                                      avgs_df <- t(avgs_df)
                             
                             
                                      #Remove residual row names.
                             
                                      rownames(avgs_df) <- NULL
                     
                             
                                      #Reattach "activity" and "subject" value rows.
                            
                                      avgs_df <- cbind("activity" = as.character(activity_val), "subject" = (subject_val), avgs_df)
                     
                     
                                      #Attach averaged results to results dataframe.
                            
                                      final_results_df <- rbind(final_results_df, avgs_df)
                             
                     }
                     
             }  
                
                
        }

        #Now write the results to a file and we are finished.

        write.csv(final_results_df, "average_variables_per_subject_and_activity.csv", sep = ",", row.names=FALSE)
        
```
