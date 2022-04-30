library(devtools)
library(twitteR)
library(wordcloud)
library(RColorBrewer)
library(tm)
library(NLP)
library(plyr)
library(dplyr)
library(stringr)
library(ggplot2)

api_key <- "p3xXhyPf1FXvyrlDmD9OQV8XK"
api_secret <- "vqVPRlUTCYHOWiao2h1wSoiu913qxqqrqBNOWORxKiwXaB71ka"
access_token <- "781165819480776705-ivPrcJgMwgO3rzYyd1fJ3AZxnOqZeu9"
access_token_secret <- "HANXygVtBIAnhzHwZrlHQvxBekjBHuwufdFxgEJZwmX8O"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

tw.mining = searchTwitter("#TenagaKerjaChina", n=4000)
tweets_geolocated <- searchTwitter("Obamacare OR ACA OR 'Affordable Care Act' OR #ACA", n=100, lang="en", geocode='34.04993,-118.24084,50mi', since="2014-08-20")

tweets.df <- twListToDF(tw.mining)
View(tweets.df)

#Geocoding
tweets.df <- subset(tweets.df, longitude!="NA")
tweets.df <- tweets.df[ c(15:16)]
tweets.df <- unique(tweets.df)
View(tweets.df)
getTrends(23424846)

tweets.df$longitude = as.numeric(as.character(tweets.df$longitude))
tweets.df$latitude = as.numeric(as.character(tweets.df$latitude))

library(ggmap)
map <- ggmap(indonesia_map)
map + geom_leg()


#Wordcloud
tw.mining.text <- sapply(tw.mining, function(x) x$getText())
tw.mining.text <- tolower(tw.mining.text)
tw.mining.text <- gsub("rt", "", tw.mining.text)
tw.mining.text <- gsub("@\\w+", "", tw.mining.text)
tw.mining.text <- gsub("[[:punct:]]", "", tw.mining.text)
tw.mining.text <- gsub("http\\w+", "", tw.mining.text)
tw.mining.text <- gsub("[ |\t]{2,}", "", tw.mining.text)
tw.mining.text <- gsub("^ ", "", tw.mining.text)
tw.mining.text <- gsub(" $", "", tw.mining.text)
tw.mining.text.corpus <- Corpus(VectorSource(tw.mining.text))
tw.mining.text.corpus <- tm_map(tw.mining.text.corpus, function(x)removeWords(x,stopwords()))

wordcloud(tw.mining.text.corpus,min.freq = 2, scale=c(7,0.5),colors=brewer.pal(8, "Dark2"),  random.color= TRUE, random.order = FALSE, max.words = 150)


search <- function(searchterm)
{
  #access tweets and create cumulative file
  
  list <- searchTwitter(searchterm, cainfo='cacert.pem', n=1500)
  df <- twListToDF(list)
  df <- df[, order(names(df))]
  df$created <- strftime(df$created, '%Y-%m-%d')
  if (file.exists(paste(searchterm, '_stack.csv'))==FALSE) write.csv(df, file=paste(searchterm, '_stack.csv'), row.names=F)
  
  #merge last access with cumulative file and remove duplicates
  stack <- read.csv(file=paste(searchterm, '_stack.csv'))
  stack <- rbind(stack, df)
  stack <- subset(stack, !duplicated(stack$text))
  write.csv(stack, file=paste(searchterm, '_stack.csv'), row.names=F)
  
  #evaluation tweets function
  score.sentiment <- function(sentences, pos.words, neg.words, .progress='none')
  {
    require(plyr)
    require(stringr)
    scores <- laply(sentences, function(sentence, pos.words, neg.words){
      sentence <- gsub('[[:punct:]]', "", sentence)
      sentence <- gsub('[[:cntrl:]]', "", sentence)
      sentence <- gsub('\d+', "", sentence)
      sentence <- tolower(sentence)
      word.list <- str_split(sentence, '\s+')
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
  
  pos <- scan('C:/___________/positive-words.txt', what='character', comment.char=';') #folder with positive dictionary
  neg <- scan('C:/___________/negative-words.txt', what='character', comment.char=';') #folder with negative dictionary
  pos.words <- c(pos, 'upgrade')
  neg.words <- c(neg, 'wtf', 'wait', 'waiting', 'epicfail')
  
  Dataset <- stack
  Dataset$text <- as.factor(Dataset$text)
  scores <- score.sentiment(Dataset$text, pos.words, neg.words, .progress='text')
  write.csv(scores, file=paste(searchterm, '_scores.csv'), row.names=TRUE) #save evaluation results into the file
  
  #total evaluation: positive / negative / neutral
  stat <- scores
  stat$created <- stack$created
  stat$created <- as.Date(stat$created)
  stat <- mutate(stat, tweet=ifelse(stat$score > 0, 'positive', ifelse(stat$score < 0, 'negative', 'neutral')))
  by.tweet <- group_by(stat, tweet, created)
  by.tweet <- summarise(by.tweet, number=n())
  write.csv(by.tweet, file=paste(searchterm, '_opin.csv'), row.names=TRUE)
  
  #create chart
  ggplot(by.tweet, aes(created, number)) + geom_line(aes(group=tweet, color=tweet), size=2) +
    geom_point(aes(group=tweet, color=tweet), size=4) +
    theme(text = element_text(size=18), axis.text.x = element_text(angle=90, vjust=1)) +
    #stat_summary(fun.y = 'sum', fun.ymin='sum', fun.ymax='sum', colour = 'yellow', size=2, geom = 'line') +
    ggtitle(searchterm)
  
  ggsave(file=paste(searchterm, '_plot.jpeg'))
  
}

search("Jokowi") #enter keyword