
loans = read.csv("loans.csv")

str(loans)
summary(loans)

table(loans$not.fully.paid)
(1533) / 9578

missing = subset(loans, is.na(log.annual.inc) | is.na(days.with.cr.line) | is.na(revol.util) | is.na(inq.last.6mths) | is.na(delinq.2yrs) | is.na(pub.rec))
nrow(missing)
table(missing$not.fully.paid)

# multiple imputation
library(mice)
set.seed(144)
vars.for.imputation = setdiff(names(loans), "not.fully.paid")
imputed = complete(mice(loans[vars.for.imputation]))
# We predicted missing variable values using 
# the available independent variables for each observation.

library(caTools)
set.seed(144)
split = sample.split(loans$not.fully.paid, SplitRatio = 0.7)
train = subset(loans, split == TRUE)
test = subset(loans, split == FALSE)

model = glm(not.fully.paid ~ ., data=train, family=binomial)
summary(model)

# 2.2
(700 - 710) * -9.308e-03
exp(700 * -9.308e-03) / exp(710 * -9.308e-03)

# 2.3

predTest = predict(model, type="response", newdata=test)
test$predicted.risk = predTest
table(test$not.fully.paid, predTest >= 0.5)
table(test$not.fully.paid)

(2387 + 3) / (2387 + 3 + 12 + 455)
(2413) / (2413 + 460) # baseline model

# 2.4 get AUC

library(ROCR)
ROCpredTest = prediction(predTest, test$not.fully.paid)
auc = as.numeric(performance(ROCpredTest, "auc")@y.values)
auc

# smart baseline

str(loans)
# bivariate model
model2 = glm(not.fully.paid ~ int.rate, data=train, family=binomial)
predTest2 = predict(model2, type="response", newdata=test)
max(predTest2)

table(test$not.fully.paid, predTest2 >= 0.5)

# auc
ROCpredTest2 = prediction(predTest2, test$not.fully.paid)
auc = as.numeric(performance(ROCpredTest2, "auc")@y.values)
auc

10 * exp(0.06 * 3)

# 5.1
test$profit = exp(test$int.rate*3) - 1
test$profit[test$not.fully.paid == 1] = -1
max(test$profit) * 10

# 6.1
highRisk = subset(test, int.rate >= 0.15)
mean(highRisk$profit)
summary(highRisk$not.fully.paid)
mean(test$profit)
summary(test$not.fully.paid)

# 6.2
cutoff = sort(highRisk$predicted.risk, decreasing = FALSE)[100]
selectedLoans = subset(highRisk, predicted.risk <= cutoff)

sum(selectedLoans$profit)
table(selectedLoans$not.fully.paid)

