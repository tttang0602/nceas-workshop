library(DBI)
library(tidyverse)
library(dplyr)
library(dbplyr)
library(stringr)
# Read the csv file into text lines

data.ctd<-readLines("ocldb1499972358.22646.OSD.csv")

#data.ctd<-readLines("ocldb1499972358.22646.MBT.csv")

# Select the all the cast, latitudes, longtitude and date data from the csv file

## This set is more general, it includes measurements taken outside of gulf of mexico
lat<-str_match(data.ctd,"(Latitude)\\s+,,\\s+(\\S\\d+.\\d*)")
lon<-str_match(data.ctd,"(Longitude)\\s+,,\\s+(\\S\\d+.\\d*)")

## This is set is for Gulf of Meixco
#lat<-str_match(data.ctd,"(Latitude)\\s+,,\\s+(\\d+.\\d+)")
#lon<-str_match(data.ctd,"(Longitude)\\s+,,\\s+(-\\d+.\\d+)")

year<-str_match(data.ctd,"(Year)\\s+,,\\s+(\\d+)")
month<-str_match(data.ctd,"(Month)\\s+,,\\s+(\\d+)")
day<-str_match(data.ctd,"(Day)\\s+,,\\s+(\\d+)")
hour<-str_match(data.ctd,"(Time)\\s+,,\\s+(\\d+)")
cast<-str_match(data.ctd,"(CAST)\\s+,,\\s+(\\d+)")
# Save the latitude data in a matrix with col one lat and col 2 the value of the lat
lat.df<- data.frame(na.omit(lat[,-1:-2]),stringsAsFactors=FALSE)
lon.df<- data.frame(na.omit(lon[,-1:-2]),stringsAsFactors=FALSE)
year.df<-data.frame(na.omit(year[,-1:-2]),stringsAsFactors=FALSE)
month.df<-data.frame(na.omit(month[,-1:-2]),stringsAsFactors=FALSE)
day.df<-data.frame(na.omit(day[,-1:-2]),stringsAsFactors=FALSE)
hour.df<-data.frame(na.omit(hour[,-1:-2]),stringsAsFactors=FALSE)
cast.df<-data.frame(na.omit(cast[,-1:-2]),stringsAsFactors=FALSE)
colnames(lat.df)<-c("lat")
colnames(lon.df)<-c("lon")
colnames(year.df)<-c("year")
colnames(month.df)<-c("month")
colnames(day.df)<-c("day")
colnames(hour.df)<-c("hour")
colnames(cast.df)<-c("cast")

# Combine the cast, location and date data into one table
loc.date.cdt<-bind_cols(cast.df,lat.df,lon.df,year.df,month.df,day.df)
latdir<-getwd()
 write_csv(loc.date.cdt,file.path(dir,"loc_date_cdt.csv"))
 
##-----------------------------
 #read the location and date file and plot measurements by year and by month
loc_date_cdt<-read.csv("loc_date_ctd.csv")
measure.year<-table(loc_date_cdt$year) # loc_date_cdt %>% group_by(year) %>% count()
yearmap<- barplot(measure.year,ylab = "freq",xlab="year")

#yearmap <- ggplot(measure.year, aes(year, n)) + geom_bar(
#  stat = "identity", 
#  fill = "forestgreen", 
#  width = 0.25) + coord_flip()
yearmap

measure.month<- table(loc_date_cdt$month)  #loc.date.cdt %>% group_by(month) %>% count()
monthmap<- barplot(measure.month,xlab = "month",ylab="freq")
monthmap

