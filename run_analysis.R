library(dplyr)

#Download and unzip the original data from the website
zip_name <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"
if (!file.exists(zip_name))
{
  original_file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(original_file, zip_name, method="curl")
}
if (!file.exists("UCI HAR Dataset"))
{
  unzip(zip_name)
}

#Load files and change names of variables
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",header = FALSE,sep = " ")
names(activity_labels) <- c("class","activity")

features <- read.table("UCI HAR Dataset/features.txt",header = FALSE,sep = " ")
names(features) <- c("id","feature")


#Create variable to get desired features (mean and std)
mean_std <- features[grep(".*mean.*|.*std.*",features$feature),]

#Read x_test file, extract only std and mean features and change the variable names
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",header = FALSE,sep = "")
x_test <- x_test[,mean_std[,1]]
names(x_test) <- mean_std[,2]
names(x_test) <- gsub("-mean","Mean",names(x_test))
names(x_test) <- gsub("-std","Std",names(x_test))
names(x_test) <- gsub("[()-]","",names(x_test))

#Read y_test file and change the variable names
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",header = FALSE,sep = "")
names(y_test) <- "id_activity"

#Read subject_test file and change the variable names
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE,sep = "")
names(subject_test) <- "subject"

#Bind in one test file
test <- cbind(subject_test, activity = y_test[,1], x_test)

#Read x_train file, extract only std and mean features and change the variable names
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",header = FALSE,sep = "")
x_train <- x_train[,mean_std[,1]]
names(x_train) <- mean_std[,2]
names(x_train) <- mean_std[,2]
names(x_train) <- gsub("-mean","Mean",names(x_train))
names(x_train) <- gsub("-std","Std",names(x_train))
names(x_train) <- gsub("[()-]","",names(x_train))

#Read y_train file and change the variable names
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",header = FALSE,sep = "")
names(y_train) <- "id_activity"

#Read subject_train file and change the variable names
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE,sep = "")
names(subject_train) <- "subject"

#Bind in one train file
train <- cbind(subject_train, activity = y_train[,1], x_train)

#Merge both files (test and train) into one large dataset
large_set <- rbind(train,test)

#Replace activity ids by names
large_set$activity <- factor(large_set$activity, levels = activity_labels[,1], labels = activity_labels[,2])

#Group by subject and activity
grouped <- group_by(large_set,subject,activity)

#Summarize to calculate mean
mean_set <- summarize_each(grouped,funs(mean))

#Write final table with the mean value of all the variables
write.table(mean_set,"tidy_data.txt",row.name = FALSE)