source('data_parser.R')

yelp.loadBusinessBase <- function(){
  columns <- c('business_id', 'full_address', 'city', 'review_count', 'name', 'longitude', 'state', 'stars', 'latitude', 'type')
  factorColumns <- c('city', 'state', 'type')
  baseData <- vector(mode = 'list')
  yelp.eachBusinessData(function(data, i){
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

  yelp.eachBusinessData(function(data, i){
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
  yelp.eachBusinessData(function(data, i){
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
  yelp.eachBusinessData(function(data, i){
    for(neighborhood in data$neighborhoods){
      businessCategory <<- rbind(businessCategory,
                                 data.table(business_id = data$business_id, neighborhood = neighborhood))
    }
  })
  businessCategory
}

yelp.loadBusinessAttribute <- function(){
  columns <- yelp.getAttributeColumKeys()
  businessAttribute <- data.table()
  for(column in columns) businessAttribute[[column]] <- character()
  yelp.eachBusinessData(function(data, i){
    if(length(data$attributes) > 0){
      tryCatch({
        businessAttribute <<- rbind(businessAttribute,
                                    data.table(t(unlist(data$attributes))),
                                    fill = TRUE
                                    ) 
      }, error = function(e){
        warning(i, " line parsing error : ", e)
      })
    }
  })
  yelp.castAttributeData(businessAttribute)
}

# PRIVATE 
yelp.getAttributeColumKeys <- function(){
  if(exists('attrKeys') && length(attrKeys) > 0){
    attrKeys
  }else{
    message('find attribute keys...(they are unlisted data)')
    attrKeys <<- c()
    yelp.eachBusinessData(function(data, i){
      attrKeys <<- union(attrKeys, names(unlist(data$attributes)))
    })
    attrKeys
  }
}

yelp.castAttributeData <- function(data){
  attrColumns <- yelp.getAttributeColumKeys()
  for(column in attrColumns){
    columnType <- yelp.getAttributeColumnType(column)
    if(columnType == 'character'){
      data[[column]] <- as.factor(data[[column]])
    }else if(columnType == 'integer'){
      data[[column]] <- as.integer(data[[column]])
    }else{
      logicalVec <- data[[column]]
      logicalVec[logicalVec %in% yelp.TrueCharacter] <- 'TRUE'
      logicalVec[logicalVec %in% yelp.FalseCharacter] <- 'FALSE'
      data[[column]] <- as.logical(logicalVec)
    }
  }
  data
}

yelp.getAttributeColumnType <- function(columnName){
  stringColumns <- c('Alcohol', 'Noise Level', 'Attire', 'Smoking', 'Wi-Fi', 'BYOB/Corkage', 'Ages Allowed')
  integerColumns <- c('Price Range')
  if(sum(stringColumns == columnName) == 1){
    'character'
  }else if(sum(integerColumns == columnName) == 1){
    'integer'
  }else{
    'logical'
  }
}