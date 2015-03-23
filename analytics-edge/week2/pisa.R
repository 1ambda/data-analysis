
pisaTrain = read.csv("pisa2009train.csv")
pisaTest = read.csv("pisa2009test.csv")

str(pisaTrain)

tapply(pisaTrain$readingScore, pisaTrain$male, mean)

pisaTrain = na.omit(pisaTrain)
pisaTest = na.omit(pisaTest)

str(pisaTrain)
str(pisaTest)

summary(pisaTrain$raceeth)

pisaTrain$raceeth = relevel(pisaTrain$raceeth, "White")
pisaTest$raceeth = relevel(pisaTest$raceeth, "White")

str(pisaTest)

model1 = lm(readingScore ~ ., data=pisaTrain)
str(model1)
summary(model1)

predictTest = predict(model1, newdata=pisaTest)
summary(predictTest)
max(predictTest) - min(predictTest)

sum((pisaTest$readingScore - predictTest)^2)

SSE = sum((predictTest - pisaTest$readingScore)^2)
SST = sum((mean(pisaTest$readingScore) - pisaTest$readingScore)^2)


R2 = 1 - SSE/SST
R2

1 - 517.9629/ SST
