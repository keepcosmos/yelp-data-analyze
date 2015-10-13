# Load for yelp data set

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

yelp.eachData <- function(sourceType, func, loggingLine = 10000){
  lines <- yelp.loadFile(sourceType)
  lineLength <- length(lines)
  
  message('start parsing...')
  for(i in 1:lineLength){
    func(fromJSON(lines[i]), i)
    if(i %% loggingLine == 0){ message(i, ' of ', lineLength, ' lines loaded...') }
  }
}

yelp.eachBusinessData <- function(func, loggingLine = 10000){
  yelp.eachData('business', func, loggingLine)
}

yelp.eachCheckInData <- function(func, loggingLine = 10000){
  yelp.eachData('checkin', func, loggingLine)
}

yelp.eachUserData <- function(func, loggingLine = 10000){
  yelp.eachData('user', func, loggingLine)
}

yelp.eachTipData <- function(func, loggingLine = 10000){
  yelp.eachData('tip', func, loggingLine)
}

yelp.TrueCharacter <- c('TRUE', '1', 'true', 'yes', 'ok')
yelp.FalseCharacter <- c('FALSE', '0', 'false', 'no', 'none')