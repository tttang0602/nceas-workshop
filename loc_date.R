# Read the csv file into text lines
data.ctd<-readLines("ocldb1499972358.22646.CTD.csv")

# Select the all the cast, latitudes, longtitude and date data from the csv file
lat<-str_match(data.ctd,"(Latitude)\\s+,,\\s+(\\d+.\\d+)")
lon<-str_match(data.ctd,"(Longitude)\\s+,,\\s+(-\\d+.\\d+)")
year<-str_match(data.ctd,"(Year)\\s+,,\\s+(\\d+)")
month<-str_match(data.ctd,"(Month)\\s+,,\\s+(\\d+)")
day<-str_match(data.ctd,"(Day)\\s+,,\\s+(\\d+)")
cast<-str_match(data.ctd,"(CAST)\\s+,,\\s+(\\d+)")
# Save the latitude data in a matrix with col one lat and col 2 the value of the lat
lat.df<- data.frame(na.omit(lat[,-1:-2]),stringsAsFactors=FALSE)
lon.df<- data.frame(na.omit(lon[,-1:-2]),stringsAsFactors=FALSE)
year.df<-data.frame(na.omit(year[,-1:-2]),stringsAsFactors=FALSE)
month.df<-data.frame(na.omit(month[,-1:-2]),stringsAsFactors=FALSE)
day.df<-data.frame(na.omit(day[,-1:-2]),stringsAsFactors=FALSE)
cast.df<-data.frame(na.omit(cast[,-1:-2]),stringsAsFactors=FALSE)
colnames(lat.df)<-c("lat")
colnames(lon.df)<-c("lon")
colnames(year.df)<-c("year")
colnames(month.df)<-c("month")
colnames(day.df)<-c("day")
colnames(cast.df)<-c("cast")

# Combine the cast, location and date data into one table
loc.date<-bind_cols(cast.df,lat.df,lon.df,year.df,month.df,day.df)




library(DBI)
library(tidyverse)
con <- dbConnect(RSQLite::SQLite(), dbname = ":memory:")

dbListTables(con)
dbWriteTable(con,"loc.date",loc.date)
dbGetQuery(con, "SELECT year FROM loc.date GROUP BY year ORDER BY year")

measure.year<-loc.date%>%group_by(year) %>% count()
p <- ggplot(measure.year, aes(year, n)) + geom_bar(
  stat = "identity", 
  fill = "forestgreen", 
  width = 0.25) + coord_flip()

library(dplyr)
library(dbplyr)
