
airline = read.csv("AirlineDelay.csv")
str(airline)

# 1.1 split
library(caTools)
set.seed(15071)
split = sample(nrow(airline), 0.7*nrow(airline))
airlineTrain = airline[split,  ]
airlineTest  = airline[-split, ]

nrow(airlineTest)

# 1.3 linear regression
lmTotalDelay = lm(TotalDelay ~ ., data=airlineTrain)

# 1.4
summary(lmTotalDelay)

# 1.5 correlations
cor(airlineTrain$NumPrevFlights, airlineTrain$PrevFlightGap)
cor(airlineTrain$OriginAvgWind,  airlineTrain$OriginWindGust)

# 1.10
pred = predict(lmTotalDelay, newdata = airlineTest)
SSE  = sum((airlineTest$TotalDelay - pred)^2) 
SST  = sum((airlineTest$TotalDelay - mean(airlineTrain$TotalDelay))^2)
R2   = 1 - SSE / SST

# 1.12 classification problem

airline$DelayClass = factor(ifelse(airline$TotalDelay == 0, "No Delay", ifelse(airline$TotalDelay >= 30, "Major Delay", "Minor Delay")))
table(airline$DelayClass)

airline$TotalDelay = NULL

set.seed(15071)
split = sample.split(airline$DelayClass, SplitRatio = 0.7)

airlineTrain = subset(airline, split == TRUE)
airlineTest  = subset(airline, split == FALSE)

# 1.13 CART
library(rpart)
library(rpart.plot)
tree = rpart(DelayClass ~ ., data=airlineTrain, method="class")
plot(tree)

# 1.15 accuracy
predTrain = predict(tree, data = airlineTrain, type="class")
cfMatrix = table(airlineTrain$DelayClass, predTrain)
accuracy = sum(diag(cfMatrix)) / nrow(airlineTrain)

# >table(airlineTest$DelayClass, predTree)
#              predTree
#               Major Delay Minor Delay No Delay
#   Major Delay           0         141      338
#  Minor Delay           0         153      776
#  No Delay              0         105     1301

# 1.16 baseline
table(airlineTrain$DelayClass)
nrow(airlineTrain)
3282 / 6567

# 1.17  accuracy on the testing set
 
predTest = predict(tree, newdata = airlineTest, type="class")
cfMatrix = table(airlineTest$DelayClass, predTest)
accuracy = sum(diag(cfMatrix)) / nrow(airlineTest)
