
quality = read.csv("quality.csv")
str(quality)
summary(quality)
table(quality$PoorCare)

98/131 # baseline of our model

# randomly split data
install.packages("caTools")
library(caTools)

set.seed(88)
split = sample.split(quality$PoorCare, SplitRatio = 0.75) # 25% test data

qualityTrain = subset(quality, split == TRUE)
qualityTest = subset(quality, split == FALSE)

nrow(qualityTrain)
nrow(qualityTest)

qualityLog = glm(PoorCare ~ OfficeVisits + Narcotics, data=qualityTrain, family = binomial)
summary(qualityLog)
predictTrain = predict(qualityLog, type="response") # get prob
summary(predictTrain)

qualityLog2 = glm(PoorCare ~ StartedOnCombination + ProviderCount, data=qualityTrain, family = binomial)
summary(qualityLog2)
predictTrain2 = predict(qualityLog2, type="response") # get prob
tapply(predictTrain2, qualityTrain$PoorCare, mean)

## confusion matrix
table(qualityTrain$PoorCare, predictTrain > 0.5)

## ROC curve
install.packages("ROCR")
library(ROCR)
ROCpred = prediction(predictTrain, qualityTrain$PoorCare)
ROCperf = performance(ROCpred, "tpr", "fpr") # true, false positive rate
plot(ROCperf, colorize=TRUE, print.cutoffs.at= seq(0, 1, 0.1), text.adj= c(-0.2, 1.7))

predictTest = predict(qualityLog, type="response", newdata=qualityTest)
table(qualityTest$PoorCare, predictTest > 0.3)
ROCpredTest = prediction(predictTest, qualityTest$PoorCare)
auc = as.numeric(performance(ROCpredTest, "auc")@y.values)
auc
