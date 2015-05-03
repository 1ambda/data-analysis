# libraries
library(ggplot2)
library(caTools)
library(ROCR)
library(tm)
library(SnowballC)
library(rpart)
library(rpart.plot)
library(randomForest)

Sys.setlocale("LC_ALL", "C")

blogsTrain = read.csv("NYTimesBlogTrain.csv") # 6532 row
blogsTest  = read.csv("NYTimesBlogTest.csv")  # 1870 row


# 1. headline

corpus = Corpus(VectorSource(blogsTrain$Headline))
corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords("english"))
corpus = tm_map(corpus, stemDocument)

# 8048 terms
dtm = DocumentTermMatrix(corpus)

# 490 terms, 0.998
# 313 terms, 0.997
# 203 terms, 0.996
# 153 terms, 0.995
sdtm = removeSparseTerms(dtm, sparse=0.995)
terms = as.data.frame(as.matrix(sdtm))
colnames(terms) = make.names(colnames(terms)) # makes syntactically valid name for random forest
train = terms[1:6532,] # remove test from frame
test = terms[6533:8402, ]
train$Popular = blogsTrain$Popular

## submission 1: CART
CART = rpart(Popular ~ ., data=train, method="class")
prp(CART) # if puzzl < 1.5, then predict 0, else 1

predictCART = predict(CART, newdata=test, type="class")
table(predictCART)
submission2 = data.frame(UniqueID=blogsTest$UniqueID, Probability1=predictCART)

write.csv(submission2, file="submissions/submission2.csv", row.names=FALSE)

## submission 2
forest = randomForest(Popular ~ ., data=train)
predictForest = predict(forest, newdata=test)

predictForest[predictForest < 0] = 0.5

submission3 = data.frame(UniqueID=blogsTest$UniqueID, Probability1=predictForest)

write.csv(submission3, file="submissions/submission3.csv", row.names=FALSE)
