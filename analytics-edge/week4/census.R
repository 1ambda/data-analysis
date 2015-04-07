
census = read.csv("census.csv")
str(census)

# logistic regression
library(caTools)
set.seed(2000)
split1 = sample.split(census$over50k, SplitRatio=0.6)
train1 = subset(census, split1 == TRUE)
test1 =  subset(census, split1 == FALSE)

log1 = glm(over50k ~ . , data=train1, family=binomial)
summary(log1)

# model accuracy
predLog1 = predict(log1, newdata=test1, type="response")
sum(diag(table(test1$over50k, predLog1 >= 0.5))) / nrow(test1) 

# baseline accuacy
table(test1$over50k)
9713 / nrow(test1)

# AUC
library(ROCR)
ROCpredLog1 = prediction(predLog1, test1$over50k)
auc = as.numeric(performance(ROCpredLog1, "auc")@y.values)
auc

