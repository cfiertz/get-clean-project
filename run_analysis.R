# read in the test and train sets of data 

testX <- read.table("./UCI HAR Dataset/test/X_test.txt")
testY <- read.table("./UCI HAR Dataset/test/y_test.txt")
testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt")


# merge the test and training sets into three files: data, activity labels, and subject identifiers

X <- rbind(testX, trainX)
Y <- rbind(testY, trainY)
Sub <- rbind(testSub, trainSub)


# give descriptive variable names as the labels of the variables in each of the three files 

names <- read.table("./UCI HAR Dataset/features.txt")
names(X) <- names[,2]
names(X) <- make.names(names(X), unique=TRUE)
names(X) <- gsub(pattern="tB", replacement="timeB", x=names(X))
names(X) <- gsub(pattern="tG", replacement="timeG", x=names(X))
names(X) <- gsub(pattern="fB", replacement="frequencyB", x=names(X))
names(Y) <- "activity"
names(Sub) <- "subject"


# merge the three files to create a single data set and make the subject and activity variables factor variables 

data <- cbind(Sub, Y, X)
data$subject <- as.factor(data$subject)
data$activity <- as.factor(data$activity)


# identify and extract only the mean and standard deviation for each measurement

means <- grep("mean.", names(data), fixed=TRUE)
sds <- grep("std.", names(data))
filters <- c(1, 2, means, sds)
data <- data[,filters]


# apply descriptive activity names to the activities in the data set 

labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
data$activity <- factor(data$activity, levels=c(1, 2, 3, 4, 5, 6), labels = c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying"))


# create a new variable called id that combines the subject id and the activity. replace the subject and activity variables with the new id variable 

id <- interaction(data$subject, data$activity, sep="-")
data <- data[ -c(1:2) ]
data <- cbind(id, data)


# melt the data set and cast it into a new form which contains the average of each variable for each activity and each subject 

library(reshape2)
meltdata <- melt(data, id.vars="id")
castdata <- dcast(meltdata, id ~ variable, mean)


# export the resulting data set as a txt file

write.table(castdata, file="./data.txt", row.names=FALSE)