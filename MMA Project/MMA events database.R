#Extracting All Fight Cards in UFC history

#libraries used
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)
library(data.table)
library(dtplyr)

#extracting all the URLs
webpage <- read_html("http://www.fightmetric.com/statistics/events/completed?page=all")
urls <- webpage %>% html_nodes(".b-link_style_black") %>% html_attr("href")

#initialization
date <- c()
event <- c()
city <- c()
state <- c()
country <- c()
winner <- c()
loser <- c()
wc <- c()
method <- c()
round <- c()

for(i in 1:length(urls)){
url_link <- read_html(urls[i])

#winner 
winner_t <- url_link %>% html_nodes(".b-fight-details__table-text:nth-child(1) .b-link_style_black") %>% html_text()
winner <- c(winner, trimws(winner_t))

#loser
loser_t <- url_link %>% html_nodes(".b-fight-details__table-text+ .b-fight-details__table-text .b-link_style_black") %>% html_text()
loser <- c(loser, trimws(loser_t))

#weightclass
wc_t <- url_link %>% html_nodes(".l-page_align_left:nth-child(7) .b-fight-details__table-text") %>% html_text()
wc <- c(wc, trimws(wc_t))

#method
method_t <- url_link %>% html_nodes(".l-page_align_left+ .l-page_align_left .b-fight-details__table-text:nth-child(1)") %>% html_text()
method <- c(method, trimws(method_t))

#round 
round_t <- url_link %>% html_nodes(".b-fight-details__table-col:nth-child(9) .b-fight-details__table-text") %>% html_text()
round <- c(round, as.integer(trimws(round_t)))

#date
date_t <- url_link %>% html_nodes(".b-list__box-list-item:nth-child(1)") %>% html_text()
date_t <- trimws(strsplit(trimws(date_t), ":")[[1]][2])
date_t <- as.character(as.Date(date_t, format = "%B %d, %Y"))
date_t <- replicate(length(winner_t), date_t)
date <- c(date, date_t)    

#event
event_t <- url_link %>% html_nodes(".b-content__title-highlight") %>% html_text()
event_t <- trimws(event_t)
event_t <- replicate(length(winner_t), event_t)
event <- c(event, event_t)

#Location
location_t <- url_link %>% html_nodes(".b-list__box-list-item:nth-child(2)") %>% html_text()
location_t <- trimws(strsplit(trimws(location_t), ":")[[1]][2])
location_t <- strsplit(location_t, ",")

city_t <- trimws(location_t[[1]][1])
city_t <- replicate(length(winner_t), city_t)
city <- c(city, city_t)

state_t <- trimws(location_t[[1]][2])
state_t <- replicate(length(winner_t), state_t)
state <- c(state, state_t)

country_t <- trimws(location_t[[1]][3])
country_t <- replicate(length(winner_t), ifelse(is.na(country_t), replicate(length(winner_t), state_t),replicate(length(winner_t), country_t)))
country <- c(country, country_t)


}

events_db <- data.frame(Date = date, Event = event, City = city, State = state, Country = country, Winner = winner, Loser = loser, WeightClass = wc, Round = round, Method = method)

View(events_db)

#reformat data frame
events_db$Date <- as.Date(events_db$Date)
events_db$Event <- as.character(events_db$Event)
events_db$City <- as.character(events_db$City)
events_db$State <- as.character(events_db$State)
events_db$Country <- as.character(events_db$Country)
events_db$Winner <- as.character(events_db$Winner)
events_db$Loser <- as.character(events_db$Loser)
events_db$WeightClass <- as.character(events_db$WeightClass)
events_db$Round <- as.integer(events_db$Round)
events_db$Method <- as.character(events_db$Method)



#scrape winning and losers from fight metrics
#scrape underdogs and favourite from bestfight odds
