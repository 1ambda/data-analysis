
polling = read.csv("PollingData.csv")
str(polling)
summary(polling)
table(polling$Year)

## multiple imputation
install.packages("mice")
library(mice)

simple = polling[c("Rasmussen", "SurveyUSA", "PropR", "DiffCount")]
summary(simple)
set.seed(144)
imputed = complete(mice(simple))
summary(imputed)

polling$Rasmussen = imputed$Rasmussen
polling$SurveyUSA = imputed$SurveyUSA
summary(polling)

## split data into training and test set
train = subset(polling, Year == 2004 | Year == 2008)
test = subset(polling, Year == 2012)

# build baselind model
table(train$Republican)
table(sign(train$Rasmussen))
table(train$Republican, sign(train$Rasmussen))

# build a model
cor(train)
str(train) 
cor(train[c("Rasmussen", "SurveyUSA", "DiffCount", "PropR", "Republican")])

model1 = glm(Republican ~ PropR, data=train, family=binomial)
summary(model1)

pred1 = predict(model1, type="response")
table(train$Republican, pred1 >= 0.5)

## improve model
cor(train[c("Rasmussen", "SurveyUSA", "DiffCount", "PropR", "Republican")])
# add SurveyUSA and DiffCount. 
# Pairs which have small cor values can enhance our model more
model2 = glm(Republican ~ SurveyUSA + DiffCount, data=train, family=binomial)
summary(model2)
pred2 = predict(model2, type="response")
table(train$Republican, pred2 >= 0.5)

## evaluate model
table(test$Republican, sign(test$Rasmussen)) # baseline

pred2Test = predict(model2, type="response", newdata=test)
table(test$Republican, pred2Test >= 0.5)

subset(test, pred2Test >= 0.5 & Republican == 0)

