

##This R script called run_analysis.R does the following:
##1. Merges the training and the test sets to create one data set.
##2. Extracts only the measurements on the mean and standard deviation for each measurement.
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names.
##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#This analysis asumes the working directory conatins the folder "/UCI HAR Dataset/" with the files extracted from
#the .zip downloaded at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#/UCI HAR Dataset/
#/UCI HAR Dataset/activity_labels.txt
#/UCI HAR Dataset/features.txt
#/UCI HAR Dataset/features_info.txt
#/UCI HAR Dataset/README.txt        
#/UCI HAR Dataset/test/subject_test.txt
#/UCI HAR Dataset/test/X_test.txt
#/UCI HAR Dataset/test/y_test.txt
#/UCI HAR Dataset/test/Inertial Signals (UNUSED)
#/UCI HAR Dataset/train/subject_train.txt
#/UCI HAR Dataset/train/X_train.txt
#/UCI HAR Dataset/train/y_test.txt
#/UCI HAR Dataset/train/Inertial Signals (UNUSED)

#We can easily chech to make sure the folder is in place and set it as the working directory with a simple switch.

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
        }
        
        else if(any(dir()=="UCI HAR Dataset")){
                
                dir_index <- which(dir()=="UCI HAR Dataset")    # returns specific folder index from list of working directory contents
                
                setwd(dir()[dir_index])                         # sets working directory 
               
                print("Working directory set to '/UCI HAR Dataset'")
        }
                
        else {
               
                print("data files not found in working directory")
        }
}


##This analysis makes use of the "readr" package, as part of the tidyvrese. 
##https://github.com/tidyverse/readr 
##Here we check if "readr" is not installed and download & install if necessary
## "require" returns TRUE if a package is installed and loaded. 
## Note: 
        
if(!require("readr")){ 
        
        if (!"readr" %in% installed.packages()) install.packages("readr")
                
        library(readr)
}


###1. Merge the training and the test sets to create one data set.  

        # load features to use as labels.
        
        features<- readLines("features.txt")
        
        
        # use length of features to set number of columns in fixed width file
        
        number_of_columns <- length(features)
        
        
        # Upon examination, "X_test.txt" is a fixed width file, with columns 16 characters wide
        # to create column of width 16 chars long, with the number of columns equal to the number of features
        # we use the following readr package command. Note that we can also add column names at this time
        
        col_widths <- fwf_widths( rep(16, number_of_columns), features)
        
        
        # use readr to create the "test" data frame
        
        Xtest_df <- read_fwf("test/X_test.txt", col_widths)
        
        
        #combine test labels data with test data
        
        Xtest_df <- cbind("Activity" = readLines("test/y_test.txt"), Xtest_df)
        
        #combine test subjects data with test data
        
        Xtest_df <- cbind("Subject" = readLines("test/subject_test.txt"), Xtest_df)
        
        
        #rinse and repeat for training data
        
        Xtrain_df <- read_fwf("train/X_train.txt", col_widths)
        
        Xtrain_df <- cbind("Activity" = readLines("train/y_train.txt"), Xtrain_df)
        
        Xtrain_df <- cbind("Subject" = readLines("train/subject_train.txt"), Xtrain_df)
       
        
        #now combine the data frames
        
        combined_df <- rbind(Xtest_df, Xtrain_df)
        
        
##2. Extract only the measurements on the mean and standard deviation for each measurement.     
        
        # we use grepl to return a list of booleans, based on the existance of a regular expresion with the list elemsts passed
        # in this case, we are passing the list of column labels, and the booleans are used to subset the combined data frame (combined_df)
        
        means_df <- combined_df[ grepl("[mM]ean", labels(combined_df)[[2]]) ]
        
        std_df <- combined_df[ grepl("std", labels(combined_df)[[2]]) ]
        
        extracted_df <- cbind(means_df, std_df)
        
        
##3. Use descriptive activity names to name the activities in the data set   

        # first, recombine the activity column 
        
        extracted_df <- cbind("Activity" = combined_df$"Activity", "Subject" = combined_df$"Subject",extracted_df)
        
        
        # create a data from of the activity lables
        
        activity_labels_df <- read.delim("activity_labels.txt", sep = " ", header = FALSE, col.names = c("Activity", "Activity_Label"))

        
        # now merge the dataframes along the "Activity" column. Note that doing so also arranges vales in ascending values of "Activity".
        
        labeled_extracted_df <- merge(activity_labels_df, extracted_df, by.y = "Activity", by.x = "Activity")
        
        
        # finally we remove the "Activity" column for being extraneous (keeping only "Activty_Label")
        
        labeled_extracted_df <- within(labeled_extracted_df, rm("Activity"))
        
        
        
##4. Appropriately labels the data set with descriptive variable names. 

        # Each feature name is descriptive, but contains an unnessesary leading number, to be removed.
        # The regular expression (first argument of gsub), finds numbers ([0123456789]) that occur one or more times (+) before a space (" ") 
        # and gsub replaces it with "" (no characters)
        
        old_feature_names <- colnames(labeled_extracted_df)
        
        tidy_feature_names <- gsub("[0123456789]+ ", "", old_feature_names )
        
        colnames(labeled_extracted_df) <- tidy_feature_names
        
        # let's save this tidy data set
        
        write.csv(labeled_extracted_df, "tidy_data_set.csv", sep = ",", row.names=FALSE)
        
        
##5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
        
        # Our method is to subset labeled_extracted_df on each subject, then each activity, 
        # then build a new dataframe with averages (means) of subsetted data 
        # there may be a much more elegant way to do this.
        # The results are attached to an initially empty dataframe   
        
        # begin by creating an empty dataframe of the appropriate width to rbind our results to, after every loop
        
        final_results_df <-as.data.frame( rep( list(double(0)), each = length(labeled_extracted_df)) )
        
        
        
        # now the heavy lifting...
        
        # get count of unique values in the "Subject" column and loop that many times
        
        for(i in 1:length(unique(labeled_extracted_df$"Subject"))){
             
             #of the vector of unique values in "Subject" select the i-th one of them
                
             subject_val <- unique(labeled_extracted_df$"Subject")[i]     
             
             #subset labeled_extracted_df, for all rows containing the specific unique.  
                
             subject_df <- labeled_extracted_df[ labeled_extracted_df$"Subject"==subject_val, ]
                
             
             #repeat this above process for unique values in "Activity_Label", subsetting the previously subset dataframe
            
             for(j in 1:length(unique(labeled_extracted_df$"Activity_Label"))) {
                     
                     activity_val <- unique(labeled_extracted_df$"Activity_Label")[j]
                     
                     sub_act_df <- subject_df[ subject_df$"Activity_Label"==activity_val,]
                     
                                                   
                     # This if test is proably unnessesary, but it makes sure we are not adding empty rows to the dataframe
                     # Empty rows would be a result of certain subjects not performing certain activities                               
                     
                     if(length(sub_act_df) > 0){
                             
                             #non-averaging columns are removed so the remaining columns may be easily averaged
                             
                             sub_act_df <- within(sub_act_df, rm("Activity_Label"))
                            
                             sub_act_df <- within(sub_act_df, rm("Subject"))
                     
                             
                             #create a dataframe of averages of columns (defult is tall, not wide)
                             
                             avgs_df <- data.frame(colMeans(sub_act_df))
                             
                             
                             #transpose so data is wide, not tall
                             
                             avgs_df <- t(avgs_df)
                             
                             
                             #remove residual row names
                             
                             rownames(avgs_df) <- NULL
                     
                             
                             #reattach "activity" and "subject" value rows
                            
                             avgs_df <- cbind("activity" = as.character(activity_val), "subject" = (subject_val), avgs_df)
                     
                             #attach averaged results to results dataframe
                            
                             final_results_df <- rbind(final_results_df, avgs_df)
                             
                     }
                     
             }  
                
                
        }
        
        #save results of analysis to .txt file
        
        write.table(final_results_df, "average_variables_per_subject_and_activity.txt", sep = ",", row.names=FALSE)
        
        
        #save features of analysis to .txt file
        
        write_lines(colnames(final_results_df, "analysis_features.txt")
