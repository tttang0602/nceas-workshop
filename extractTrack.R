library(parallel)

library(stringr)

library(data.table)

library(dplyr)

library(plyr)
library(pryr)
library(pbmcapply)
#Make table with cast location and time information called loc_date

char_lines=readLines("ocldb1499972358.22646.XBT.csv")

########################################################################

#Extract beginning and ending lines for each table

beg=which(str_detect(char_lines, "^VARIABLES*"))
end=which(str_detect(char_lines, "END OF VARIABLES*"))
L<-length(beg)

casts<-vector()
casts[1]<-cast_df$cast[1]
casts[2]<-cast_df$cast[2]
for (i in (3:L)){
  
  casts[i]=max(which(str_detect(char_lines[(beg[i]-50):(beg[i])], "CAST")))+beg[i]-51
  castcatch<-str_match(char_lines[as.numeric(casts[i])],"(CAST)\\s+,,\\s*(\\d*)")
  casts[i]<-as.numeric(castcatch[,3])
  
}
measure<- data.frame(flag=integer(),
                     Depth=character(), 
                     Temperatur=character(),
                     Cast=integer(),
                     stringsAsFactors=FALSE)
table_list_CSV=vector("list", length(beg))

Seq<-1:L

table_list <- pbmclapply(1:1000, function(i){
    
    #Figure out how many columns
    ncol_raw_data=length(read.table("ocldb1499972358.22646.XBT.csv",skip=beg[i]+2,
                                    nrows=end[i]-beg[i]-3,sep=',',header=FALSE))
    
    #Store which ones to extract
    col_numbers=c(1,seq(2,ncol_raw_data-1,3))
    
    #Pulls out the data
    data<-read.table("ocldb1499972358.22646.XBT.csv",skip=beg[i]+2,
                     nrows=end[i]-beg[i]-3,sep=',',header=FALSE)
    data=data[,col_numbers]
    
    
    #Pulls out the header
    header=stringi::stri_extract_all_words(char_lines[beg[i]])[[1]][seq(2,ncol_raw_data-1,3)]
    
    #Adds the cast number
    data$Cast=rep(casts[i],times=nrow(data))
    
    #Adds header names
    names(data)=c("flag",header,"Cast")
    
    data
    #measure<-rbind.fill(measure,data)
    
  })
  

cat("Done\n")
for (i in Seq){
  measure=rbind.fill(measure,table_list[[1]])
}
write.csv(measure, "env_measures_xbt.csv") #saves variable table_list to file
