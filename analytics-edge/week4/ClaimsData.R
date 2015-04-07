
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


