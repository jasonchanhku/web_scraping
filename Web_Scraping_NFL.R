#Web scraping a table
library(rvest)
library(tidyr)
library(stringr)

#read html
nfl_url <- read_html("http://www.espn.com/nfl/superbowl/history/winners")

#get table
nfl_table <- nfl_url %>% html_nodes("table") 
nfl_table <- html_table(nfl_table)[[1]]

#remove first two rows
nfl_table <- nfl_table[-c(1:2), ]
names(nfl_table) <- c("number", "date", "site", "result")

#change to normal numbers
nfl_table$number <- 1:50

#change to date format
nfl_table$date <- as.Date(nfl_table$date, "%B. %d, %Y")

#separate results into winner and loser
nfl_table <- separate(nfl_table, result, c("winner", "loser"), sep = ", ", remove = TRUE )

#separate their scores
#regex for a space and more than 1 digits at end of line
pattern <- " \\d+$"
nfl_table$winner_score <- as.numeric(str_extract(nfl_table$winner, pattern))
nfl_table$loser_score <- as.numeric(str_extract(nfl_table$loser, pattern))

#take out the digits
nfl_table$winner <- gsub(pattern, "", nfl_table$winner)
nfl_table$loser <- gsub(pattern, "", nfl_table$loser)

#write as csv
write.csv(nfl_table, file = "past_winners.csv", row.names = FALSE)


