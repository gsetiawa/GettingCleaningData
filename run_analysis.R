analyze <- function(parentdir = "UCI HAR Dataset") {
    # tidy and shape the data
    # parentdir is the UCI HAR Dataset folder
    
    # set activity list
    activityList <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
                      "SITTING", "STANDING", "LAYING")
    
    # featureList as variables (we are interested in only std and mean)
    featureTable <- read.table(paste(c(parentdir, "\\features.txt"), 
                                     collapse=''), 
                               as.is = TRUE)
    featureTable <- featureTable[grep("mean\\(\\)|std\\(\\)", 
                                      featureTable[,2])
                                 , ]
    
    # get the unlabeled constructed data set per category(train/test)
    # with variables filtered only on std and mean
    trainingSet <- constructFilteredDataSet(parentdir, "train", featureTable[,1])
    testSet <- constructFilteredDataSet(parentdir, "test", featureTable[,1])
    
    # merge trainingSet and testSet
    # column1: subject
    # column2: activity
    # rest: observation
    combinedSet <- rbind(trainingSet, testSet)
    
    # use level in the activities in the dataset
    combinedSet[, 2] <- as.factor(combinedSet[,2])
    levels(combinedSet[, 2]) <- c("WALKING", "WALKING_UPSTAIRS", 
                                  "WALKING_DOWNSTAIRS", "SITTING", "STANDING", 
                                  "LAYING")

    # labels the variables
    descFeatures <- FormatFeatureString(featureTable[, 2])
    labelList <- c("Subject", "Activity", descFeatures)
    colnames(combinedSet) <- labelList
    
    # Grouping the data by Subject-Activity and calculate the mean of each
    # observation
    groups <- split(combinedSet, list(combinedSet$Subject, combinedSet$Activity))
    
    averageResultSet <- sapply(groups, function(x) sapply(x[, 3:68], mean))
    averageResultSet <- data.frame(t(averageResultSet))
    
    # rename - append Ave on variable names
    names(averageResultSet) <- paste("Ave", names(averageResultSet), sep="")
    
    # split rename the row names as columns 
    library("plyr")
    groupSplit <- strsplit(rownames(averageResultSet), '.', fixed=TRUE)
    groupColumns <- ldply(groupSplit)
    names(groupColumns) <- c("Subject", "Activity")
    
    averageResultSet <- cbind(groupColumns, averageResultSet)
    rownames(averageResultSet) <- NULL
    
    # write to file
    if (!file.exists("./AverageTidyCombinedSet.txt")) {
        file.create("./AverageTidyCombinedSet.txt")
    }
    write.table(averageResultSet, file = "./AverageTidyCombinedSet.txt", 
                row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE )
    
    print("The tidy combined data set is saved in AverageTidyCombinedSet.txt")
    
    # return tidy average data set
    averageResultSet
}


constructFilteredDataSet <- function(parentDir, category, columnIndexes)
{    
    # combine the y_category.txt, subject_category.txt, and x_category.txt 
    # into one table
    subjectFilePath <- paste(c(parentDir, "\\", category, "\\subject_", 
                               category, ".txt"), collapse='')
    activityFilePath <- paste(c(parentDir, "\\", category, "\\y_", 
                                category, ".txt"), collapse='')
    observationFilePath <- paste(c(parentDir, "\\", category, "\\x_", 
                                   category, ".txt"), collapse='')

    subjectIdSet <- read.table(subjectFilePath)
    
    activitySet <- read.table(activityFilePath)
    
    # filter and just use the wanted column indexes
    observationSet <- read.table(observationFilePath)
    observationSet <- observationSet[, columnIndexes]

    cbind(subjectIdSet, activitySet, observationSet)
}

FormatFeatureString <- function(featureList)
{
    # replace _mean() with Mean
    featureList <- gsub("-mean\\(\\)", "Mean", featureList)
    
    # replace _std() with SD
    featureList <- gsub("-std\\(\\)", "SD", featureList)
    
    # replace Acc with Accelerometer
    featureList <- gsub("Acc", "Accelerometer", featureList)
    
    # replace Gyro with Gyroscope
    featureList <- gsub("Gyro", "Gyroscope", featureList)
    
    # replace Mag with Magnitude
    featureList <- gsub("Mag", "Magnitude", featureList)
    
    # replace tBody with TimeBody
    featureList <- gsub("tBody", "TimeBody", featureList)
    
    # replace fBodyBody with FreqBody
    featureList <- gsub("fBodyBody", "FreqBody", featureList)
    
    # replace fBody with FreqBody
    featureList <- gsub("fBody", "FreqBody", featureList)
    
    # replace tGravity with TimeGravity
    featureList <- gsub("tGravity", "TimeGravity", featureList)
    
    featureList
}