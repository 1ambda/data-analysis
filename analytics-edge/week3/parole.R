
parole = read.csv("parole.csv")
str(parole)
summary(parole)

table(parole$violator)

# convert variable into factor
parole$state = factor(parole$state)
levels(parole$state) = c("Other", "Kentucky", "Louisiana", "Virginia")
parole$crime = factor(parole$crime)
levels(parole$crime) = c("any other", "larceny", "drug-related", "driving-related")

summary(parole$crime)
summary(parole$state)

# split data
set.seed(144)
library(caTools)

split = sample.split(parole$violator, SplitRatio = 0.7)

train = subset(parole, split == TRUE)
test = subset(parole, split == FALSE)

model = glm(violator ~ ., data=train, family=binomial)
summary(model)

# 4.2 
# If we have a coefficient c for a variable,
# then that means the odds are multiplied by e^c 
# for a unit increase in the variable.
# Our model predicts that a parolee who committed multiple offenses has 5.01 times
# higher odds of being a violator 
# than a parolee who did not commit multiple offenses but is otherwise identical.

# 4.3
predCase <- predict(model, type="response", newdata=data.frame(male=1, race=1, age=50, state="Other", time.served=3, max.sentence=12, multiple.offenses=0, crime="larceny"))
odds = predCase / (1 - predCase)

# 5.1
predTest = predict(model, type="response", newdata=test)
which.max(predTest)

# 5.2
table(test$violator, predTest >= 0.5)
(12) / (11+12) # sensitivity
(167) / (167 + 12) # specificity
(167 + 12) / (167 + 12 + 12 + 11) # accuracy

table(test$violator)
(179) / (179 + 23)

# AUC
library(ROCR)
predTrain = predict(model, type="response", data=train)
ROCpredTrain = prediction(predTrain, train$violator)
ROCpredTest = prediction(predTest, test$violator)
auc = as.numeric(performance(ROCpredTest, "auc")@y.values)
auc


