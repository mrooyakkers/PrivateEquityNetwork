rm(list=ls())

# twitter followers scrape 
library(rtweet)
library(tidyverse)
library(dplyr)
library(stringr)

# pulling in twitter oauth
api_key <- "x"
api_secret_key <- "x"
access_token <- "x-x"
access_secret <- "x"

token <- create_token(
  app = "RScrape1",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_secret)
get_token()

blackstone <- get_followers("blackstone", n = 50)

cipiopartners <- get_followers("cipiopartners") # 705725394
auctusgroupinc <- get_followers("auctusgroupinc") # 3198733163
apolloglobal <- get_followers("apolloglobal") # 411240061

# generate edge list 
edgelist <- data.frame(cbind(rep(705725394, nrow(cipiopartners)), cipiopartners))
colnames(edgelist) <- c("source", "target")
edgelist_test2 <-data.frame(cbind(rep(3198733163, nrow(auctusgroupinc)), auctusgroupinc))
colnames(edgelist_test2) <- c("source", "target")
edgelist_test3 <-data.frame(cbind(rep(411240061, nrow(apolloglobal)), apolloglobal))
colnames(edgelist_test3) <- c("source", "target")

edgelist <- data.frame(rbind(edgelist, edgelist_test2, edgelist_test3))
write.csv2(edgelist, file = "edgelist.csv")

## getting information from userid 
followers <- c(edgelistSept26$target, 705725394, 3198733163, 411240061)
followers <- as.character(followers)

details_followers <- data.frame(matrix(ncol = 6, nrow = 1))
colnames(details_followers) <- c("user_id", "status_id", "screen_name", "text", "favorite_count", "retweet_count")
for (i in 1:length(followers)){
  tmp <- lookup_users(followers[i])
  if (length(tmp) == 1){
    next
  } else {
    tmp2 <- c(tmp$user_id, tmp$status_id, tmp$screen_name, tmp$text, tmp$favorite_count, tmp$retweet_count)
    details_followers <- data.frame(rbind(details_followers, tmp2))
  }
}


# then filter this data set down to only include finance people 
finance_terms <- strsplit("high-growth alternative asset manager leading global investment firm venture company valuation 
          leading global alternative investment manager analysis partner leader tech company startup million growth capital 
          global alternative asset firm investing growth change innovation million finance $ € series private equity value
          Blackstone world’s largest alternative asset manager Firm global investment firm based equity fund businesses technology 
          investment banking securities investment management wealth management services worldwide financial services firm", ' ')
x2 <- unlist(finance_terms)
x2 <- x2[!x2 %in% ""]
x2 <- x2[!x2 %in% "\n"]

# 

details_followers2 <- filter(details_followers, str_detect(text, paste(x2, collapse=" |")))
write.csv2(details_followers2, "details_followers.csv")










