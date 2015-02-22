
# Step 1:
# Input data from all of the notepad files
test.labels <- read.table("test/y_test.txt", col.names="label")
test.subjects <- read.table("test/subject_test.txt", col.names="subject")
test.data <- read.table("test/X_test.txt")
train.labels <- read.table("train/y_train.txt", col.names="label")
train.subjects <- read.table("train/subject_train.txt", col.names="subject")
train.data <- read.table("train/X_train.txt")

# Step 2:
# Combine it in the format of: subjects, labels, test data
data <- rbind(cbind(test.subjects, test.labels, test.data),
              cbind(train.subjects, train.labels, train.data))

# Step 3:
# Read the features
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# Step 4:
# Select only the means and standard deviations from data
# Increment by 2 because data has subjects and labels in the beginning
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]

# Step 5:
# Read the labels (activities)
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
data.mean.std$label <- labels[data.mean.std$label, 2]

# step 6:
# First make a list of the current column names and feature names
good.colnames <- c("subject", "label", features.mean.std$V2)

# Step 7:
# Tidy list:
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))

colnames(data.mean.std) <- good.colnames

# step 8:
# Find the mean for each combination of subject and label
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)

# Step 9: 
# Create the file, write the data for course upload
write.table(format(aggr.data, scientific=T), "tidydata.txt",
            row.names=F, col.names=F, quote=2)