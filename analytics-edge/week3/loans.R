
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
loans.predicted.risk = predTest
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



