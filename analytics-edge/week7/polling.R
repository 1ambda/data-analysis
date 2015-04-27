
library(ggplot2)
statesMap = map_data("state")

# 1.1
str(stateMap)
table(stateMap$group)

# 1.2
ggplot(statesMap, aes(x = long, y = lat, group = group)) + geom_polygon(fill = "white", color = "black")

# 2.1
polling = read.csv("PollingImputed.csv")
str(polling)

# split
library(caTools)
Train = subset(polling, Year == 2004 | Year == 2008)
Test  = subset(polling, Year == 2012)

mod2 = glm(Republican ~ SurveyUSA + DiffCount, data=Train, family="binomial")
TestPrediction = predict(mod2, newdata=Test, type="response")
# create a vector of Republican/Democrat prediction
TestPredictionBinary = as.numeric(TestPrediction > 0.5)

predictionDataFrame = data.frame(TestPrediction, TestPredictionBinary, Test$State)
table(Test$Republican, predictionDataFrame$TestPredictionBinary)

table(TestPredictionBinary)
mean(TestPrediction)

# 2.2
predictionDataFrame$region = tolower(predictionDataFrame$Test.State)

# merge
predictionMap = merge(statesMap, predictionDataFrame, by="region")
str(predictionMap)
# make our map in order
predictionMap = predictionMap[order(predictionMap$order),]
str(predictionMap)

# 2.4
ggplot(predictionMap, aes(x=long, y=lat, group=group, fill=TestPredictionBinary)) + geom_polygon(color="black")

# 2.5
ggplot(predictionMap, aes(x=long, y=lat, group=group, fill=TestPrediction)) + geom_polygon(color="black") + scale_fill_gradient(low="blue", high="red", guide="legend", breaks=c(0, 1), labels=c("Democrat", "Republican"), name="Prediction 2012")


# 3.2
which(predictionDataFrame$region == "florida")
predictionDataFrame[6,]

# 4.1: http://docs.ggplot2.org/current/geom_polygon.html
