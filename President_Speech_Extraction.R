#Scraping Hyperlinks
setwd("/Users/jasonchan/fidelity/rsconnect/webscraping/")

#Libraries Used
library(rvest)
library(dplyr)
#read html
main.page <- read_html(x = "http://www.presidency.ucsb.edu/sou.php")

#get urls
urls <- main.page %>% html_nodes(".ver12 a") %>% html_attr("href")

#get text year of ulrs
links <- main.page %>% html_nodes(".ver12 a") %>% html_text()

#create a data.frame
sotu <- data.frame(links = links, urls = urls, stringsAsFactors = FALSE)

#subset links from 1947 - 2015, Truman to Obama
sotu_sub <- subset(sotu, links %in% 1947:2015)
#sotu_sub$links <- as.numeric(as.character(sotu_sub$links))
#arrange(sotu_sub, links)

#years of republicans in power
republicans <- c(1953:1960, 1970:1974, 1974:1977, 1981:1988, 1989:1992, 2001:2008)

#to extract the speech from each url, a LOOP must be created to loop through every 
#url 
for (i in 1:nrow(sotu_sub)){
  text <- read_html(sotu_sub$urls[i]) %>% html_nodes("p") %>% html_text()
  
  party <- ifelse(sotu_sub$links[i] %in% republicans, "republican", "democrat")
  
  filename <- paste0("texts/", party, "-", sotu_sub$links[i], ".txt")
  
  sink(file = filename)   
  cat(text)  
  sink()
}

