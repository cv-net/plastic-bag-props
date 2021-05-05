library(stringr)
library(dplyr)
library(ggmap)
 ## initialize Google Map API

## truncate zip codes
short_zips=c()
for (zip in unique(zips)){
  if (str_length(zip) > 5) {
    short_zips[zip] <- str_sub(zip, start = 1, end=(str_length(zip)-(str_length(zip)-5)))
    }
}

lats<-c()
lons<-c()
system.time(
  for (zip in short_zips){ ## get lat lon for each short zip from Google API
    lons[zip] <-  ggmap::geocode(location = as.character(zip))[1]
    lats[zip] <- ggmap::geocode(location = as.character(zip))[2]
  }
)

zipcodes_df <- cbind("raw_zip"=names(short_zips), short_zips, lats,lons) ## binds short zips with corresponding lat lons
mergedlatlon <- merge(X2, zipcodes_df, by.x="zip", by.y="raw_zip")  ## merges with original dataframe
save(list = mergedlatlon, file="withlatlongs.csv") ## saves to output file
 
