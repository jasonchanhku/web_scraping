#Radar chart creation and analysis

#libraries used
library(data.table) #load csv fast 
library(dplyr) #data manipulation
library(Amelia) #investigate missing values
library(lubridate) #date conversion
library(reshape2) #data manipulation
library(radarchart) #javascript radar chart

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
country_dt_lm <- dcast.data.table(country_dt_lm, COUNTRY~FUND_ASSET_TYPE, value.var = "SUM_NET_SALE_USD")

#replace NAs with 0
country_dt_lm[is.na(country_dt_lm)] <- 0

#normalize function 
normalize <- function(x){
  return((x - min(x)) / (max(x) - min(x)))
}

#normalized data table
country_dt_lm_norm <- cbind(Country = country_dt_lm$COUNTRY, round(as.data.table(lapply(country_dt_lm[ , .(Alternatives, Balanced, Bond, Cash, Equity)],normalize)), digits = 2))

country_dt_lm_norm <-dcast.data.table(melt(country_dt_lm_norm, id.vars = "Country"), variable ~ Country)

#radar chart plotting all countries
chartJSRadar(country_dt_lm_norm, maxScale = 1, showToolTipLabel = TRUE, labelSize = 20)

#just singapore
chartJSRadar(country_dt_lm_norm[, .(variable, Singapore)], maxScale = 1, showToolTipLabel = TRUE, labelSize = 20, title = list(display = TRUE, text = "Custom Title"))

#to do list
# plot 6 months average
# show for all countries 
# show on same radar chart of Singapore last month and last 6 months
#show tables of raw and normalized
# plots next to each other ?