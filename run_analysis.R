run_analysis = function(){

	features <- extracting_data_from_features()
	
	##getting test data
	subject_test = getData("../UCI HAR Dataset/test/subject_test.txt")
	X_test       = getData("../UCI HAR Dataset/test/X_test.txt")
	y_test       = getData("../UCI HAR Dataset/test/y_test.txt")
	
	##getting training data
	subject_train = getData("../UCI HAR Dataset/train/subject_train.txt")
	X_train       = getData("../UCI HAR Dataset/train/X_train.txt")
	y_train       = getData("../UCI HAR Dataset/train/y_train.txt")
	
	##merging test and training data
	subject_merged = c(subject_test, subject_train)
	X_merged       = c(X_test, X_train)
	y_merged       = c(y_test, y_train)
	
	##To conserve memory, remove test and train data 
	rm(subject_test)
	rm(X_test)
	rm(y_test)
	rm(subject_train)
	rm(X_train)
	rm(y_train)
	
	##create tinyData1.csv
	tinyData1 = list()
	maxlen <- length(subject_merged)
	for (ix in 1:maxlen){
		tinyData1[[ix]] = extract_data_from_given_string(
			subject  = as.numeric(subject_merged[ix]),
			activity = as.numeric(y_merged[ix]),
			strData  = X_merged[ix],
			features = features 
		)
	}
	
	write_data_to_csv(filename="tinyData1.csv", tinyData=tinyData1)
	
	##create tinyData2.csv
	maxlen <- length(tinyData1)
	tinyData2 = list()
	for (ix in 1:maxlen){
		currTinyData1 <- tinyData1[[ix]]
		key <- paste(
			currTinyData1["subject"], 
			currTinyData1["activity"], 
			collapse=","
		)
		##Add currTinyData1 if key is not found (on first encouter)
		##  - also add a count field and set it to 1.
		if (!key %in% names(tinyData2)){
			tinyData2[[key]] = c(currTinyData1, count=1)
		} else {
		##For subsequent encouter of the same key
		## Sum up all the fields (except for subject and activity)
		##  and increment count
			tinyData2[[key]] <- tinyData2[[key]] + c(currTinyData1, count=1)
			tinyData2[[key]]["subject"]  <- currTinyData1["subject"]
			tinyData2[[key]]["activity"] <- currTinyData1["activity"] 
		}	
	}
	
	##Computer average value in tinyData2
	maxlen = length(tinyData2)
	for (ix in 1:maxlen){
		currTinyData2   <- tinyData2[[ix]]
		currCount       <- currTinyData2["count"]
		currSubject     <- currTinyData2["subject"]
		currActivity    <- currTinyData2["activity"]
		currTinyData2 <- currTinyData2 / currCount
		currTinyData2["subject"]  <- currSubject
		currTinyData2["activity"] <- currActivity 
		## removing count element
		tinyData2[[ix]] <- currTinyData2[names(currTinyData2 != "count")]
	}
	write_data_to_csv(filename="tinyData2.csv", tinyData=tinyData2)

	##To conserve memory, remove merged and tiny data
	rm(subject_merged)
	rm(X_merged)
	rm(y_merged)
	rm(tinyData1)
	rm(tinyData2)
}

write_data_to_csv = function(filename, tinyData) {

	##check if filename exists
	if (file.exists(filename)){
		file.remove(filename)
	}

	colNames = names(tinyData[[1]])
	output   = paste(colNames, collapse=",")
	write(output, filename, append=TRUE)
	
	for (data in tinyData){
		output = paste(data, collapse=",")
		write(output, filename, append=TRUE)
	}
}

## purpose: read given filePath and returns all lines in a string vector.
getData = function(filePath) {
	conn = file(filePath)
	result = readLines(conn)
	close(conn)	

	return(result)
}

## returns: a list with all the column names
extract_data_from_given_string = function(strData, subject, activity, features = list()){
	
	## extracting data by subsetting vector using features$colNum
	result <- unlist(strsplit(strData, "\\s+")); #split str by white space
	result <- as.numeric(result)
	result <- result[!is.na(result)]
	result <- result[features$colNum]
	
	## prepend subject and activity to result vector
	result <- c(subject, activity, result)
	##result <- as.list(result)

	## prepend "subject" and "activity" to features$colNames
	colNames <- c("subject","activity", features$colNames)
	names(result) <- colNames

	return(result)
}



## returns: a list with list$colNames and list$colNum
extracting_data_from_features = function(){
	
	features <- getData("../UCI HAR Dataset/features.txt")	

	## find all rows with the word "mean" or "std"
	x <- grep("mean|std", features)
	features <- features[x]
	
	## extracting colNums and colNames
	colNums  <- NULL
	colNames <- NULL
	for (feature in features){
		x <- unlist(strsplit(feature, "\\s+"))
		colNums  <- c(colNums, as.numeric(x[1]))
		
		y <- x[2]
		y <- gsub("[(|)]", "", y) ## remove ( and ) from names
		y <- gsub("-", "_", y)    ## replace - with _
		colNames <- c(colNames, y)
	}

	return(list(colNums = colNums, colNames = colNames))
}