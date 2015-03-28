
framingham = read.csv("framingham.csv")
str(framingham)

# split data 
library(caTools)
set.seed(1000)
split = sample.split(framingham$TenYearCHD, SplitRatio=0.65)
train = subset(framingham, split == TRUE)
test = subset(framingham, split == FALSE)

# logistic regression using all independent varaibles
log = glm(TenYearCHD ~ ., data=train, family=binomial)
summary(log)
predictTest = predict(log, type="response", newdata=test)
table(test$TenYearCHD, predictTest > 0.5)

(1094 + 11) / (1094 + 9 + 189 + 11) # model accuracy
(1094 + 9) / (1094 + 9 + 189 + 11) # baseline method: always predict 0

(11) / (11 + 187) # sensitivity
(1069) / (1069 + 5) # specificity

# get AUC
ROCpred = prediction(predictTest, test$TenYearCHD)
auc = as.numeric(performance(ROCpred, "auc")@y.values)



# model rarely predict 10-year CHD risk above 50%. 
# accuracy very near a baseline of always predicting no CHD
# model can differentiate low-risk from high-risk 





