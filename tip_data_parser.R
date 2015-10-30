source('data_parser.R')

yelp.loadTipData <- function(){
  tipData <- data.table(user_id = character(),
                        business_id = character(),
                        text = character(),
                        likes = integer(),
                        date = character()
                        )

  yelp.eachTipData(function(data, i){
    tipData <<- rbind(tipData, data.table(user_id = data$user_id,
                                          business_id = as.character(data$business_id),
                                          text = as.character(data$text),
                                          likes = data$likes,
                                          date = data$date), 
                      fill = TRUE
                      )
  })
  tipData$likes <- as.integer(tipData$likes)
  tipData$date <- as.Date(tipData$date)
  tipData
}