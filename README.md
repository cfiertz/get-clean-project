#README

*The script assumes that the Samsung data (i.e. the UCI HAR Dataset folder) is in your working directory, as stated in the project instructions:*
> The code should have a file run_analysis.R in the main directory that can be run *as long as the Samsung data is in your working directory.*

There is a single script used to create the final tidy data set. The script goes through a number of steps, which briefly explained in comments in the script itself, but which are explained in more detail below:
1. Read in the test and training sets of data (X_test.txt, y_test.txt, subject_test.txt, X_train.txt, y_train.txt, subject_train.txt) using read.table and storing them in six variables (testX, testY, testSub, trainX, trainY, trainSub)
2. Merge the test and training sets using rbind(), while still keeping the data, activity labels, and subject IDs separate, resulting in three separate variables.
	* Thus X is the merge of X_test and X_train, Y is the merge of y_test and y_train and Sub is the merge of subject_test and subject_train.
3. Descriptive variable names are then assigned as the labels of each of the variables in X, Y, and Sub.
	* First, features.txt is read in using read.table and assigned to the variable names.
	* The second column of names is assigned to names(X).
	* The resulting names are cleared up (i.e. the parentheses removed) using make.names()
	* The words "time" and "frequency" in the variable names are spelled out using gsub().
	* The single variable in Y is assigned the name "activity" and the single variable in Sub is assigned the name "subject".
4. The three files (X, Y, Sub) are merged to create a single data set (called data) using cbind(). The "activity" and "subject" variables are converted to factor variables using as.factor().
5. The mean and standard deviation for each measurement are identified and extracted.
	* I chose to include only those features that included "mean()" or "std()" (i.e. paired mean and std entries) and not those with mean in a different part of the feature name. 
	* Each group (means and standard deviations) was identified using grep(), and stored in a respective variables ("means" and "sds")
	* The variable "filters" was created that concatenated the numbers 1 and 2 (to refer to the "subject" and "activity" variables) with the "means" and "sds" variables.
	* The "filters" variable was then applied to the "data" data frame in order to extract only the relevant variables while also retaining the "subject" and "activity" variables.
6. The numeric labeling of activities was then replaced with the appropriate descriptive activity names.
	* Thus activity_labels.txt was read in using read.table() and stored in the variable "labels". 
	* The numeric levels of the factor variable data$activity were then replaced with the relevant labels from activity_labels.txt.
7. A new variable, "id", was created and replaced the "subject" and "activity" variables.
	* The "id" variable was created using interaction() on data$subject and data$activity.
	* The "subject" and "activity" variables were then removed from the "data" data frame.
	* cbind() was used to concatenate "id" and "data" to create a new "data" data frame.
8. The data frame was then melted and recast to produce the desired final tidy data set.
	* The reshape2 package was installed.
	* The data frame was then melted using melt() and using "id" as the id variable.
	* The molten data frame was then recast using dcast(), putting "id" in the rows and the other variables in the columns, and taking the mean of each variable.
9. The resulting data frame was then exported using write.table 
