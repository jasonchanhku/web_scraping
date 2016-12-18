#Radar chart creation and analysis

#libraries used
library(data.table) 
library(dplyr)
library(Amelia) #investigate missing values
library(lubridate) #date conversion
library(reshape2)
library(fmsb)
#options

#load, convert to data.table, and change date column to date type
stats <- read.csv(file = "stats.csv", stringsAsFactors = FALSE)
stats_dt <- data.table(stats)
stats_dt$EFFECTIVE_DATE <- dmy(stats_dt$EFFECTIVE_DATE)

#Subset the columns into the ones we want
country_dt <- stats_dt[, .(EFFECTIVE_DATE,FUND_ASSET_TYPE,COUNTRY,NET_SALE_USD)]

#filter by month of october, group by country, summarise by asset classes
#month of october
country_dt_lm <- country_dt[EFFECTIVE_DATE == "2016-10-31" , .(SUM_NET_SALE_USD = sum(NET_SALE_USD)), .(COUNTRY, FUND_ASSET_TYPE)]

#cast it into asset class columns
country_dt_lm <- dcast.data.table(country_dt_lm, FUND_ASSET_TYPE ~ COUNTRY, value.var = "SUM_NET_SALE_USD")

#replace NAs with 0
country_dt_lm[is.na(country_dt_lm)] <- 0

#normalize function 
normalize <- function(x){
  return((x - min(x)) / (max(x) - min(x)))
}

#normalized data table
country_dt_lm_norm <- cbind(country_dt_lm$FUND_ASSET_TYPE, as.data.table(apply(country_dt_lm[ , .(China, `Hong Kong`, Korea, Singapore, Taiwan)],MARGIN = 1, normalize)))
colnames(country_dt_lm_norm) <- colnames(country_dt_lm)
#radar chart plotting
chartJSRadar(country_dt_lm_norm, maxScale = 1, showToolTipLabel = TRUE)
