########## This R program reads the UCI HAR Dataset from the directory: "UCI_HAR_Dataset" and apply below steps on the raw data ######################
########### 1.Merges the training and the test sets to create one data set. ##########################################################################
########### 2.Extracts only the measurements on the mean and standard deviation for each measurement. ################################################
########### 3.Uses descriptive activity names to name the activities in the data set. ################################################################
########### 4.Appropriately labels the data set with descriptive variable names. #####################################################################
########### 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
######################################################################################################################################################


require(plyr)

# Read data files from Directory "UCI_HAR_Dataset"
raw_data_dir <- "\\RK_DOCS\\COURSERA\\Getting_and_Cleaning_Data\\project\\UCI_HAR_Dataset"
feature_file <- paste(raw_data_dir, "/features.txt", sep = "")
activity_labels_file <- paste(raw_data_dir, "/activity_labels.txt", sep = "")
x_train_file <- paste(raw_data_dir, "/train/X_train.txt", sep = "")
y_train_file <- paste(raw_data_dir, "/train/y_train.txt", sep = "")
subject_train_file <- paste(raw_data_dir, "/train/subject_train.txt", sep = "")
x_test_file  <- paste(raw_data_dir, "/test/X_test.txt", sep = "")
y_test_file  <- paste(raw_data_dir, "/test/y_test.txt", sep = "")
subject_test_file <- paste(raw_data_dir, "/test/subject_test.txt", sep = "")

# fetch raw data into variables
features <- read.table(feature_file, colClasses = c("character"))
activity_labels <- read.table(activity_labels_file, col.names = c("ActivityId", "Activity"))
x_train <- read.table(x_train_file)
y_train <- read.table(y_train_file)
subject_train <- read.table(subject_train_file)
x_test <- read.table(x_test_file)
y_test <- read.table(y_test_file)
subject_test <- read.table(subject_test_file)

##################################################################
# 1. Merge two data sets: "train" and "test" and create one data set called "merge_data".
##################################################################

# Binding x_train,y_train,x_test,y_test data
train_data <- cbind(cbind(x_train, subject_train), y_train)
test_data <- cbind(cbind(x_test, subject_test), y_test)
merge_data <- rbind(train_data, test_data)

# Labelling the columns
data_labels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(merge_data) <- data_labels

############################################################################################
# 2. Extract only the mean and standard deviation for each measurement.
############################################################################################

data_mean_std <- merge_data[,grepl("mean|std|Subject|ActivityId", names(merge_data))]

###########################################################################
# 3. Uses descriptive activity names to name the activities in the data set
###########################################################################

data_mean_std <- join(data_mean_std, activity_labels, by = "ActivityId", match = "first")
data_mean_std <- data_mean_std[,-1]

##############################################################
# 4. Appropriately labels the data set with descriptive names.
##############################################################

# 
names(data_mean_std) <- gsub('\\(|\\)',"",names(data_mean_std), perl = TRUE)

names(data_mean_std) <- make.names(names(data_mean_std))

names(data_mean_std) <- gsub('Acc',"Acceleration",names(data_mean_std))
names(data_mean_std) <- gsub('GyroJerk',"AngularAcceleration",names(data_mean_std))
names(data_mean_std) <- gsub('Gyro',"AngularSpeed",names(data_mean_std))
names(data_mean_std) <- gsub('Mag',"Magnitude",names(data_mean_std))
names(data_mean_std) <- gsub('^t',"TimeDomain.",names(data_mean_std))
names(data_mean_std) <- gsub('^f',"FrequencyDomain.",names(data_mean_std))
names(data_mean_std) <- gsub('\\.mean',".Mean",names(data_mean_std))
names(data_mean_std) <- gsub('\\.std',".StandardDeviation",names(data_mean_std))
names(data_mean_std) <- gsub('Freq\\.',"Frequency.",names(data_mean_std))
names(data_mean_std) <- gsub('Freq$',"Frequency",names(data_mean_std))

######################################################################################################################
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
######################################################################################################################

data_avg_by_act_sub = ddply(data_mean_std, c("Subject","Activity"), numcolwise(mean))
write.table(data_avg_by_act_sub, file = "tidy_data.txt")
