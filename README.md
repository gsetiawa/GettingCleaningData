GettingCleaningData
===================

This repository consists run_analysis.R script which combines the training and the test data sets from the Samsung accelerometers experiments and produces a tidy data sets from the combined sets.

The script contains 3 functions:

1. analyze function with one optional argument ie. the parent directory of the test and training folders. When the argument is not passed, the function will try to find test and training folders in the current working directory. The features (variables) is read from features.txt and will be used as the names of the columns. Since we are only interested in mean() and std() values of each variables. The feature list then is filtered to get indexes of the column names containing mean() or std().Each set from the test and training is passed to 'constructFilteredDataSet' function to get the test or training sets with mean() and std() variables only. See the description of construcFilteredDataSet function. The filtered training set is then combined with the test set and more descriptive names are assigned to the columns using FormatFeatureString function. It is then grouped by the subject and the activity, and the average of each variables per group is calculated. The column names are changed by appending 'Ave' as prefix. The result is written to the output file named 'AverageTidyCombinedSet.txt' before it is returned.

2. constructFilteredDataSet function load the set from a given directory. It takes 3 arguments: the parent directory of the data set, the category of the data set(training or test), and the wanted column indexes. 
It reads the subject_xx.txt file, y_xx.txt as activities and the observations from x_xx.txt. The observation is subset to the wanted column indexes.
The return value is the combination of subject, activity and observation as a data frame.

3. FormatfeatureString function takes a list of the feature list and replace the strings to give more descriptive labels.




