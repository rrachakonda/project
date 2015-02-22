
#####################  codebook.md ###########################################################################
The script  run_analysis.R performs the steps described below.
• Initially, we merged the data sets "test" and "train" having the same number of columns and referring to the same entities using rbind() function.
• next step is, fetch only those columns with the mean and standard deviation measures are taken from the whole dataset. After fetching these columns, they are given the correct labels, 
  taken from  features.txt file.
• we take the activity names and IDs from  activity_labels.txt  and they are substituted in the dataset.
• As a Last step, we generate a new dataset with all the average measures for each subject and activity type . The output file is called  tidy_data.txt .

Variables
•  x_train ,  y_train ,  x_test ,  y_test ,  subject_train  and  subject_test  contain the data from the downloaded files.
•  train_data ,  test_data  data sets are merged into merge_data data set .
•  column labels are added in data_labels 
•  data_mean_std contains mean data set values.
•  data_avg_by_act_sub contains mean data set my subject and activity types .

