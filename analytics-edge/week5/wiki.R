wiki = read.csv("wiki.csv", stringsAsFactors=FALSE)
wiki$Vandal = as.factor(wiki$Vandal)
str(wiki)

# 1.1
table(wiki$Vandal)

# build a model
library(tm)
corpusAdded = Corpus(VectorSource(wiki$Added))
corpusAdded = tm_map(corpusAdded, removeWords, stopwords("english"))
corpusAdded = tm_map(corpusAdded, stemDocument)
dtmAdded = DocumentTermMatrix(corpusAdded)

# keep only terms that appears in 0.3% or more of the revisions
sparseAdded = removeSparseTerms(dtmAdded, 0.997)
wordsAdded = as.data.frame(as.matrix(sparseAdded))
# prepend all the words with the letter A
colnames(wordsAdded) = paste("A", colnames(wordsAdded))

corpusRemoved = Corpus(VectorSource(wiki$Removed))
corpusRemoved = tm_map(corpusRemoved, removeWords, stopwords("english"))
corpusRemoved = tm_map(corpusRemoved, stemDocument)
dtmRemoved = DocumentTermMatrix(corpusRemoved)

sparseRemoved = removeSparseTerms(dtmRemoved, 0.997)
wordsRemoved = as.data.frame(as.matrix(sparseRemoved))
colnames(wordsRemoved) = paste("R", colnames(wordsRemoved))
ncol(wordsRemoved) # 162 terms

wikiWords = cbind(wordsAdded, wordsRemoved)
wikiWords$Vandal = wiki$Vandal

# spilt data
library(caTools)
set.seed(123)
split = sample.split(wikiWords$Vandal, SplitRatio=0.7)
train = subset(wikiWords, split == TRUE)
test  = subset(wikiWords, split == FALSE)

table(wikiWords$Vandal)
baseline = (2061) / nrow(wikiWords) # 0.5317337

# CART
library(rpart)
library(rpart.plot)
wikiCART = rpart(Vandal ~ ., data=train, method="class")
# if type="class" when making prediction
# the output will automatically use a threshold of 0.5
pred = predict(wikiCART, newdata=test, type="class")
cfMatrix = table(test$Vandal, pred)
accuracy = sum(diag(cfMatrix)) / sum(cfMatrix) # 0.5417025
prp(wikiCART)

# The key class of words: website addresses(URL)
# The presence of a web address is a sign of vandalism
wikiWords2 = wikiWords
wikiWords2$HTTP = ifelse(grepl("http", wiki$Added, fixed=TRUE), 1, 0)
table(wikiWords2$HTTP)
train2 = subset(wikiWords2, split == TRUE)
test2  = subset(wikiWords2, split == FALSE)

# CART
wikiCART2 = rpart(Vandal ~ ., data=train2, method="class")
pred2 = predict(wikiCART2, newdata=test2, type="class")
cfMatrix2 = table(test2$Vandal, pred2)
accuracy2 = sum(diag(cfMatrix2)) / sum(cfMatrix2) # 0.5726569

# Another possibility is, # of words added and removed predictive
wikiWords2$NumWordsAdded   = rowSums(as.matrix(dtmAdded))
wikiWords2$NumWordsRemoved = rowSums(as.matrix(dtmRemoved))
mean(wikiWords2$NumWordsAdded) # 4.050052

train3 = subset(wikiWords2, split == TRUE)
test3  = subset(wikiWords2, split == FALSE)
wikiCART3 = rpart(Vandal ~ ., data=train3, method="class")
pred3 = predict(wikiCART3, newdata=test3, type="class")
cfMatrix3 = table(test3$Vandal, pred3)
accuracy3 = sum(diag(cfMatrix3)) / sum(cfMatrix3) # 0.6552021

wikiWords3 = wikiWords2
wikiWords3$Minor = wiki$Minor
wikiWords3$Loggedin = wiki$Loggedin
train4 = subset(wikiWords3, split == TRUE)
test4  = subset(wikiWords3, split == FALSE)
wikiCART4 = rpart(Vandal ~ ., data=train4, method="class")
pred4 = predict(wikiCART4, newdata=test4, type="class")
cfMatrix4 = table(test4$Vandal, pred4)
accuracy4 = sum(diag(cfMatrix4)) / sum(cfMatrix4) # 0.7188306
prp(wikiCART4)
