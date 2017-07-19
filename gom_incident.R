datalibrary(ggplot)
library(ggmap)
library(maps)
library(mapdata)
#find boundary of data set
incident<-read_csv("Incidents_NOAA1985-2016.csv")
incident.pre<-incident[!is.na(incident$lat),]
incident.pre<-incident.pre[!is.na(incident.pre$lon),]
lat2<-incident.pre[incident.pre$lat<31,]
lat2<-incident.pre[incident.pre$lat>18,]
lat3<-lat2[lat2$lon< -80,]
lat3<-lat3[lat3$lon> -100,]
map.box<- make_bbox(lon = lat3$lon,lat = lat3$lat)




# grab map from google
my.map<-get_map(location = map.box,source = "google",maptype = "terrain")

#plot
ggmap(my.map)+geom_point(data=lat3,mapping = aes(x=lat3$lon,y=lat3$lat,
                                                         color=lat3$max_ptl_release_gallons))


