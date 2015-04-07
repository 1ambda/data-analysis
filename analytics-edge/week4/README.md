## Tree

### CART

Classification and Regression Tree is more interpretable than Logistic Regression.

```R
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
```

### Random Forest

**Random Forest** designed to improve prediction accuracy of CART. But makes model less interpretable

Random Forest technique builds many trees

- Each tree can split on only a random subset of the variables
- Each tree is built from a bagged / bootstrapped sample of the data
- Each tree sees different set of variables / data, they are called "forest"

### Random Forest Parameters

- `nodesize`: min number of observations in a subset. Smaller nodesize may take longer in R
- `ntree`: number of trees. Shouldn't be too small, since bagging procedure may miss observations. Of course, more trees take longer to build

### Random Forest Example

```R
# random forest requires factor (dependent) variable. This line won't run
stevenForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=train, nodesize=25, ntree=200)
train$Reverse = as.factor(train$Reverse)
test$Reverse = as.factor(test$Reverse)
stevenForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=train, nodesize=25, ntree=200)
predictForest = predict(stevenForest, newdata=test)
table(test$Reverse, predictForest) # confusion matrix
(40 + 74) / (40 + 37 + 74 + 19) # accuracy
```

Random Forest has a random component. You may have gotten a different confusion matrix.

### Parameter Selection

In CART, the value of `minbucket` can affect the models' out-of-sample accuracy. How should we set this parameter? We can't use test performance. Since testing set should be used to test performance not generate a model.

Instead, We can use **K-fold Cross-Validation**.

![](http://scott.fortmann-roe.com/docs/docs/MeasuringError/crossvalidation.png)

([ref](http://scott.fortmann-roe.com/docs/MeasuringError.html))

In K-fold Cross Validation, We'll use a `cp` (complexity parameter). Like adjusted R sq and AIC, `cp` measures trade-off between model complexity and accuracy on the training set.

Smaller `cp` leads to a bigger tree (might overfit)

### AIC vs Adjusted R sq

[ref](http://www.researchgate.net/post/What_is_the_difference_between_adj_R_square_and_AIC_values_in_linear_regression)

> Adjusted R sq. is a measure of explained variance in the response variable by the predictors whereas AIC is a trade off between model goodness of fit and complexity that helps to reduce estimated information loss. R sq. is adjusted so that it can go up or down depending on whether the addition of another variable adds or does not add to the explanatory power of the model. But AIC does not necessarily change with the addition of a variable, it rather change with the predictors' composition and thus indicates the quality of the model fit in terms of data generating predictors. I would choose a regression model based on AIC and dispersion and thereby compute the R sq.

```R
install.packages("caret")
library(caret)
install.packages("e1071")
library(e1071)

numFolds = trainControl(method="cv", number=10) # cross-validation
cpGrid = expand.grid(.cp=seq(0.01, 0.5, 0.01))
train(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=train, method="rpart", trControl=numFolds, tuneGrid=cpGrid)
```

output:

```R
CART

396 samples
  8 predictor
  2 classes: '0', '1'

No pre-processing
Resampling: Cross-Validated (10 fold)

Summary of sample sizes: 357, 356, 357, 356, 356, 356, ...

Resampling results across tuning parameters:

  cp    Accuracy   Kappa         Accuracy SD  Kappa SD
  0.01  0.6285897   0.233297925  0.058119815  0.120865323
  0.02  0.6162179   0.216769252  0.071419993  0.146154587
  0.03  0.6162179   0.218723848  0.065325968  0.139895102
  0.04  0.6213462   0.229708696  0.068315979  0.146117800
  0.05  0.6442949   0.283737006  0.068681509  0.141289594
  0.06  0.6442949   0.283737006  0.068681509  0.141289594
  0.07  0.6442949   0.283737006  0.068681509  0.141289594
  0.08  0.6442949   0.283737006  0.068681509  0.141289594
  0.09  0.6442949   0.283737006  0.068681509  0.141289594
  0.10  0.6442949   0.283737006  0.068681509  0.141289594
  0.11  0.6442949   0.283737006  0.068681509  0.141289594
  0.12  0.6442949   0.283737006  0.068681509  0.141289594
  0.13  0.6442949   0.283737006  0.068681509  0.141289594
  0.14  0.6442949   0.283737006  0.068681509  0.141289594
  0.15  0.6442949   0.283737006  0.068681509  0.141289594
  0.16  0.6442949   0.283737006  0.068681509  0.141289594
  0.17  0.6442949   0.283737006  0.068681509  0.141289594
  0.18  0.6442949   0.283737006  0.068681509  0.141289594
  0.19  0.6442949   0.283737006  0.068681509  0.141289594
  0.20  0.6058333   0.192296419  0.062163294  0.147359593
  0.21  0.5908333   0.152296419  0.054547101  0.138752691
  0.22  0.5605769   0.067509783  0.039694449  0.114996641
  0.23  0.5403846  -0.002040816  0.015304277  0.006453628
  0.24  0.5403846  -0.002040816  0.015304277  0.006453628
  0.25  0.5403846  -0.002040816  0.015304277  0.006453628
  0.26  0.5453846   0.000000000  0.005958436  0.000000000
  0.27  0.5453846   0.000000000  0.005958436  0.000000000
  0.28  0.5453846   0.000000000  0.005958436  0.000000000
  0.29  0.5453846   0.000000000  0.005958436  0.000000000
  0.30  0.5453846   0.000000000  0.005958436  0.000000000
  0.31  0.5453846   0.000000000  0.005958436  0.000000000
  0.32  0.5453846   0.000000000  0.005958436  0.000000000
  0.33  0.5453846   0.000000000  0.005958436  0.000000000
  0.34  0.5453846   0.000000000  0.005958436  0.000000000
  0.35  0.5453846   0.000000000  0.005958436  0.000000000
  0.36  0.5453846   0.000000000  0.005958436  0.000000000
  0.37  0.5453846   0.000000000  0.005958436  0.000000000
  0.38  0.5453846   0.000000000  0.005958436  0.000000000
  0.39  0.5453846   0.000000000  0.005958436  0.000000000
  0.40  0.5453846   0.000000000  0.005958436  0.000000000
  0.41  0.5453846   0.000000000  0.005958436  0.000000000
  0.42  0.5453846   0.000000000  0.005958436  0.000000000
  0.43  0.5453846   0.000000000  0.005958436  0.000000000
  0.44  0.5453846   0.000000000  0.005958436  0.000000000
  0.45  0.5453846   0.000000000  0.005958436  0.000000000
  0.46  0.5453846   0.000000000  0.005958436  0.000000000
  0.47  0.5453846   0.000000000  0.005958436  0.000000000
  0.48  0.5453846   0.000000000  0.005958436  0.000000000
  0.49  0.5453846   0.000000000  0.005958436  0.000000000
  0.50  0.5453846   0.000000000  0.005958436  0.000000000

Accuracy was used to select the optimal model using  the largest value.
The final value used for the model was cp = 0.19.
```

### CART Example: Claims Data

```R

claims = read.csv("ClaimsData.csv")
str(claims)
table(claims$bucket2009) / nrow(claims)
library(caTools)

set.seed(88)
split = sample.split(claims$bucket2009, SplitRatio=0.6)
train = subset(claims, split == TRUE)
test = subset(claims, split == FALSE)

mean(train$age)
table(train$diabetes) / nrow(train)

# baseline
table(test$bucket2009, test$bucket2008)
(110138 + 10721 + 2774 + 1539 + 104) / nrow(test)

# smart baseline
PenaltyMatrix = matrix(c(0, 1, 2, 3, 4, 2, 0, 1, 2, 3, 4, 2, 0, 1, 2, 6, 4, 2, 0, 1, 8, 6, 4, 2, 0), byrow=TRUE, nrow=5)
PenaltyMatrix
smart = as.matrix(table(test$bucket2009, test$bucket2008) * PenaltyMatrix)
smartError = sum(smart / nrow(test))

library(rpart)
library(rpart.plot)
str(claims)
claimsTree = rpart(bucket2009 ~ age + alzheimers + arthritis + cancer + copd + depression + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke, bucket2008 + reimbursement2008, data=train, method="class", cp=0.00005)
prp(claimsTree)

predictTree = predict(claimsTree, newdata=test, type="class")
table(test$bucket2009, predictTree)
(111240 + 16343 + 244 + 115) / nrow(test) # accuracy
sum(as.matrix(table(test$bucket2009, predictTree)) * PenaltyMatrix / nrow(test)) #penalty error

# we increased accuracy while the penalty errors also went up
# this is because our CART model predicts 3, 4, 5 rarely to maximize overall accuracy (rpart)

claimsTree = rpart(bucket2009 ~ age + alzheimers + arthritis + cancer + copd + depression + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke, bucket2008 + reimbursement2008, data=train, method="class", cp=0.00005, parms=list(loss=PenaltyMatrix))
predictTree2 = predict(claimsTree, newdata=test, type="class")
table(test$bucket2009, predictTree2)
(73159 + 20759 + 5277 + 486) / nrow(test) # accuracy
sum(as.matrix(table(test$bucket2009, predictTree2)) * PenaltyMatrix / nrow(test)) #penalty error
```

### CART Example: Why People Vote

> if we used method=‘class’, CART would only split if one of the groups had a probability of voting above 50% and the other had a probability of voting less than 50% (since the predicted outcomes would be different). However, with regression trees, CART will split even if both groups have probability less than 50%.

```R
gerber = read.csv("gerber.csv")
str(gerber)

# Problem1
prop.table(table(gerber$voting))

# tapply(gerber$voting, gerber$self, mean)
prop.table(table(gerber$voting, gerber$civicduty))
prop.table(table(gerber$voting, gerber$self))
prop.table(table(gerber$voting, gerber$neighbors))
prop.table(table(gerber$voting, gerber$hawthorne))

# logistic regression
log1 = glm(voting ~ civicduty + self + neighbors + hawthorne, data=gerber, family=binomial)
summary(log1)
predictLog1 = predict(log1, data=gerber, type="response")
table(gerber$voting, predictLog1 > 0.3)
(134513 + 51966) / nrow(gerber)
table(gerber$voting, predictLog1 > 0.5)
(235388) / nrow(gerber)

# ROC, AUC
library(ROCR)
ROCpredLog1 = prediction(predictLog1, gerber$voting)
auc = as.numeric(performance(ROCpredLog1, "auc")@y.values)
auc

# CART
library(rpart)
library(rpart.plot)
# no method="class"
gerberRTree = rpart(voting ~ civicduty + hawthorne + self + neighbors, data=gerber)
prp(gerberRTree) # none of the variables make a big enough effect to be split on

gerberTree1 = rpart(voting ~ civicduty + hawthorne + self + neighbors, data=gerber, cp=0.0)
prp(gerberTree1)

gerberTree2 = rpart(voting ~ civicduty + hawthorne + self + sex + neighbors, data=gerber, cp=0.0)
prp(gerberTree2)

# problem 3
gerberTree3 = rpart(voting ~ control, data=gerber, cp=0.0)
gerberTree4 = rpart(voting ~ control + sex, data=gerber, cp=0.0)
prp(gerberTree3, digits=6)
abs(0.34 - 0.296638)
prp(gerberTree4, digits=6)
abs(0.334176 - 0.345818)

# problem 3.3

# The regression tree calculated the percentage voting
# exactly for every one of the four possibilities
# (Man, Not Control), (Man, Control), (Woman, Not Control), (Woman, Control).
# Logistic regression has attempted to do the same,
# although it wasn't able to do as well because it can't consider
# exactly the joint possibility of being a women and in the control group.
log2 = glm(voting ~ sex + control, data=gerber, family=binomial)
summary(log2)

# problem 3.4

# (Man, Not Control), (Man, Control), (Woman, Not Control), (Woman, Control)
Possibilities = data.frame(sex=c(0,0,1,1),control=c(0,1,0,1))
predict(log2, newdata=Possibilities, type="response")
abs(0.290456 - 0.2908065)

# problem 3.5

# sex:control
# If a person is a woman and in the control group,
# the chance that she voted goes down
log3 = glm(voting ~ sex + control + sex:control, data=gerber, family="binomial")
summary(log3)

# a very small difference (practically zero) using sex:control
predict(log3, newdata=Possibilities, type="response")
abs(0.2904558 - 0.290456)
```

This example has shown that trees can capture nonlinear relationships that logistic regression can not, but that we can get around this sometimes by using variables that are the combination of two variables.

But, we should not use all possible interaction terms in a logistic regression model due to overfitting.

### CART + Random Forest : Letter Recognition

```R
letters = read.csv("letters_ABPR.csv")
str(letter)

# problem 1
letters$isB = as.factor(letters$letter == "B")

library(caTools)
set.seed(1000)
split = sample.split(letters$isB, SplitRatio=0.5)
train = subset(letters, split == TRUE)
test =  subset(letters, split == FALSE)

table(test$isB) / nrow(test) # baseline

# build CART without letter
library(rpart)
library(rpart.plot)
tree1 = rpart(isB ~ . - letter, data=train, method="class")
predictTestOnTree1 = predict(tree1, newdata=test, type="class")
table(test$isB, predictTestOnTree1)
accuracy1 = (1118 + 340) / (1118 + 340 + 57 + 43)

# build random forest
library(randomForest)
set.seed(1000)

# default nodesize, ntree
forest1 = randomForest(isB ~ . - letter, data=train)
predictTestOnForest1 = predict(forest1, newdata=test)
table(test$isB, predictTestOnForest1)
accuracy2 = (1165 + 374) / (1165 + 374 + 10 + 9)
accuracy2
```

Random forests tends to improve on CART in terms of predictive accuracy. Sometimes, this improvement can be quite significant,

```R
# problem 2. multi-class classification
str(letters)
letters$letter = as.factor( letters$letter )
set.seed(2000)

split2 = sample.split(letters$letter, SplitRatio=0.5)
train2 = subset(letters, split2 == TRUE)
test2 = subset(letters, split2 == FALSE)

table(test2$letter) / nrow(test2) # baseline

# build CART
tree2 = rpart(letter ~ . - isB, data=train2, method="class")
predOnTree2 = predict(tree2, newdata=test2, type="class")

# base line
sum(diag(table(test2$letter, predOnTree2))) / nrow(test2)

# random forest
forest2 = randomForest(letter ~ . - isB, data=train2)
predOnForest2 = predict(forest2, newdata=test2)
accuracy3 = sum(diag(table(test2$letter, predOnForest2))) / nrow(test2)
```

### CART Summary

CART + Random Forest + CV
