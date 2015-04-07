
stevens = read.csv("stevens.csv")
str(stevens)

# spilt dataset
library(caTools)
set.seed(3000)
split = sample.split(stevens$Reverse, SplitRatio=0.7)
train = subset(stevens, split == TRUE)
test = subset(stevens, split == FALSE)

# CART
install.packages("rpart")
install.packages("rpart.plot")
library(rpart)
library(rpart.plot)

stevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=train, method="class", minbucket=25)
prp(stevensTree)
predictStevens = predict(stevensTree, newdata=test, type="class")
table(test$Reverse, predictStevens)

# ROC
library(ROCR)
predictROC = predict(stevensTree, newdata=test)
predictROC # you can see buckets
pred = prediction(predictROC[, 2], test$Reverse)
perf = performance(pred, "tpr", "fpr")
plot(perf)

# AUC
AUC = as.numeric(performance(pred, "auc")@y.values)
AUC

# Random Forest
install.packages("randomForest")
library(randomForest)

set.seed(200)
# random forest requires factor (dependent) variable.
train$Reverse = as.factor(train$Reverse)
test$Reverse = as.factor(test$Reverse)
stevenForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=train, nodesize=25, ntree=200)
predictForest = predict(stevenForest, newdata=test)
table(test$Reverse, predictForest) # confusion matrix
(44 + 76) / (44 + 33 + 17 + 76) 

# cross-validation
install.packages("caret")
library(caret)
install.packages("e1071")
library(e1071)

numFolds = trainControl(method="cv", number=10) # cross-validation
cpGrid = expand.grid(.cp=seq(0.01, 0.5, 0.01))
train(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=train, method="rpart", trControl=numFolds, tuneGrid=cpGrid)

stevensTreeCV = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=train, method="class", cp=0.18)
predictCV = predict(stevensTreeCV, newdata=test, type="class")
table(test$Reverse, predictCV)
(59 + 64) / (59 + 64 + 18 + 29) # 0.723
prp(stevensTreeCV) # simple is the best.
