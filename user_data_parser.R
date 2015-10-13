source('data_parser.R')

yelp.userVoteTypes <- c('funny', 'useful', 'cool')
yelp.userComplimentTypes <- c('profile', 'cute', 'funny', 'plain', 'writer', 'note', 'photos', 'hot', 'cool', 'more', 'list')

yelp.loadUserBaseData <- function(){
  userBaseData <- data.table(user_id = character(),
                             name = character(),
                             review_count = integer(),
                             average_stars = numeric(),
                             fans = integer(),
                             yelping_since.year = integer(),
                             yelping_since.month = integer()
                             )
  yelp.eachUserData(function(data, i){
    since <- as.integer(strsplit(data$yelping_since, '-')[[1]])
    userBaseData <<- rbind(userBaseData, data.table(user_id = data$user_id,
                                                    name = data$name,
                                                    review_count = data$review_count,
                                                    average_stars = data$average_stars,
                                                    fans = data$fans,
                                                    yelping_since.year = since[1],
                                                    yelping_since.month = since[2]))
  })
  userBaseData
}

yelp.loadUserVoteData <- function(){
  userVoteData <- data.table(user_id = character(),
                             funny = integer(),
                             useful = integer(),
                             cool = integer())
  yelp.eachUserData(function(data, i){
    userVoteData <<- rbind(userVoteData, data.table(user_id = data$user_id,
                                                    funny = data$votes['funny'],
                                                    useful = data$votes['useful'],
                                                    cool = data$votes['cool']))
  })
  userVoteData
}

yelp.loadUserComplimentData <- function(){
  userComplimentData <- data.table(user_id = character())
  yelp.eachUserData(function(data, i){
    if(length(data$compliments) > 0){
      userComplimentData <<- rbind(userComplimentData,
                                   data.table(user_id = data$user_id,
                                              t(unlist(data$compliments))),
                                   fill = TRUE) 
    }
  })
  userComplimentData
}

yelp.loadUserFriendData <- function(){
  userFriendData <- list()
  yelp.eachUserData(function(data, i){
    userFriendData[[data$user_id]] <<- data$friends
  })
  userFriendData
}

yelp.loadUserEliteYearData <- function(){
  userEliteYearData <- list()
  yelp.eachUserData(function(data, i){
    if(length(data$elite) > 0 ){
      userEliteYearData[[data$user_id]] <<- data$elite 
    }
  })
  userEliteYearData
}