library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(tidyverse)

#find boundary of data set
incident<-read_csv("Incidents_NOAA1985-2016.csv")
incident.pre<-incident[!is.na(incident$lat),]
incident.pre<-incident.pre[!is.na(incident.pre$lon),]
lat2<-incident.pre[incident.pre$lat<31,]
lat2<-lat2[lat2$lat>18,]
lat3<-lat2[lat2$lon< -80,]
lat3<-lat3[lat3$lon> -100,]
write.csv(lat3,"GoM_oilspill.csv")
map.box<- make_bbox(lon = lat3$lon,lat = lat3$lat)


# grab map from google
my.map<-get_map(location = map.box,source = "google",maptype = "terrain")

#plot the location of incidents happened in GoM
ggmap(my.map)+geom_point(data=lat3,mapping = aes(x=lat3$lon,y=lat3$lat))


##map the environment measurements in SEAMAP
setwd("C:/Users/yiyit/Google Drive/nceas_workshop/ ")
location<- read.csv("sta_env.csv")
year<- read.table("CRUISES.txt",sep = ",",header = TRUE)
year<-data.frame(na.omit(year$CRUISEID),na.omit(year$YR))
location<-location[!is.na(location$DECSLAT),]
locat<-data.frame((location$DECSLAT),(location$DECSLON),(location$CRUISEID))
colnames(year)<-c("CRUISEID","YR")
colnames(locat)<-c("lat","lon","CRUISEID")
loc_yr<-inner_join(year,locat,by="CRUISEID")

#Plot the location of the measurements in seamap 
#map.box<- make_bbox(lon = locat$lon,lat = locat$lat)
map.box[1]<- -103
map.box[2]<-10
map.box[3]<- -70
map.box[4]<-35
my.map<-get_map(location = map.box,source = "google",maptype = "terrain")
ggmap(my.map)+geom_point(data=location,mapping = aes(x=location$DECSLON,y=location$DECSLAT))

#Plot the number of measurements per year
measure.year<-loc_yr%>%group_by(YR) %>% count()

p <- ggplot(measure.year, aes(YR, n)) + geom_bar(
  stat = "identity", 
  fill = "forestgreen", 
  width = 0.25) + coord_flip()
p

