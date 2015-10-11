library(RJSONIO)
library(plyr)
library(data.table)

SOURCE_FILE_TYPES <- c('business', 'checkin', 'review', 'tip', 'user')

yelp.setReadLength <- function(n){
  yelpReadLength <<- n
}

yelp.getReadLength <- function(){
  if(exists('yelpReadLength')){
    yelpReadLength
  }else{
    -1L
  }
}

yelp.loadFile <- function(sourceType){
  if(sum(SOURCE_FILE_TYPES == sourceType) != 1){
    message <- paste('sourceType must be one of', paste(SOURCE_FILE_TYPES, collapse=", "))
    stop(message)
  }
  filePath <- paste("data/yelp_academic_dataset_", sourceType, ".json", sep='')
  message('loading ', sourceType, '.jons file...')
  readLines(filePath, yelp.getReadLength())
}

yelp.loadBusinessBase <- function(){
  columns <- c('business_id', 'full_address', 'city', 'review_count', 'name', 'longitude', 'state', 'stars', 'latitude', 'type')
  factorColumns <- c('city', 'state', 'type')
  lines <- yelp.loadFile('business')
  lineLength <- length(lines)

  baseData <- vector(mode = 'list', length = lineLength)
  for(i in 1:lineLength){
    baseData[[i]] <- fromJSON(lines[i])[columns]
    if(i %% 10000 == 0){ message(i, ' of ', lineLength, ' lines loaded...') }
  }
  
  message('modifying to data.frame...')
  baseData <- ldply(baseData, data.frame, stringsAsFactors = F)
  
  message('applying factor type...')
  for(column in factorColumns){
    baseData[[column]] <- as.factor(baseData[[column]])
  }
  data.table(baseData)
}


start <- proc.time()
yelp.loadBusinessHour <- function(){
  lines <- yelp.loadFile('business')
  lineLength <- length(lines)
  businessHour <- data.table(business_id = character(),
                             status = character(),
                             Monday = character(),
                             Tuesday = character(),
                             Wednesday = character(),
                             Thursday = character(),
                             Friday= character(),
                             Saturday = character(),
                             Sunday = character()
                             )
  for(i in 1:lineLength){
    jsonData <- fromJSON(lines[i])
    data <- data.frame(jsonData$hours)
    if(length(data) == 0) next

    data$status <- rownames(data)
    data$business_id <- jsonData$business_id

    businessHour <- rbind(businessHour, data, fill =  TRUE)
    if(i %% 1000 == 0){ 
      consum <- (proc.time() - start)['elapsed']
      message(i, ' of ', lineLength, ' lines loaded...')
      message('cosum : ', consum)
      start <- proc.time()
    }
  }
  message('applying factor type...')
  businessHour$status <- as.factor(businessHour$status)
  businessHour
}