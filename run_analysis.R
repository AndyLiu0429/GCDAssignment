## the script is used for creating a tidy dataset based on 
## data collected from the accelerometers from the Samsung Galaxy S smartphone
library(reshape2)
library(plyr)

root_dir <- "UCI HAR Dataset"
## import label and feature
features <- read.table(paste(root_dir,"features.txt",sep="/"), stringsAsFactors=F)
activity_labels <- read.table(paste(root_dir,"activity_labels.txt",sep="/"),col.names=c("labelid","label"))
## important features
important_features <- grep("\\-mean\\(|\\-std\\(",features[,2])

##import training data set
train_dir <- paste(root_dir,"train",sep="/")
train_subject <- read.table(paste(train_dir,"subject_train.txt",sep="/"),col.names = "subject")
train_data <- read.table(paste(train_dir,"X_train.txt",sep="/"),col.names = features[,2],check.names = F)
train_data <- train_data[,important_features]
train_labels <- read.table(paste(train_dir, "y_train.txt", sep="/"),col.names = "labelid")
train <- cbind(train_subject,train_labels,train_data)

## import test data set
test_dir <- paste(root_dir, "test", sep="/")
test_subject <- read.table(paste(test_dir,"subject_test.txt",sep="/"),col.names = "subject")
test_data <- read.table(paste(test_dir,"X_test.txt",sep="/"),col.names=features[,2],check.names = F)
test_data <- test_data[,important_features]
test_labels <- read.table(paste(test_dir,"y_test.txt",sep="/"),col.names="labelid")
test <- cbind(test_subject,test_labels,test_data)

## merge and reshape 
all_data <- rbind(train,test)
df <- merge(activity_labels,all_data, by="labelid")
df <- df[,-1]
df_molten <- melt(df,id=c("label","subject"))

## create tidy data set and write to the disk
tidy <- dcast(df_molten, label + subject ~ variable, mean)
write.csv(tidy, file = "tidy.txt",row.names = FALSE)
