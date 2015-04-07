
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
