#Web Scraping Example
#Libraries used
library(rvest)
library(plotly)

#get url 
imdb <- read_html("http://www.imdb.com/movies-in-theaters/")

#get the CSS using selector gadget to convert html nodes to text
#titles
title <- imdb %>% html_nodes("h4 a") %>% html_text()
genre <- imdb %>% html_nodes("time+ span") %>% html_text()
time <- imdb %>% html_nodes("time") %>% html_text()

#turn it into a data.frame
imdb_table <- data.frame(title, genre, time)
#note that the time column is still not in the format we want it to be
#use gsub
imdb_table$time <- gsub("min", "", imdb_table$time)
#convert to numeric
imdb_table$time <- as.numeric(imdb_table$time)

#filter movie which is not documentary and less than 100 mins
imdb_table[imdb_table$genre != "Documentary" & imdb_table$time < 100 ,]

#group movie by genre using aggregate
genre_time <- aggregate(time ~ genre, data = imdb_table, FUN = mean)

#plot using plot_ly
plot_ly(data = genre_time, x = ~genre, y=~time, type = "bar")

#list of top movies, convert html nodes to html text
top <- read_html("http://www.imdb.com/chart/top?ref_=nv_mv_250_6")

#get data.frame
pics<- top %>% html_nodes("img") %>% html_attr("src")
top_title <- top %>% html_nodes(".titleColumn a") %>% html_text()
top_year <- top %>% html_nodes(".secondaryInfo") %>% html_text()
top_rating <- top %>% html_nodes("strong") %>% html_text()
top_rating <- top_rating[-1]

#data.frame
top_table <- data.frame(top_title, top_year, top_rating)

#convert rating to numeric 
top_table$top_rating <- as.numeric(as.character(top_table$top_rating))

#convert years to numeric
top_table$top_year <- gsub("\\(", "", top_table$top_year)
top_table$top_year <- gsub("\\)", "", top_table$top_year)
top_table$top_year <- as.numeric(top_table$top_year)

#proper col names
colnames(top_table) <- c("title", "year", "rating")

#Aggregate by mean of ratings
top_mean <- aggregate(rating ~ year, data = top_table, FUN = mean)

#Year with the highest mean rating
top_mean[max(top_mean$rating),]
