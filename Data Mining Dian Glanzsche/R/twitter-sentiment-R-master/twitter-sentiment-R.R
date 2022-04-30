
library(twitteR)
library(lubridate)
library(ROAuth)
library(plyr)
library(stringr)
library(ggplot2)
library(ggthemes)
library(wordcloud)
library(igraph)
require(RCurl)
library(tm)
library(scales)
library(ggmap)
library(dplyr)
library("SnowballC")
library("RColorBrewer") 
library("RCurl")
library("XML")
library(stringr)
library(knitr)

# Add your relevant keys here
consumer.key <- "p3xXhyPf1FXvyrlDmD9OQV8XK"
consumer.secret <- "vqVPRlUTCYHOWiao2h1wSoiu913qxqqrqBNOWORxKiwXaB71ka"
access.token <- "781165819480776705-ivPrcJgMwgO3rzYyd1fJ3AZxnOqZeu9"
access.token.secret <- "HANXygVtBIAnhzHwZrlHQvxBekjBHuwufdFxgEJZwmX8O"

consumer.key <- "QPetxNOgySD5MruipCERTgrbE"
consumer.secret <- "pvQFbJcg2ucV8AAmR2z2AxjB6RrIltOdJ3etflhCgubPFbD1GT"
access.token <- "81391279-PJQcBZZ7MBLoZq2yJUM7M4rmknqKepmuyN012FQqf"
access.token.secret <- "Iwh4gtguhjrEfrK9jOeYVaUO75qBxiyNyIbkJpOM0sC2W"

consumer.key <- "ctP2TwBxFOWxKmla0AKi7C2iE"
consumer.secret <- "8Hhx0VNxJ4NTWZ7hxJJdlctHQKCtZgqdpoZKQf1diQNxuD6UWb"
access.token <- "81391279-HviUdY0REC1xh2PCV2tWi43ehIY3Fx01Rh0aYNnHn"
access.token.secret <- "DIgYRmyWy9I3qykVelltzNjUg9129IBuUOHgmh3oZr9aq"

setup_twitter_oauth(consumer_key=consumer.key, consumer_secret=consumer.secret, access_token=access.token, access_secret=access.token.secret)

query <- 'Jakarta Bersyariah' # The word we want to analyze. Change this
maxTweets <- 10000 # The maximum number of tweets to search
startDate <- '2016-01-01'

# GET TRENDS
getTrends(23424846)
trendind<-getTrends(woeid=23424846, period("daily"))
today_trends = getTrends(woeid=23424846, period = "daily", date=Sys.Date())

trend<-getTrends(woeid=2459115)
head(trend,20)
dim(trend)

score.sentiment <- function(sentences, pos.words, neg.words, .progress='none') {
    require(plyr)
    require(stringr)
    scores = laply(sentences, function(sentence, pos.words, neg.words) {
        sentence <- gsub("[^[:alnum:]///' ]", "", sentence)
        sentence <- gsub('[[:punct:]]', '', sentence)
        sentence <- gsub('[[:cntrl:]]', '', sentence)
        sentence <- gsub('\\d+', '', sentence)
        sentence <- tolower(sentence)
        word.list <- str_split(sentence, '\\s+')
        words <- unlist(word.list)
        pos.matches <- match(words, pos.words)
        neg.matches <- match(words, neg.words)
        pos.matches <- !is.na(pos.matches)
        neg.matches <- !is.na(neg.matches)
        score <- sum(pos.matches) - sum(neg.matches)
        return(score)
    }, pos.words, neg.words, .progress=.progress)
    scores.df <- data.frame(score=scores, text=sentences)
    return(scores.df)
}
# Load the lexicon
pos.words <- scan('C:/Users/Dian Putri Indah M/Documents/Data Mining/R/positive.txt', what='character', comment.char=';')
neg.words <- scan('C:/Users/Dian Putri Indah M/Documents/Data Mining/R/negative.txt', what='character', comment.char=';')
pos.words <- c(pos.words, 'upgrade')

# Retrieve tweets based on query
tweets <- searchTwitter(query, n=10000)
tweets.df <- twListToDF(tweets)
write.csv(tweets.df, file='data.csv', row.names=FALSE, fileEncoding='UTF-8')

# tweets.df <- read.csv('data.csv')
tweets.df$text <- as.factor(tweets.df$text)
sentiment.scores <- score.sentiment(tweets.df$text, pos.words, neg.words, .progress='text')
write.csv(sentiment.scores, file='scores.csv', row.names=TRUE, fileEncoding='UTF-8', quote=TRUE)

# Uncomment these for a histogram of general sentiment
hist.plot <- ggplot() + geom_histogram(data=sentiment.scores, aes(x=score))
hist.plot + theme_economist() + scale_colour_economist()

# Uncomment these for wordcloud
require(tm)
require(wordcloud)
require(RColorBrewer)
sentiment.scores$text <- encodeString(as.character(sentiment.scores$text))
corp <- Corpus(DataframeSource(data.frame(as.character(sentiment.scores[ ,2]))))
corp <- tm_map(corp, tolower)
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, function(x) removeWords(x, stopwords()))
corp <- tm_map(corp, PlainTextDocument)
ap.tdm <- TermDocumentMatrix(corp)
ap.m <- as.matrix(ap.tdm)
ap.v <- sort(rowSums(ap.m),decreasing=TRUE)
ap.d <- data.frame(word = names(ap.v),freq=ap.v)
table(ap.d$freq)
pal2 <- brewer.pal(8,"Dark2")
png("wordcloud_packages.png", width=1200,height=800)
wordcloud(ap.d$word,ap.d$freq, scale=c(15,.2),min.freq=10,
          max.words=70, random.order=FALSE, rot.per=.15, colors=pal2)
dev.off()

# Retweet Graph
load("tweets.Rdata")
head(tweets,10)

dm_txt = sapply(tweets, function(x) x$getText())
grep("(RT|via)((?:\\b\\W*@\\w+)+)", tweets, ignore.case=TRUE, value=TRUE)
rt_patterns = grep("(RT|via)((?:\\b\\W*@\\w+)+)",dm_txt, ignore.case=TRUE)
head(dm_txt[rt_patterns],10)

# Create List to Store Username
who_retweet = as.list(1:length(rt_patterns))
who_post = as.list(1:length(rt_patterns))
for (i in 1:length(rt_patterns)){ 
    # get tweet with retweet entity
    twit = tweets[[rt_patterns[i]]]
    # get retweet source 
    poster = str_extract_all(twit$getText(),
                             "(RT|via)((?:\\b\\W*@\\w+)+)") 
    #remove ':'
    poster = gsub(":", "", unlist(poster)) 
    # name of retweeted user
    who_post[[i]] = gsub("(RT @|via @)", "", poster, ignore.case=TRUE) 
    # name of retweeting user 
    who_retweet[[i]] = rep(twit$getScreenName(), length(poster)) 
}
who_post = unlist(who_post)
who_retweet = unlist(who_retweet)

head(who_post,39)
head(who_retweet,100)

#generate graph
retweeter_poster = cbind(who_retweet, who_post)
rt_graph = graph.edgelist(retweeter_poster)
ver_labs = get.vertex.attribute(rt_graph, "name", index=V(rt_graph))

glay = layout.fruchterman.reingold(rt_graph)


#Wordcloud
retweeter_poster$who_post<-as.character(retweeter_poster$who_post)
wordcloud(retweeter_poster$who_post,min.freq=1)

par(bg="gray15", mar=c(1,1,1,1))
plot(rt_graph, layout=glay,
     vertex.color="gray25",
     vertex.size=10,
     vertex.label=ver_labs,
     vertex.label.family="sans",
     vertex.shape="none",
     vertex.label.color=hsv(h=0, s=0, v=.95, alpha=0.5),
     vertex.label.cex=0.85,
     edge.arrow.size=0.4,
     edge.arrow.width=0.3,
     edge.width=3,
     edge.color=hsv(h=.95, s=1, v=.7, alpha=0.5))
# add title
title("\nRetweet Network with keywords'#belaulama'\n by DPIM",cex.main=1, col.main="gray95") 

#Get Mention and its Ranking
mention <- str_extract_all(tweets.df$text, "@\\S+")
mention <- unlist(mention)
mention <- str_replace_all(mention, "[[:punct:]]", "")

mention <- data.frame(mention) %>% 
    group_by(mention) %>% 
    summarise(number = n()) %>% 
    ungroup() %>% 
    arrange(desc(number)) %>% 
    filter(mention != "isa2016") %>% 
    mutate(rank = 1:nrow(.)) %>% 
    dplyr::select(rank, mention, number) %>% 
    top_n(20, number)

kable(mention)

# Get retweet and its Ranking
retweet <- str_extract_all(tweets.df$text, "(RT|via)((?:\\b\\W*@\\w+)+)")
retweet <- unlist(retweet)
retweet <- str_replace_all(retweet, "[[:punct:]]", "")

retweet <- data.frame(retweet) %>% 
    group_by(retweet) %>% 
    summarise(number = n()) %>% 
    ungroup() %>% 
    arrange(desc(number)) %>% 
    filter(retweet != "isa2016") %>% 
    mutate(rank = 1:nrow(.)) %>% 
    dplyr::select(rank, retweet, number) %>% 
    top_n(20, number)

kable(retweet)

#Get hashtag and its ranking
hashtag <- str_extract_all(tweets.df$text, "#\\S+")
str_extract_all(tweets.df$text, "#\\S+")

hashtag <- unlist(hashtag)
hashtag <- str_replace_all(hashtag, "[[:punct:]]", "")
hashtag <- tolower(hashtag)

#hashtags <- str_replace_all(hashtag, "allmalepanels", "allmalepanel")

hashtag <- data.frame(hashtag) %>% 
    group_by(hashtag) %>% 
    summarise(number = n()) %>% 
    ungroup() %>% 
    arrange(desc(number)) %>% 
    filter(hashtag != "isa2016") %>% 
    mutate(rank = 1:nrow(.)) %>% 
    dplyr::select(rank, hashtag, number) %>% 
    top_n(20, number)

kable(hashtag)

# Popular Tweets
most_popular_tweets <- tweets.df %>% 
    filter(isRetweet == FALSE) %>% 
    ungroup() %>% 
    mutate(popularity = retweetCount + favoriteCount) %>% 
    arrange(desc(popularity)) %>% 
    top_n(15, popularity) %>% 
    dplyr::select(text, id, screenName, popularity) %>% 
    mutate(text = gsub("\\n", "", text),
           link_to_tweet = paste0("<a href = https://twitter.com/", screenName, "/status/", id, "> Link </a>"),
           screenName = paste0( screenName),
           rank = 1:nrow(.)) %>% 
    rename(tweet_text = text,
           twitter_user = screenName) %>% 
    dplyr::select(rank, tweet_text, twitter_user, link_to_tweet, popularity)

kable(most_popular_tweets)

# Plot twenty busiest tweeps
df <- tweets.df %>% 
group_by(screenName) %>% 
summarise(all_tweets = n(),
   retweets = sum(isRetweet),
   original_tweets = all_tweets - retweets) %>% 
ungroup() %>% 
top_n( 20, all_tweets) %>% 
gather(tweet_type, number, -screenName) %>% 
group_by(tweet_type) %>% 
arrange(number)

#setup_twitter_oauth(consumer_key = 'DZ3izDTm26J4mdLuJqK8sQ',
#                     consumer_secret='a02Tx4Yh3yPqT5WuWzG7CfnRSpu9mI7huthJOLmg4')
  
# get real names
for(i in 1:nrow(df)) {
  df[i, "realname"] <- getUser(df[i, "screenName"])$name  
 }
 
# create display
df$disp_name <- paste0(df$realname, " \n(@", df$screenName, ")")
save(df, file = "../twitter_user_ranking.rdata")


df <- tweets.df %>% 
    ungroup() %>% 
    filter(tweet_type != "all_tweets") %>% 
    mutate(tweet_type = ifelse(tweet_type == "original_tweets", "Original Tweet", "Retweet"))

plot_user_ranking <- ggplot(df, 
                            aes(x=reorder(disp_name, number), # reorder factor in order of most frequent
                                y = number)) + 
    geom_bar(stat = "identity", aes(fill = tweet_type)) + 
    scale_x_discrete(labels = df$disp_name) + 
    coord_flip() +
    scale_fill_brewer(palette = "Set1", 
                      guide = guide_legend(title = "")) + 
    labs(x = "", y = "") +
    theme_bw() +
    theme(axis.text.y=element_text(size = 8),legend.position = "bottom") 

print(plot_user_ranking)


# TIMELINE PLOT
mht=userTimeline('SiBonekaKayu',n=1600)
tw.df=twListToDF(mht)

# Pull out the names of folk who have been "old-fashioned RTd"...
require(stringr)
trim <- function (x) sub('@','',x)

tw.df$rt=sapply(tw.df$text,function(tweet) trim(str_match(tweet,"^RT (@[[:alnum:]_]*)")[2]))
tw.df$rtt=sapply(tw.df$rt,function(rt) if (is.na(rt)) 'T' else 'RT')
ggplot(tw.df)+geom_point(aes(x=created,y=screenName))

tw.dfs=subset(tw.df,subset=((Sys.time()-created)<8000))
ggplot(tw.dfs)+geom_point(aes(x=created,y=screenName))

# ReplytoSN Blue dot = old style retweet, red = reply
ggplot()+geom_point(data=subset(tw.dfs,subset=(!is.na(replyToSN))),aes(x=created,y=replyToSN),col='red') + geom_point(data=subset(tw.dfs,subset=(!is.na(rt))),aes(x=created,y=rt),col='blue') + geom_point(data=subset(tw.dfs,subset=(is.na(replyToSN) & is.na(rt))),aes(x=created,y=screenName),col='green')


#We can also generate barplots showing the distribution of tweet count over time:
ggplot(tw.dfs,aes(x=created))+geom_bar(aes(y = (..count..)))
ggplot(tw.dfs,aes(x=wday))+geom_bar(aes(y = (..count..)),binwidth=1)
 
 
