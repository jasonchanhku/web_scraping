#MMA fighter database extraction
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)

webpage <- character(length(letters))
url_list <- c()

for(j in 1:length(letters)){
  
  webpage[j] <- paste0("http://www.fightmetric.com/statistics/fighters?char=", letters[j], "&page=all")
  temp <- read_html(webpage[j]) %>% html_nodes(".b-statistics__table-col:nth-child(1) .b-link_style_black") %>% html_attr("href")
  url_list <- c(url_list, temp)     
}

#initialization
name <- character(length(url_list))
weightclass <- numeric(length(url_list))
reach <- numeric(length(url_list))
slpm <- numeric(length(url_list))
td <- numeric(length(url_list))
tda <- numeric(length(url_list))
tdd <- numeric(length(url_list))
stra <- numeric(length(url_list))
strd <- numeric(length(url_list))
suba <- numeric(length(url_list))
sapm <- numeric(length(url_list))

#for loop
for(i in 1:length(url_list))
{
#fighter url
fighter_url <- read_html(url_list[i])

#fighter name
name_t <- fighter_url %>% html_nodes(".b-content__title-highlight") %>% html_text()
name_t <- gsub("\n", "", name_t)
name[i] <- as.character(trimws(name_t))

#weightclass
weightclass_t <- fighter_url %>% html_nodes(".b-list__info-box_style_small-width .b-list__box-list-item_type_block:nth-child(2)") %>% html_text()
weightclass_t <- gsub(" ", "", weightclass_t)
weightclass_t <- gsub("\n", "", weightclass_t)
weightclass_t <- strsplit(weightclass_t, ":")
weightclass_t <- weightclass_t[[1]][2]
weightclass_t <- strsplit(weightclass_t, "l")
weightclass[i] <- as.numeric(as.character(weightclass_t[[1]][1]))

#reach
reach_t <- fighter_url %>% html_nodes(".b-list__info-box_style_small-width .b-list__box-list-item_type_block:nth-child(3)") %>% html_text()
reach_t <- gsub(" ", "", reach_t)
reach_t <- gsub("\n", "", reach_t)
reach_t <- strsplit(reach_t, ":")
reach_t <- reach_t[[1]][2]
reach_t <- strsplit(reach_t, "\"")
reach[i] <- as.numeric(as.character(reach_t[[1]][1]))

#feature 1: slpm
slpm_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(1)") %>% html_text()
slpm_t <- gsub(" ", "", slpm_t)
slpm_t <- gsub("\n", "", slpm_t)
slpm_t <- strsplit(slpm_t, ":")
slpm_t <- slpm_t[[1]][2]
slpm[i] <- as.numeric(slpm_t)

#feature 2: takedown avg
td_t <- fighter_url %>% html_nodes(".b-list__info-box_style-margin-right .b-list__box-list-item_type_block:nth-child(2)") %>% html_text()
td_t<- gsub(" ", "", td_t)
td_t <- gsub("\n", "", td_t)
td_t <- strsplit(td_t, ":")
td_t <- td_t[[1]][2]
td[i] <- as.numeric(td_t)

#feature 3: significant striking accuracy
stra_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(2)") %>% html_text()
stra_t <- gsub(" ", "", stra_t)
stra_t <- gsub("\n", "", stra_t)
stra_t <- strsplit(stra_t, ":")
stra_t <- stra_t[[1]][2]
stra_t <- strsplit(stra_t, "%")
stra[i] <- as.numeric(stra_t) / 100

#feature 4: takedown accuracy 
tda_t <- fighter_url %>% html_nodes(".b-list__info-box_style-margin-right .b-list__box-list-item_type_block:nth-child(3)") %>% html_text()
tda_t <- gsub(" ", "", tda_t)
tda_t <- gsub("\n", "", tda_t)
tda_t <- strsplit(tda_t, ":")
tda_t <- tda_t[[1]][2]
tda_t <- strsplit(tda_t, "%")
tda[i] <- as.numeric(tda_t) / 100

#feature 5: significant absorbed stras per minute
sapm_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(3)") %>% html_text()
sapm_t <- gsub(" ", "", sapm_t)
sapm_t <- gsub("\n", "", sapm_t)
sapm_t <- strsplit(sapm_t, ":")
sapm_t <- sapm_t[[1]][2]
sapm[i] <- as.numeric(sapm_t)

#feature 6: takedown def
tdd_t <- fighter_url %>% html_nodes(".b-list__info-box_style-margin-right .b-list__box-list-item_type_block:nth-child(4)") %>% html_text()
tdd_t <- gsub(" ", "", tdd_t)
tdd_t <- gsub("\n", "", tdd_t)
tdd_t <- strsplit(tdd_t, ":")
tdd_t <- tdd_t[[1]][2]
tdd_t <- strsplit(tdd_t, "%")
tdd[i] <- as.numeric(tdd_t) / 100

#feature 7: striking def
strd_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(4)") %>% html_text()
strd_t <- gsub(" ", "", strd_t)
strd_t <- gsub("\n", "", strd_t)
strd_t <- strsplit(strd_t, ":")
strd_t <- strd_t[[1]][2]
strd_t <- strsplit(strd_t, "%")
strd[i] <- as.numeric(strd_t) / 100

#feature 8: submission average
suba_t <- fighter_url %>% html_nodes(".b-list__box-list_margin-top .b-list__box-list-item_type_block:nth-child(5)") %>% html_text()
suba_t <- gsub(" ", "", suba_t)
suba_t <- gsub("\n", "", suba_t)
suba_t <- strsplit(suba_t, ":")
suba_t <- suba_t[[1]][2]
suba[i] <- as.numeric(suba_t)

}

#data frame
database <- data.frame(NAME = name, Weight = weightclass, REACH = reach, SLPM = slpm, SAPM = sapm, STRA = stra, STRD = strd, TD = td, TDA = tda, TDD = tdd, SUBA = suba )

#adding weightclass
data_add_wc <- mutate(database, WeightClass = ifelse(Weight == 115, "strawweight", ifelse(Weight == 125, "flyweight", ifelse(Weight == 135, "bantamweight", ifelse(Weight == 145, "featherweight", ifelse(Weight == 155, "lightweight", ifelse(Weight == 170, "welterweight", ifelse(Weight == 185, "middleweight", ifelse(Weight == 205, "lightheavyweight", ifelse(Weight > 205, "heavyweight", "catchweight"))))))))))
data_add_wc <- data_add_wc[c(1,2,12,3,4,5,6,7,8,9,10,11)]

#cleaning data
data_clean <- data_add_wc[!is.na(data_add_wc$Weight), ]

#dealing with catchweights
data_clean[data_clean$WeightClass == "catchweight",]$WeightClass <- ifelse(data_clean[data_clean$WeightClass == "catchweight",]$Weight < 115, "strawweight", "catchweight")
data_clean[data_clean$WeightClass == "catchweight",]$WeightClass <- ifelse(data_clean[data_clean$WeightClass == "catchweight",]$Weight < 125, "flyweight", "catchweight")
data_clean[data_clean$WeightClass == "catchweight",]$WeightClass <- ifelse(data_clean[data_clean$WeightClass == "catchweight",]$Weight < 135, "bantamweight", "catchweight")
data_clean[data_clean$WeightClass == "catchweight",]$WeightClass <- ifelse(data_clean[data_clean$WeightClass == "catchweight",]$Weight < 145, "featherweight", "catchweight")
data_clean[data_clean$WeightClass == "catchweight",]$WeightClass <- ifelse(data_clean[data_clean$WeightClass == "catchweight",]$Weight < 155, "lightweight", "catchweight")
data_clean[data_clean$WeightClass == "catchweight",]$WeightClass <- ifelse(data_clean[data_clean$WeightClass == "catchweight",]$Weight < 170, "welterweight", "catchweight")
data_clean[data_clean$WeightClass == "catchweight",]$WeightClass <- ifelse(data_clean[data_clean$WeightClass == "catchweight",]$Weight < 185, "middleweight", "catchweight")
data_clean[data_clean$WeightClass == "catchweight",]$WeightClass <- ifelse(data_clean[data_clean$WeightClass == "catchweight",]$Weight < 205, "lightheavyweight", "catchweight")

#data preprocessing reach
strawweight_mean <- round(mean(data_clean[data_clean$WeightClass=="strawweight", ]$REACH, na.rm = TRUE), digits = 0)
flyweight_mean <- round(mean(data_clean[data_clean$WeightClass=="flyweight", ]$REACH, na.rm = TRUE), digits = 0)
bantamweight_mean <- round(mean(data_clean[data_clean$WeightClass=="bantamweight", ]$REACH, na.rm = TRUE), digits = 0)
featherweight_mean <- round(mean(data_clean[data_clean$WeightClass=="featherweight", ]$REACH, na.rm = TRUE), digits = 0)
lightweight_mean <- round(mean(data_clean[data_clean$WeightClass=="lightweight", ]$REACH, na.rm = TRUE), digits = 0)
welterweight_mean <- round(mean(data_clean[data_clean$WeightClass=="welterweight", ]$REACH, na.rm = TRUE), digits = 0)
middleweight_mean <- round(mean(data_clean[data_clean$WeightClass=="middleweight", ]$REACH, na.rm = TRUE), digits = 0)
lightheavyweight_mean <- round(mean(data_clean[data_clean$WeightClass=="lightheavyweight", ]$REACH, na.rm = TRUE), digits = 0)
heavyweight_mean <- round(mean(data_clean[data_clean$WeightClass=="heavyweight", ]$REACH, na.rm = TRUE), digits = 0)

#filling in missing reach for coressponding weight classes, replace by mean of weightclass
data_clean$REACH[is.na(data_clean$REACH) & data_clean$WeightClass == "strawweight"] <- strawweight_mean
data_clean$REACH[is.na(data_clean$REACH) & data_clean$WeightClass == "flyweight"] <- flyweight_mean
data_clean$REACH[is.na(data_clean$REACH) & data_clean$WeightClass == "bantamweight"] <- bantamweight_mean
data_clean$REACH[is.na(data_clean$REACH) & data_clean$WeightClass == "featherweight"] <- featherweight_mean
data_clean$REACH[is.na(data_clean$REACH) & data_clean$WeightClass == "lightweight"] <- lightweight_mean
data_clean$REACH[is.na(data_clean$REACH) & data_clean$WeightClass == "welterweight"] <- welterweight_mean
data_clean$REACH[is.na(data_clean$REACH) & data_clean$WeightClass == "middleweight"] <- middleweight_mean
data_clean$REACH[is.na(data_clean$REACH) & data_clean$WeightClass == "lightheavyweight"] <- lightheavyweight_mean
data_clean$REACH[is.na(data_clean$REACH) & data_clean$WeightClass == "heavyweight"] <- heavyweight_mean

