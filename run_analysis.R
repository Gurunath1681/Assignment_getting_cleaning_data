## Wk4 peer review assignment
library(data.table)
library(dplyr)

setwd("C:/Users/212396399/Desktop/R_practice/UCI_HAR_Dataset")

# Importing training and test data 
names_data<-read.table('./features.txt',header=FALSE); names_data<-as.character(names_data[,2]); 
X_data_train<-fread("./train/X_train.txt",col.names = names_data)
X_data_test<-fread("./test/X_test.txt",col.names = names_data)
subject_ID_test <- fread('./test/subject_test.txt',col.names = "sub_ID")
subject_ID_train <- fread('./train/subject_train.txt',col.names = "sub_ID")
subject_ID<-rbind(subject_ID_test,subject_ID_train)
activity_ID_test <- fread('./test/y_test.txt',col.names="act_ID")
activity_ID_train <- fread('./train/y_train.txt',col.names="act_ID")
activity_ID<-rbind(activity_ID_test,activity_ID_train)
activity <- read.table('./activity_labels.txt',header=FALSE); 
colnames(activity)=c("act_ID","activity")

# Merging training and testing data
X_data<-rbind(X_data_train,X_data_test)
data<-cbind(activity_ID,subject_ID,X_data)
mean_names<-grep("mean",names(data),value=TRUE)
std_names<-grep("std",names(data),value=TRUE)
all_names<-c("sub_ID","act_ID",mean_names,std_names)
data<-data[, ..all_names] #.. before all_subset_cols is required to read the column names

# Use descriptive activity names to name the activities in the data
data<-merge(data,activity,by='act_ID',all=TRUE)
data<-data[,c(82,2:81)]

# Descriptive column names 
colnom<-names(data)
for (i in 1:ncol(data)) 
{
  colnom[i] <- gsub("\\()","",colnom[i])
  colnom[i] <- gsub("-X","X",colnom[i],ignore.case=T);
  colnom[i] <- gsub("-Y","Y",colnom[i],ignore.case=T)
  colnom[i] <- gsub("-Z","Z",colnom[i],ignore.case=T)
  colnom[i] <- gsub("-std","Stdev",colnom[i])
  colnom[i] <- gsub("-mean","Mean",colnom[i])
  colnom[i] <- gsub("^(t)","Time",colnom[i])
  colnom[i] <- gsub("^(f)","Freq",colnom[i])
  colnom[i] <- gsub("AccMag","AccMagnitude",colnom[i],ignore.case=T)
  colnom[i] <- gsub("(bodyaccjerkmag)","BodyAccJerkMagnitude",colnom[i],ignore.case=T)
  colnom[i] <- gsub("JerkMag","JerkMagnitude",colnom[i],ignore.case=T)
  colnom[i] <- gsub("GyroMag","GyroMagnitude",colnom[i],ignore.case=T)
}
colnames(data)<-colnom

# Calculating mean of each variable for each activity/subject 
mean_data<-aggregate(data[,3:ncol(data)],by=list(activity=data$activity,sub_ID=data$sub_ID),mean)

# Export mean_data 
write.table(mean_data, './Mean_data.txt',row.names=FALSE,sep='\t')
