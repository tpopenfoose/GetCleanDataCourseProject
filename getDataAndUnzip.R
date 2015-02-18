# create data subfolder
if(!file.exists("./data")) { dir.create("./data") }

# download the data
setInternet2(use = TRUE)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/Dataset.zip", mode="wb")

# see what files are in the zip file
unzip("./data/Dataset.zip", list=TRUE)

# unzip the datasets
unzip("./data/Dataset.zip", exdir="./data", setTimes=TRUE)

# see what is there
list.files("./data", recursive=TRUE)
