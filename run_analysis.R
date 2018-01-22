library(dplyr)

features=read.table("features.txt")
# Step 1: Merge the train and test data sets

testx=read.table("test/X_test.txt")
testy=read.table("test/y_test.txt")
testsubject=read.table("test/subject_test.txt")

trainx=read.table("train/X_train.txt")
trainy=read.table("train/y_train.txt")
trainsubject=read.table("train/subject_train.txt")

subjectdata=bind_rows(trainsubject,testsubject)
y_data=bind_rows(trainy,testy)
x_data=bind_rows(trainx,testx)

names(subjectdata) = c("Subject")
names(y_data) = c("Activity") 

features=read.table("features.txt")
names(x_data)=features$V2 #Step 4

mergeddata=cbind(subjectdata,y_data) %>% cbind(x_data)

#Step 2: Get required columns data only

required_cols=grep("mean\\(\\)|std\\(\\)",features[,2])
x_data_reqd=x_data[,required_cols]

# Step 3:Descriptive activity names
activitynames=read.table("activity_labels.txt")
mergeddata_final= cbind(subjectdata,y_data) %>% cbind(x_data_reqd)
mergeddata_final[,2]=activitynames[mergeddata_final[, 2], 2]

# Step 5: Creating another data set

outputdata = mergeddata_final %>% 
            group_by(Subject,Activity) %>% 
            summarize_all(funs(mean))

write.table(outputdata, "final_tidy_data.txt",row.name=FALSE, quote=FALSE)




