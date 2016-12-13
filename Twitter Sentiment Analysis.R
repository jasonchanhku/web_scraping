#Sentiment Analysis

#Libraries Loaded
library(twitteR)
library(wordcloud)
library(RColorBrewer)
library(plyr)
library(ggplot2)
library(RSentiment)
library(httr)
library(SnowballC)
library(methods)
library(tm)
oauth_endpoints("twitter")

#authentication keys
api_key <- "jBfXavFfTuPwbnNL4lYUbmX6J"
api_secret <- "UYiIHAFJ1R5Lf3oUAxKUpoC0Oeu13k7dQ1mZ7rWKTPQXvSneih"
access_token <- "3009349382-JEVTBmCyK0VicLKYeTF35vzqosFgJSbNnIuAOCI"
access_token_secret <- "HEat3SPbho1TTWxNI7tHywHZE25WrcKeebPSnOXpf5v3a"

#twitter setup
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#get tweets from competitor
tweets <- userTimeline("SadQuotes", 100)

tweets <- twListToDF(tweets)$text 

tweets <- list(tweets)
#preprocessing of tweets 
tweets_cleaned <- lapply(tweets, FUN = function(x) {
  
  x = gsub('http\\S+\\s*', '', x) ## Remove URLs
  
  x = gsub('\\b+RT', '', x) ## Remove RT
  
  x = gsub('#\\S+', '', x) ## Remove Hashtags
  
  x = gsub('@\\S+', '', x) ## Remove Mentions
  
  x = gsub('[[:cntrl:]]', '', x) ## Remove Controls and special characters
  
  x = gsub("\\d", '', x) ## Remove Controls and special characters
  
  x = gsub('[[:punct:]]', '', x) ## Remove Punctuations
  
  x = gsub("^[[:space:]]*","",x) ## Remove leading whitespaces
  
  x = gsub("[[:space:]]*$","",x) ## Remove trailing whitespaces
  
  x = gsub(' +',' ',x) ## Remove extra whitespaces
  
  x = gsub("[[:digit:]]", "", x) ## remove digits
})


#corpus
tweets_corpus <- VCorpus(VectorSource(tweets_cleaned))

tweets_corpus <- tm_map(tweets_corpus, content_transformer(tolower))

#stop words removal
tweets_corpus <- tm_map(tweets_corpus, removeWords, stopwords("SMART"))

#stemming

#tweets_corpus <- tm_map(tweets_corpus, stemDocument)

#white spaces
tweets_corpus <- tm_map(tweets_corpus, stripWhitespace)

wordcloud(tweets_corpus, min.freq = 25, random.order = FALSE, colors = brewer.pal(5, "Dark2"))

#dtm
tweets_dtm <- DocumentTermMatrix(tweets_corpus)

#freq terms
findFreqTerms(tweets_dtm, 5)

#sentiment analysis
calculate_total_presence_sentiment(tweets_cleaned[[1]])

sentiment <- data.frame(calculate_total_presence_sentiment(tweets_cleaned[[1]]))[2, ]

colnames(sentiment) <- c("Sarcasm", "Neutral", "Negative", "Positive", "Very Negative", "Very Positive")

rownames(sentiment) <- NULL

sentiment