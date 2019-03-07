# week4_datascience

## Analysis description
The analysis is done in R and can be found in the file run_analysis.R
The analysis performs the following actions
1. Read feature names from text file, renames them to understandble feature names
2. Read activity names from text file into a dataframe called actiity_names
3. Defines training and testing vectors
4. Defines training and testing dataframes
5. Adjusts activity names by joining the train/test dataset with the activity_namse dataframe
6. Merges the training and test dataset by rowbinding both dataframes
7. Creates a tidy dataframe where each row is the mean of all variables for each activity
8. Writes the tidy dataframe
