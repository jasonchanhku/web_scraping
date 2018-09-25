#Web scraping a html table
#libraries used
library(rvest)
library(dplyr)
library(reshape2)
library(googleVis)

#load html
webpage <- read_html("http://www.reed.edu/ir/geographic_states.html")

#extract table
col_table <- html_node(webpage, "table") 
col_table <- html_table(col_table)

#remove total row from data
data <- filter(col_table, State != "Total")

#expand data across the year columns
data_long <- melt(data, id = "State")

#proper column names
names(data_long) <- c("State", "Year", "Matriculants")

#proper variable type after melting
data_long$Year <- as.numeric(as.character(data_long$Year))
data_long$year <- data_long$Year
data_long$state <- data_long$State

#motion chart
p <- gvisMotionChart(data_long, "state", "year", xvar = "Year", yvar = "Matriculants", colorvar = "State")

print(p, "chart")
