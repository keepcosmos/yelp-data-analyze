source('data_parser.R')

yelp.loadCheckInData <- function(){
  columns <- yelp.getDefaultCheckInColumns()
  checkInData <- data.table()
  yelp.eachCheckInData(function(data, i){
  
    checkInData <<- rbind(checkInData,
                          data.table(business_id = data$business_id, 
                                     t(unlist(data$checkin_info))),
                          fill = TRUE)
  }, 3000)

  cols <- colnames(checkInData)
  colsLength <- length(cols)
  cols <- sapply(cols[2:colsLength], yelp.splitColName)
  setnames(checkInData, c('business_id', cols))
  colOrdered <- c(1, (order(cols) + 1))
  setcolorder(checkInData, colOrdered)
  checkInData[is.na(checkInData)] <- 0
  checkInData
}

yelp.getDefaultCheckInColumns <- function(){
  if(exists('checkInColumns') && (length(checkInColumns) > 0)){
    return(checkInColumns)
  }
  checkInColumns <<- character()
  for(hour in 1:23){
    for(week in 0:6){
      checkInColumns <- c(checkInColumns, paste(hour, '-', week, sep = ''))
    }
  }
  checkInColumns
}

yelp.splitColName <- function(name){
  colS <- strsplit(name, split = '-')[[1]]
  paste(colS[2], '-', sprintf('%02d', as.integer(colS[1])), sep = '')
}