#'AdaBoost.M1
library('data.table')
library('dplyr')
library('caret')
library('randomForest')

yelp.attrAndStarByCategory <- function(category){
  catAttr <- yelp.bizAttrByCategory(category)
  catBase <- yelp.bizBaseByCategory(category)
  catStar <- select(catBase, business_id, review_count, stars)
  cat <- merge(catAttr, catStar, by = 'business_id')
  cat$stars <- as.factor(cat$stars)
  cat
}

yelp.treatNA <- function(bizData){
  bizData[is.na(bizData)] <- 0
  na.roughfix(bizData)
  bizData
}

yelp.removeNZV <- function(bizData){
  select(bizData, -nearZeroVar(bizData))
}

yelp.removeLessObservedColumn <- function(bizData){
  cutoff <- as.integer(length(bizData$business_id) * 2 / 3)
  liveCols <- colSums(is.na(bizData)) < cutoff
  liveColNames <- colnames(bizData)[liveCols]
  select(bizData, one_of(liveColNames))
}

yelp.checkinByCategory <- function(category){
  checkin <- yelp.readCheckin()
  checkin[checkin$business_id %in% yelp.getBizIdsByCategory(category)]
}

yelp.bizAttrByCategory <- function(category){
  bizAttr <- yelp.readBizAttr()
  bizAttr[bizAttr$business_id %in% yelp.getBizIdsByCategory(category)]
}

yelp.bizBaseByCategory <- function(category){
  bizBase <- yelp.readBizBase()
  bizBase[bizBase$business_id %in% yelp.getBizIdsByCategory(category)]
}

yelp.getBizIdsByCategory <- function(categ){
  bizCat <- yelp.fetchBizCat()
  bizCat[bizCat$category == categ]$business_id
}

yelp.fetchBizCat <- function(cache = TRUE){
  if(cache && exists('fetchedBizCat')){
    fetchedBizCat
  }else{
    fetchedBizCat <<- yelp.readBizCategory()
    fetchedBizCat
  }
}


#### - LOAD DATA - #####

yelp.readUserBase <- function(){
  data.table(read.table('data/rda/user-base.Rda'))
}

yelp.readUserCompliment <- function(){
  data.table(read.table('data/rda/user-compliment.Rda'))
}

yelp.readBizBase <- function(){
  data.table(read.table('data/rda/business-base.Rda'))
}

yelp.readBizCategory <- function(){
  data.table(read.table('data/rda/business-category.Rda'))
}

yelp.readBizAttr <- function(){
  data.table(read.table('data/rda/business-attribute.Rda'))
}

yelp.readTip <- function(){
  data.table(read.table('data/rda/tip.Rda'))
}

yelp.readReviewBase <- function(){
  data.table(read.table('data/rda/review-base.Rda'))
}

yelp.readReviewVote <- function(){
  data.table(read.table('data/rda/review-vote.Rda'))
}

yelp.readCheckin <- function(){
  data.table(read.table('data/rda/check-in.Rda'))
}
