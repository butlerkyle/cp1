## Note: assumes all files are in your working directory!

## read in all the files
xtest <- read.table("X_test.txt", header = F)
ytest <- read.table("y_test.txt", header = F)
xtrain <- read.table("X_train.txt", header = F)
ytrain <- read.table("y_train.txt", header = F)
features <- read.table("features.txt", header = F)
label <- read.table("activity_labels.txt", header = F)
subject_train <- read.table("subject_train.txt", header = F)
subject_test <- read.table("subject_test.txt", header = F)


## rbind the x data and name the columns
featuresnames <- features$V2
xfull <- rbind(xtest, xtrain)
colnames(xfull) <- featuresnames

##add subject
subjects <- rbind(subject_test, subject_train)
xfull <- cbind(subjects, xfull)

## bind and name the activities
yfull <- rbind(ytest, ytrain)
colnames(yfull) <- "ActivityNum"
colnames(label) <- c("ActivityNum", "ActivityName")

library(plyr)
ymerged <- join(yfull, label, by = "ActivityNum")
finaldata <- cbind(ymerged, xfull)

## pull out just the means and stdevs
means <- grep("mean", names(finaldata))
stds <- grep("std", names(finaldata))
keepcolumns <- c(2, 3, means, stds)
finalsubset <- finaldata[,keepcolumns]
colnames(finalsubset)[2] <- "Subject"

## make the second tidy data set 
finaltable <- ddply(finalsubset, .(ActivityName, Subject), numcolwise(mean))


## write a file 
write.table(finaltable, file = "finaltable.txt", sep = ",", row.names = F)

