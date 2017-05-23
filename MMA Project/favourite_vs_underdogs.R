#Scraping underdog and favourite (main training data)

#libraries used
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)
library(data.table)
library(dtplyr)

#url and links set up for loop
url <- read_html("http://www.betmma.tips/mma_betting_favorites_vs_underdogs.php?Org=1")
links <- url %>% html_nodes("td td td td a") %>% html_attr("href")
links <- paste0("http://www.betmma.tips/", links)  #complete the hyperlinks

#initialization
event <- c()
fighter1 <- c()
fighter2 <- c()
fighter1_odds <- c()
fighter2_odds <- c()
win <- c()

for (i in 1:length(links)){
  
  sub_link <- read_html(links[i])
  
  #fighter1
  fighter1_t <- sub_link %>% html_nodes("a+ a:nth-child(4)") %>% html_text()
  fighter1_t <- fighter1_t[-grep("MMA", fighter1_t)]
  fighter1_t <- fighter1_t[fighter1_t != " vs "]
  fighter1 <- c(fighter1, fighter1_t)
  
  #event
  event_t <- sub_link %>% html_nodes("td h1") %>% html_text()
  event <- c(event, replicate(length(fighter1_t),event_t))
  
  #fighter2
  fighter2_t <- sub_link %>% html_nodes("a+ a:nth-child(6)") %>% html_text()
  fighter2_t <- fighter2_t[-grep("MMA", fighter2_t)]
  fighter2_t <- fighter2_t[fighter2_t != ""]
  fighter2 <- c(fighter2, fighter2_t)
  
  #label for both
  #td td td tr~ tr+ tr td
  label <- c()
  label_t <- sub_link %>% html_nodes("td td td td tr~ tr+ tr td") %>% html_text()
  label_cleansed <- gsub("@", "",trimws(label_t))

  #win
  win_t <- sub_link %>% html_nodes("td td td td br+ a") %>% html_text()
  win <- c(win, win_t)

  #fighter1 odds
  fighter1_odds_t <- label_cleansed[c(TRUE, FALSE)]
  fighter1_odds <- c(fighter1_odds, fighter1_odds_t)

  #fighter2 odds
  fighter2_odds_t <- label_cleansed[c(FALSE, TRUE)]
  fighter2_odds <- c(fighter2_odds, fighter2_odds_t)
  
}  
a <- data.frame(Events = event, Fighter1 = fighter1)
write.csv(a, "part1.csv", row.names = FALSE)
write.csv(fighter2, "part2.csv", row.names = FALSE)
write.csv(win, "part3.csv", row.names = FALSE)
write.csv(data.frame(fighter1_odds,fighter2_odds), "part4.csv", row.names = FALSE)
