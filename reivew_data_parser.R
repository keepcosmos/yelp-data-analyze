source('data_parser.R')

yelp.loadReviewBaseData <- function(){
  reviewBaseData <- data.table(review_id = character(),
                               business_id = character(),
                               user_id = character(),
                               stars = numeric(),
                               text = character(),
                               date = character())
  yelp.eachReviewData(function(data, i){
    reviewBaseData <<- rbind(reviewBaseData,
                             data.table(review_id = data$review_id,
                                        business_id = data$business_id,
                                        user_id = data$user_id,
                                        stars = data$stars,
                                        text = data$text,
                                        date = data$date))
  })
  reviewBaseData$stars <- as.integer(reviewBaseData$stars)
  reviewBaseData$date <- as.Date(reviewBaseData$date)
  reviewBaseData
}

yelp.loadReviewVoteData <- function(){
  reviewVoteData <- data.table(review_id = character(),
                               funny = integer(),
                               useful = integer(),
                               cool = integer())
  yelp.eachReviewData(function(data, i){
    reviewVoteData <<- rbind(reviewVoteData, data.table(review_id = data$review_id,
                                                        funny = data$votes['funny'],
                                                        useful = data$votes['useful'],
                                                        cool = data$votes['cool']))
  })
  reviewVoteData
}