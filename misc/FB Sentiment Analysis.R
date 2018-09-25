#FB sentiment analysis
#load libraries
library(Rfacebook)
library(plotly)

#authentication
my_oauth <- fbOAuth(app_id = "1195275193889976", app_secret = "d33f5c753cab45e1d746feb0be82ccea")
save(my_oauth, file = "my_oauth")
load("my_oauth")
me <- getUsers("me", token = my_oauth)

posts <- getPage("NickVujicic", n = 200, token = my_oauth)

posts_text <- posts$message 

posts_text <- posts_text[!is.na(posts_text)]

posts_text <- list(posts_text)
#preprocessing
posts_cleaned <- lapply(posts_text, FUN = function(x) {
  
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

#Corpus
posts_corpus <- VCorpus(VectorSource(posts_cleaned))
posts_corpus <- tm_map(posts_corpus, function(x) iconv(x, to='UTF-8-MAC', sub='byte'))
posts_corpus <- tm_map(posts_corpus, PlainTextDocument)
posts_corpus <- tm_map(posts_corpus, content_transformer(tolower))
posts_corpus <- tm_map(posts_corpus, stripWhitespace)
posts_corpus <- tm_map(posts_corpus, removePunctuation)

#Removing stop words
posts_corpus <- tm_map(posts_corpus, removeWords, stopwords("SMART"))

#Wordcloud
wordcloud(posts_corpus, min.freq = 4, random.order = FALSE, colors = brewer.pal(5, "Dark2"))

#dtm
posts_dtm <- DocumentTermMatrix(posts_corpus)

#freq terms
findFreqTerms(posts_dtm, 2)

#Sentiment Analysis
posts_sentiment <- data.frame(as.integer(as.character(calculate_total_presence_sentiment(posts_cleaned[[1]])[2, ])))

colnames(posts_sentiment) <- c("Count")

Sentiment <- c("Sarcasm", "Neutral", "Negative", "Positive", "Very Negative", "Very Positive")

posts_sentiment_data <- data.frame(temp, posts_sentiment)

plot_ly(posts_sentiment_data, x = ~Sentiment, y=~Count, type = "bar", color = ~Sentiment)
