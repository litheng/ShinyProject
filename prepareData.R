# Load required packages
library(tidyr)
require(gdata)

# Download data and load into dataframe
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "http://beta.data.gov.sg/dataset/a984569c-f0d4-4e01-badc-0055f1405172/resource/83063203-ff81-4764-a9dc-c4e209921fe7/download/1901010000000004907SBYCOUNTRY.csv"
get.df <- read.csv(fileUrl, stringsAsFactors=FALSE)

# Trim leading and trailing blank spaces
trim.df <- trim(get.df)

# Exclude records tie to Asean region as the individual countries are already in the dataset
sub.df <- trim.df[!(trim.df$country %in% c("Asean")), ]

# Split month column into two separate columns
sub.df <- separate(data=sub.df, col=month, into = c("year", "month"))

# Rename month number with month name
sub.df$month <- month.abb[as.numeric(sub.df$month)]

# Rename columns
colnames(sub.df) <- c("Year", "Month", "Region", "Country", "Visitors")

# Write into output file
write.csv(sub.df, file="data/visitors.csv", row.names=F)