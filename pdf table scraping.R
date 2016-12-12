#Extracting a table from a pdf file

library(tabulizer)
library(dplyr)

#link of pdf for table to be extracted
pdf <- "http://www.edd.ca.gov/jobs_and_training/warn/WARN-Report-for-7-1-2016-to-10-25-2016.pdf"

#extract the table into a list, bear in mind that extract_areas() can also be used for specific selection
#this returns a LIST of all entries into the table
#by leaving the second argument empty, we are actually selecting ALL pages
out <- extract_tables(pdf)

#binds the list using rbind
final_out <- do.call(rbind, out[-length(out)])

df <- as.data.frame(final_out)
df <- df[3:nrow(df), ]

#renaming columns to proper col names
colnames(df) <- c("Notice_Date", "Effective_Date", "Received_Date", "Company", "City", "Employees", "Layoff/Closure")

#change columns to correct data type
df <- mutate_each(df, funs(as.Date(., format='%m/%d/%Y')), Notice_Date, Effective_Date, Received_Date)
df$Company <- as.character(df$Company)
df$City <- as.character(df$City)
df$Employees <- as.numeric(df$Employees)
df$`Layoff/Closure` <- as.character(df$`Layoff/Closure`)

#write csv
write.csv(df, file = "data.csv", row.names = FALSE)
