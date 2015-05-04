# libraries
library(ggplot2)
library(caTools)
library(ROCR)
library(rpart)
library(caret)
library(e1071)
library(randomForest)


# training
train = read.csv("NYTimesBlogTrain.csv")

train$PubDate = strptime(train$PubDate, format="%Y-%m-%d %H:%M:%S")
train$PubWeekday = weekdays(train$PubDate)
train$PubHour = as.factor(train$PubDate$hour)

# prediction
test = read.csv("NYTimesBlogTest.csv")
test$PubDate = strptime(test$PubDate, format="%Y-%m-%d %H:%M:%S")
test$PubWeekday = weekdays(test$PubDate)
test$PubHour = as.factor(test$PubDate$hour)


## logistic regression 
log = glm(Popular ~ NewsDesk + SectionName + PubHour + PubWeekday, data=train, family=binomial)
pred1 = predict(log, newdata=test, type="response")

## CART with k-fold
numFolds = trainControl(method="cv", number=10)
cpGrid = expand.grid(.cp=seq(0.01, 0.5, 0.01))
train(Popular ~ NewsDesk + SectionName + PubHour + PubWeekday, data=train, method="rpart", trControl=numFolds, tuneGrid=cpGrid)

cart = rpart(Popular ~ NewsDesk + SectionName + PubHour + PubWeekday, data=train, method="class", cp=0.02) # result of k-fold
pred2 = predict(cart, newdata=test)[, 2]

cart = rpart(Popular ~ NewsDesk + SectionName + SubsectionName, data=train, method="class", cp=0.02) # result of k-fold
pred3 = predict(cart, newdata=test)[, 2]

# submission
result1 = data.frame(UniqueID = test$UniqueID, Probability1 = pred1)
write.csv(result, file="submissions/submission5.csv", row.names=FALSE)

result2 = data.frame(UniqueID = test$UniqueID, Probability1 = pred2)
write.csv(result, file="submissions/submission6.csv", row.names=FALSE)

result3 = data.frame(UniqueID = test$UniqueID, Probability1 = pred3)
write.csv(result, file="submissions/submission7.csv", row.names=FALSE)

