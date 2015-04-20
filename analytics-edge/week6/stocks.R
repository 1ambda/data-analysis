
# PREDICTING STOCK RETURNS

stocks = read.csv("StocksCluster.csv")
str(stocks)

## Q 1.2
table(stocks$PositiveDec) / nrow(stocks) # or simply use 'mean' 

## Q 1.3
sort(cor(stocks))

## Q 1.4
summary(stocks)

## Q 2.1
set.seed(144)
library(caTools)
split = sample.split(stocks$PositiveDec, SplitRatio = 0.7)
train = subset(stocks, split == TRUE)
test  = subset(stocks, split == FALSE)

stocksLog = glm(PositiveDec ~ ., data=train, family=binomial)
predLogTrain = predict(stocksLog, type="response")
cfMatrixLogTrain = table(train$PositiveDec, predLogTrain > 0.5)
accuracyLogTrain = sum(diag(cfMatrixLogTrain)) / sum(cfMatrixLogTrain)

## 2.2
predLogTest = predict(stocksLog, newdata=test, type="response")
cfMatrixLogTest = table(test$PositiveDec, predLogTest > 0.5)
accuracyLogTest = sum(diag(cfMatrixLogTest)) / sum(cfMatrixLogTest)

## 2.3: baseline
mean(test$PositiveDec)

## 3.1 clustering

# Needing to know the dependent variable value to assign an observation
# to a cluster defeats the purpose of the methodology
cTrain = train
cTrain$PositiveDec = NULL
cTest = test
cTest$PositiveDec = NULL

## 3.2
library(caret)
preproc = preProcess(cTrain)
normTrain = predict(preproc, cTrain)
normTest  = predict(preproc, cTest)

mean(normTrain$ReturnJan)
mean(normTest$ReturnJan)

## 3.3
# Since normTest was constructed by subtracting by the mean `ReturnJan` value
# from the training set,
# this explains why the mean value of RegurnJan is slightly negative in normTest

## 3.4
set.seed(144)
k = 3
km = kmeans(normTrain, centers=3)
kClustersTrain = km$cluster

table(kClustersTrain)

## 3.5 prediction using clusters (flexclust package)
library(flexclust)
km.kcca = as.kcca(km, normTrain) # K-Centroids Cluster Analysis
clusterTrain = predict(km.kcca)
clusterTest  = predict(km.kcca, newdata=normTest)

table(clusterTest)

## Q 4.1
stockTrain1 = subset(train, clusterTrain == 1)
stockTrain2 = subset(train, clusterTrain == 2)
stockTrain3 = subset(train, clusterTrain == 3)
stockTest1 = subset(test, clusterTest == 1)
stockTest2 = subset(test, clusterTest == 2)
stockTest3 = subset(test, clusterTest == 3)

tapply(train$PositiveDec, clusterTrain, mean)
tapply(test$PositiveDec, clusterTest, mean)

## Q 4.2
stockLogModel1 = glm(PositiveDec ~ ., data=stockTrain1, family="binomial")
stockLogModel2 = glm(PositiveDec ~ ., data=stockTrain2, family="binomial")
stockLogModel3 = glm(PositiveDec ~ ., data=stockTrain3, family="binomial")

summary(stockLogModel1)
# + Jan, Mar, Apr, May, July, Aug, Sep, Oct
# - Feb, Nov, June

summary(stockLogModel2)
# + Jan, Feb, Apr, May, June, July, Sep, 
# - Mar, Aug, Oct, Nov

summary(stockLogModel3)
# + Mar, Apr, May, June, July, Aug, Sep, Oct
# - Jan, Feb, Nov

## Q 4.3
predTest1 = predict(stockLogModel1, newdata=stockTest1, type="response")
predTest2 = predict(stockLogModel2, newdata=stockTest2, type="response")
predTest3 = predict(stockLogModel3, newdata=stockTest3, type="response")

cfMatrix1 = table(stockTest1$PositiveDec, predTest1 > 0.5)
cfMatrix2 = table(stockTest2$PositiveDec, predTest2 > 0.5)
cfMatrix3 = table(stockTest3$PositiveDec, predTest3 > 0.5)

accuracy1 = sum(diag(cfMatrix1)) / sum(cfMatrix1) # 0.6194
accuracy2 = sum(diag(cfMatrix2)) / sum(cfMatrix2) # 0.5504
accuracy3 = sum(diag(cfMatrix3)) / sum(cfMatrix3) # 0.6458

## 4.4
AllPredictions = c(predTest1, predTest2, predTest3)
AllOutcomes    = c(stockTest1$PositiveDec, stockTest2$PositiveDec, stockTest3$PositiveDec)

cfMatrixAll = table(AllOutcomes, AllPredictions > 0.5)
OverAllAccuracy = sum(diag(cfMatrixAll)) / sum(cfMatrixAll)
OverAllAccuracy # 0.5788716

# baseline : 0.5460564
# only logistic reg: 0.5670697

# summary: we can improve our logistic regression model with clustering
