# Load data
df <- read.csv("data/visitors.csv", stringsAsFactors=FALSE)
years <- sort(unique(df$Year))
regions <- sort(unique(df$Region))