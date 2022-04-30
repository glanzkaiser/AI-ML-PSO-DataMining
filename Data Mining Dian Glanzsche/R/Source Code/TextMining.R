#init
libs <- c("tm","plyr","class")
lapply(libs, require, character.only = TRUE)

options(stringsAsFactors = FALSE)

# Set parameters
candidates <- c("romney","obama")
pathname <- "C:/Users/Dian Putri Indah M/Documents/Data Mining/Speeches"

#clean text
CleanCorpus <- function(corpus) {
  corpus.tmp <- tm_map(corpus, removePunctuation)
  corpus.tmp <- tm_map(corpus.tmp, stripWhitespace)
  corpus.tmp <- tm_map(corpus.tmp, tolower)
  corpus.tmp <- tm_map(corpus.tmp, removeWords, stopwords("english"))
  return(corpus.tmp)
}

#build TDM
generateTDM <- function(cand, path){
  s.dir <-sprintf("%s%s", path, cand)
  s.cor <- Corpus(DirSource(directory = s.dir, encoding="ANSI"))
  s.cor.cl <-cleanCorpus(s.cor)
  s.tdm <- TermDocumentMatrix(s.cor.cl)
  
  s.tdm <- removeSparseTerms(s.tdm, 0.7)
  result <- list(name = cand, tdm = s.tdm)
}

tdm <- lapply(candidates, generateTDM, path = pathname)

#attach name

#stack