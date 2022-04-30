library(quantmod)

getNews <- function(symbol, number){
    
    # Warn about length
    if (number>300) {
        warning("May only get 300 stories from google")
    }
    
    # load libraries
    require(XML); require(plyr); require(stringr); require(lubridate);
    require(xts); require(RDSTK)
    
    # construct url to news feed rss and encode it correctly
    url.b1 = 'http://www.google.com/finance/company_news?q='
    
    url    = paste(url.b1, symbol, '&output=rss', "&start=", 1,
             "&num=", number, sep = '')
    
    url    = URLencode(url)
    
    # parse xml tree, get item nodes, extract data and return data frame
    doc   = xmlTreeParse(url, useInternalNodes = TRUE)
    nodes = getNodeSet(doc, "//item")
    mydf  = ldply(nodes, as.data.frame(xmlToList))
    
    # clean up names of data frame
    names(mydf) = str_replace_all(names(mydf), "value\\.", "")
    
    # convert pubDate to date-time object and convert time zone
    pubDate = strptime(mydf$pubDate, 
                       format = '%a, %d %b %Y %H:%M:%S', tz = 'GMT')
    pubDate = with_tz(pubDate, tz = 'America/New_york')
    mydf$pubDate = NULL
    
    #Parse the description field
    mydf$description <- as.character(mydf$description)
    parseDescription <- function(x) {
        out <- html2text(x)$text
        out <- strsplit(out,'\n|--')[[1]]
        
        #Find Lead
        TextLength <- sapply(out,nchar)
        Lead <- out[TextLength==max(TextLength)]
        
        #Find Site
        Site <- out[3]
        
        #Return cleaned fields
        out <- c(Site,Lead)
        names(out) <- c('Site','Lead')
        out
    }
    description <- lapply(mydf$description,parseDescription)
    description <- do.call(rbind,description)
    mydf <- cbind(mydf,description)
    
    #Format as XTS object
    mydf = xts(mydf,order.by=pubDate)
    
    # drop Extra attributes that we don't use yet
    mydf$guid.text = mydf$guid..attrs = mydf$description = mydf$link = NULL
    return(mydf) 
    
}



news <- getNews('IATA',30)


getNews2 <- function(symbol, number){
    
    # load libraries
    require(XML); require(plyr); require(stringr); require(lubridate);  
    
    # construct url to news feed rss and encode it correctly
    url.b1 = 'http://www.google.com/finance/company_news?q='
    url    = paste(url.b1, symbol, '&output=rss', "&start=", 1,
                   "&num=", number, sep = '')
    url    = URLencode(url)
    
    # parse xml tree, get item nodes, extract data and return data frame
    doc   = xmlTreeParse(url, useInternalNodes = T);
    nodes = getNodeSet(doc, "//item");
    mydf  = ldply(nodes, as.data.frame(xmlToList))
    
    # clean up names of data frame
    names(mydf) = str_replace_all(names(mydf), "value\\.", "")
    
    # convert pubDate to date-time object and convert time zone
    mydf$pubDate = strptime(mydf$pubDate, 
                            format = '%a, %d %b %Y %H:%M:%S', tz = 'GMT')
    mydf$pubDate = with_tz(mydf$pubDate, tz = 'America/New_york')
    
    # drop guid.text and guid..attrs
    mydf$guid.text = mydf$guid..attrs = NULL
    
    return(mydf)    
}

# Convert xts to csv
write.csv(news, file='newsdata.csv', row.names=FALSE, fileEncoding='UTF-8')

#Load the lexicon / positive and negative Words
pos.words <- scan('C:/Users/Dian Putri Indah M/Documents/Data Mining/R/positive.txt', what='character', comment.char=';')
neg.words <- scan('C:/Users/Dian Putri Indah M/Documents/Data Mining/R/negative.txt', what='character', comment.char=';')
pos.words <- c(pos.words, 'upgrade')

# tweets.df <- read.csv('data.csv') for Title
news$title <- as.factor(news$title)
sentiment.scores <- score.sentiment(news$title, pos.words, neg.words, .progress='text')
write.csv(sentiment.scores, file='newsscores.csv', row.names=TRUE, fileEncoding='UTF-8', quote=TRUE)

# Uncomment these for a histogram of general sentiment
hist.plot <- ggplot() + geom_histogram(data=sentiment.scores, aes(x=score))
hist.plot + theme_economist() + scale_colour_economist()

# Uncomment these for wordcloud
require(tm)
require(wordcloud)
require(RColorBrewer)
sentiment.scores$title <- encodeString(as.character(sentiment.scores$title))
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
png("wordcloud_news.png", width=1200,height=800)
wordcloud(ap.d$word,ap.d$freq, scale=c(8,.2),min.freq=2,
          max.words=150, random.order=FALSE, rot.per=.15, colors=pal2)
dev.off()
