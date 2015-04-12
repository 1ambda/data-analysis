Sys.setlocale("LC_ALL", "C")
tweets = read.csv("tweets.csv")
str(tweets)

tweets$Negative = as.factor(tweets$Avg <= -1)
table(tweets$Negative)

install.packages("tm")
library(tm)
install.packages("SnowballC")
library(SnowballC)

corpus = Corpus(VectorSource(tweets$Tweet))
corpus 
corpus[[1]]
tolower("APPLE")

# remove irregularities
corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus, content_transformer(tolower))
corpus[[1]]
# remove punctuation
corpus = tm_map(corpus, removePunctuation)
corpus[[1]]
# remove stopword
stopwords("english")[1:10]
corpus = tm_map(corpus, removeWords, c("apple", stopwords("english")))
corpus[[1]]
# stemming
corpus = tm_map(corpus, stemDocument)
corpus[[1]]

# bag of words
# extract freq from words
frequencies = DocumentTermMatrix(corpus)
frequencies

# document 1000:1005, words 505:515
inspect(frequencies[1000:1005, 505:515])

# find frequent terms.
findFreqTerms(frequencies, lowfreq=20)

# remove some sparse terms
# only keep terms that appear in 0.5% or more of the tweets
sparse = removeSparseTerms(frequencies, sparse=0.995)
sparse # only 309 terms

tweetsSparse = as.data.frame(as.matrix(sparse))
str(tweetsSparse)
# add `X` into some variables which startwith numbers
colnames(tweetsSparse) = make.names(colnames(tweetsSparse))
str(tweetsSparse)

tweetsSparse$Negative = tweets$Negative
str(tweetsSparse)

# spilt data into training, test set
library(caTools)
set.seed(123)

split = sample.split(tweetsSparse$Negative, SplitRatio=0.7)
train = subset(tweetsSparse, split==TRUE)
test = subset(tweetsSparse, split==FALSE)

# CART 
library(rpart)
library(rpart.plot)

twCART = rpart(Negative ~ ., data=train, method="class")
prp(twCART)
predictTwCART = predict(twCART, newdata=test, type="class")

# confusion matrix
cfMatrix = table(test$Negative, predictTwCART)
# accuracy: 0.8788
sum(diag(cfMatrix)) / sum(cfMatrix)

# baseline: 0.8450
baselineTable = table(test$Negative)
(300) / sum(baselineTable)

# random forest
library(randomForest)
set.seed(123)
twForest = randomForest(Negative ~ ., data=train)
predictTwForest = predict(twForest, newdata=test)
cfMatrix2 = table(test$Negative, predictTwForest)
# accuracy: 0.8845
sum(diag(cfMatrix2)) / sum(cfMatrix2)

# logistic regression
twLog = glm(Negative ~ ., data=train, family = "binomial")
predictTwLog = predict(twLog, newdata=test, type="response")

# accuracy: 0.80
logCfMatrix = table(test$Negative, predictTwLog > 0.5)
sum(diag(logCfMatrix)) / sum(logCfMatrix)
