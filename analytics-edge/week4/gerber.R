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

