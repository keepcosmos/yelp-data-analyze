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