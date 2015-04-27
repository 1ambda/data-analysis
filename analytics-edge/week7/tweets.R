tweets = read.csv("tweets.csv", stringsAsFactors=FALSE)
str(tweets)

library(tm)

corpus = Corpus(VectorSource(tweets$Tweet))
corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords("english"))
# to make word cloud readable, we do not stem
# corpus = tm_map(corpus, stemDocument)
dtm = DocumentTermMatrix(corpus)
allTweets = as.data.frame(as.matrix(dtm))

str(allTweets)

# 2.1
install.packages("wordcloud")
library(wordcloud)

# 2.2
colSums(allTweets)

# 2.3
wordcloud(colnames(allTweets), colSums(allTweets), scale=c(2, .25))

# 2.4

tweets = read.csv("tweets.csv", stringsAsFactors=FALSE)
corpus = Corpus(VectorSource(tweets$Tweet))
corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords("english"))
# remove `apple` since it's so frequent
corpus = tm_map(corpus, removeWords, c("apple"))
# to make word cloud readable, we do not stem
# corpus = tm_map(corpus, stemDocument)

dtm = DocumentTermMatrix(corpus)
allTweets = as.data.frame(as.matrix(dtm))

sort(colSums(allTweets))
wordcloud(colnames(allTweets), colSums(allTweets), scale=c(2, 0.25))

wordcloud(colnames(allTweets), colSums(allTweets), scale=c(2, 0.25), random.order=FALSE)

wordcloud(colnames(allTweets), colSums(allTweets), scale=c(2, 0.25), random.order=FALSE, rot.per=0.5)

# problem 4
install.packages("RColorBrewer")
library(RColorBrewer)

wordcloud(colnames(allTweets), colSums(allTweets), scale=c(2, 0.25), random.order=FALSE, rot.per=0.5)

# From ?brewer.pal we read that Accent and Set2 are both "qualitative palettes," which means color changes don't imply a change in magnitude (we can also see this in the output of display.brewer.all). As a result, the colors selected would not visually identify the least and most frequent words.

pal1 <- brewer.pal(9, "BuGn")
pal1 <- pal[-(1:2)]

pal2 = brewer.pal(9, "Blues")[-1:-4]
wordcloud(colnames(allTweets), colSums(allTweets), scale=c(2.5, 0.5), min.freq=3, max.words=150, random.order=FALSE, rot.per=0.5, colors=pal1)

# word cloud using negative tweets
str(tweets)

tweets1 = subset(tweets, Avg < 0)

corpus1 = Corpus(VectorSource(tweets1$Tweet))
corpus1 = tm_map(corpus1, PlainTextDocument)
corpus1 = tm_map(corpus1, content_transformer(tolower))
corpus1 = tm_map(corpus1, removePunctuation)
corpus1 = tm_map(corpus1, removeWords, stopwords("english"))
corpus = tm_map(corpus, removeWords, c("apple"))
dtm1 = DocumentTermMatrix(corpus1)
negativeTweets1 = as.data.frame(as.matrix(dtm1))

negativePal1 = brewer.pal(9, "Reds")[-1:-4]
wordcloud(colnames(negativeTweets1), colSums(negativeTweets1), scale=c(2.5, 0.5), min.freq=3, max.words=150, random.order=FALSE, rot.per=0.5, colors=negativePal1)

# more negative
tweets2 = subset(tweets, Avg < -1)

corpus2 = Corpus(VectorSource(tweets2$Tweet))
corpus2 = tm_map(corpus2, PlainTextDocument)
corpus2 = tm_map(corpus2, content_transformer(tolower))
corpus2 = tm_map(corpus2, removePunctuation)
corpus2 = tm_map(corpus2, removeWords, stopwords("english"))
corpus2 = tm_map(corpus2, removeWords, c("apple"))
dtm2 = DocumentTermMatrix(corpus2)
negativeTweets2 = as.data.frame(as.matrix(dtm2))

negativePal2 = brewer.pal(9, "Oranges")[-1:-4]
wordcloud(colnames(negativeTweets2), colSums(negativeTweets2), scale=c(2.5, 0.5), min.freq=3, max.words=150, random.order=FALSE, rot.per=0.5, colors=negativePal2)
