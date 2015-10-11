source('data_parser.R')

yelp.eachData <- function(func, loggingLine = 10000){
  lines <- yelp.loadFile('business')
  lineLength <- length(lines)
  
  message('start parsing...')
  for(i in 1:lineLength){
    func(fromJSON(lines[i]), i)
    if(i %% loggingLine == 0){ message(i, ' of ', lineLength, ' lines loaded...') }
  }
}


yelp.loadBusinessBase <- function(){
  columns <- c('business_id', 'full_address', 'city', 'review_count', 'name', 'longitude', 'state', 'stars', 'latitude', 'type')
  factorColumns <- c('city', 'state', 'type')
  baseData <- vector(mode = 'list')
  yelp.eachData(function(data, i){
    baseData[[i]] <<- data[columns]
  })
  
  message('modifying to data.frame...')
  baseData <- ldply(baseData, data.frame, stringsAsFactors = F)
  
  message('applying factor type...')
  for(column in factorColumns){
    baseData[[column]] <- as.factor(baseData[[column]])
  }
  data.table(baseData)
}

yelp.loadBusinessHour <- function(){
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

  yelp.eachData(function(data, i){
    hourData <- data.frame(data$hours)
    if(length(hourData) != 0){
      hourData$status <- rownames(hourData)
      hourData$business_id <- data$business_id
      
      businessHour <<- rbind(businessHour, hourData, fill =  TRUE) 
    }
  })
  message('applying factor type...')
  businessHour$status <- as.factor(businessHour$status)
  businessHour
}

yelp.loadBusinessCategory <- function(){
  businessCategory <- data.table(business_id = character(),
                                 category = character())
  yelp.eachData(function(data, i){
    for(category in data$categories){
      businessCategory <<- rbind(businessCategory,
                                data.table(business_id = data$business_id, category = category))
    }
  })
  businessCategory$category <- as.factor(businessCategory$category)
  businessCategory
}

yelp.loadBusinessNeighborhood <- function(){
  businessCategory <- data.table(business_id = character(),
                                 neighborhood = character())
  yelp.eachData(function(data, i){
    for(neighborhood in data$neighborhoods){
      businessCategory <<- rbind(businessCategory,
                                 data.table(business_id = data$business_id, neighborhood = neighborhood))
    }
  })
  businessCategory
}

yelp.loadBusinessAttribute <- function(){
  businessAttribute <- data.table()
  yelp.eachData(function(data, i){
    if(length(data$attributes) > 0){
      businessAttribute <<- rbind(businessAttribute,
                                  data.table(t(unlist(data$attributes))),
                                  fill = T) 
    }
  })
  businessAttribute
}

# PRIVATE 
yelp.getAttributes <- function(){
  message('find attribute keys...(they are unlisted data)')
  keys <- c()
  yelp.eachData(function(line, i){
    keys <<- union(keys, names(unlist(fromJSON(line)$attributes)))
  })
  keys
}