
ebay = read.csv("ebay.csv", stringsAsFactor=FALSE)
str(ebay)

# 2.1
table(ebay$sold)
799 / nrow(ebay)

# 2.2
summary(ebay)

# 2.3
sort(table(ebay$size))

# 2.4 converting variables to factors
ebay$sold      = as.factor(ebay$sold)
ebay$heel      = as.factor(ebay$heel)
ebay$style     = as.factor(ebay$style)
ebay$color     = as.factor(ebay$color)
ebay$material  = as.factor(ebay$material)
ebay$condition = as.factor(ebay$condition)
str(ebay)

# 2.5 spliting data

set.seed(144)
library(caTools)
split = sample.split(ebay$sold, SplitRatio = 0.7)
ebayTrain = subset(ebay, split == TRUE)
ebayTest  = subset(ebay, split == FALSE)

# 2.8 logistic regression

glmEbay = glm(sold ~ biddable + startprice + condition + heel + style + color + material, data=ebayTrain, family=binomial)
summary(glmEbay)

# 2.9 obtaining test set prediction 

glmPred  = predict(glmEbay, newdata = ebayTest, type="response")
cfMatrix = table(ebayTest$sold, glmPred > 0.5)

# 2.10 AUC

library(ROCR)
rocPred = prediction(glmPred, ebayTest$sold)
AUC = as.numeric(performance(rocPred, "auc")@y.values)

# 2.11 plot AUC 

rocPerf = performance(rocPred, "tpr", "fpr")
plot(rocPerf, colorize=TRUE, print.cutoffs.at = seq(0, 1, 0.1), text.ajd=c(-0.2, 1.7))

# 2.15 cross-validation

set.seed(144)
library(caret)

numFolds = trainControl(method="cv", number = 10)
cpGrid = expand.grid(.cp=seq(0.001, 0.05, 0.001))
train(sold ~ biddable + startprice + condition + heel + style + color + material, data=ebayTrain, method="rpart", trControl = numFolds, tuneGrid=cpGrid)

# 2.16 train CART model

cartEbay = rpart(sold ~ biddable + startprice + condition + heel + style + color + material, data=ebayTrain, method="class", cp=0.004)
summary(cartEbay)

# 2.17 building a corpus

library(tm)
corpus = Corpus(VectorSource(ebay$description))
corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus, content_transformer(tolower)) # corpus[[1]]
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords("english"))
corpus = tm_map(corpus, stemDocument)
dtm    = DocumentTermMatrix(corpus)

# 2.18

sparceDtm = removeSparseTerms(dtm, 0.90)
descriptionText = as.data.frame(as.matrix(sparceDtm))

# 2.19

sort(colSums(descriptionText))

# 2.20 adding `D` in front of all the variable names
names(descriptionText) = paste0("D", names(descriptionText))

descriptionText$sold = ebay$sold
descriptionText$biddable = ebay$biddable
descriptionText$startprice = ebay$startprice
descriptionText$condition = ebay$condition
descriptionText$heel = ebay$heel
descriptionText$style = ebay$style
descriptionText$color = ebay$color
descriptionText$material = ebay$material

# 2.21

textTrain = subset(descriptionText, split == TRUE)
textTest  = subset(descriptionText, split == FALSE) 

glmText = glm(sold ~ ., data=textTrain, family=binomial)
summary(glmText)

# 2.22 auc

textTrainPred = predict(glmText, data=textTrain, type="response")
rocTrainPred  = prediction(textTrainPred, textTrain$sold)
aucTrain      = as.numeric(performance(rocTrainPred, "auc")@y.values)

textTestPred  = predict(glmText, newdata=textTest, type="response")
rocTestPred   = prediction(textTestPred, textTest$sold)
aucTest       = as.numeric(performance(rocTestPred, "auc")@y.values)

# 2.23 interpretation model

