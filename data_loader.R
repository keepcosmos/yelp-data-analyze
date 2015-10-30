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