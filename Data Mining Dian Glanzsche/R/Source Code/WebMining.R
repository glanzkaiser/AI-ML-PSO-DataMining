library(tm.plugin.webmining)
library(devtools)

googlefinance <- WebCorpus(GoogleFinanceSource("NASDAQ:MSFT"))
googlenews <- WebCorpus(GoogleNewsSource("Microsoft"))
nytimes <- WebCorpus(NYTimesSource("Microsoft", appid = "<nytimes_appid>"))
reutersnews <- WebCorpus(ReutersNewsSource("businessNews"))
yahoofinance <- WebCorpus(YahooFinanceSource("MSFT"))
yahooinplay <- WebCorpus(YahooInplaySource())
yahoonews <- WebCorpus(YahooNewsSource("Ekonomi"), language = "ID")
liberation <- WebCorpus(LiberationSource("latest"), language = "ID")


data.frame(text = sapply(googlefinance, as.character), stringsAsFactors = FALSE)
news.df <- data.frame(googlefinance)
View(googlefinance)
View(news.df)
