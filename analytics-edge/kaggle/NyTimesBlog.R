
# libraries
library(ggplot2)
library(caTools)
library(ROCR)

# 0. Baseline: 0.1673301
blogs = read.csv("NYTimesBlogTrain.csv")
table(blogs$Popular)[2] / nrow(blogs)
table(blogs$Popular)


# 1. PubDate: Hour, Day, Weekday, Month
blogs = read.csv("NYTimesBlogTrain.csv")
str(blogs)

## Weekday: 
blogs$PubDate = strptime(blogs$PubDate, format="%Y-%m-%d %H:%M:%S")
blogs$PubWeekday = weekdays(blogs$PubDate)
table(blogs$PubWeekday, blogs$Popular)

popular = subset(blogs, Popular == 1)

WeekdayCounts = data.frame(table(popular$PubWeekday, popular$Popular))
WeekdayCounts$Var1 = factor(WeekdayCounts$Var1, ordered=TRUE, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group=1), linetype=4) + xlab("Day of the Week") + ylab("Total Number of Popular Articles")


## Hour:
blogs$PubHour = blogs$PubDate$hour 
table(blogs$PubHour, blogs$Popular)

popular = subset(blogs, Popular == 1)

HourCounts = data.frame(table(popular$PubHour, popular$Popular))
ggplot(HourCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group=1), linetype=4) + xlab("Hour") + ylab("Total Number of Popular Articles")

## Weekday + Hour Heatmap
table(popular$PubWeekday, popular$PubHour)
DayHourCounts = data.frame(table(popular$PubWeekday, popular$PubHour))
DayHourCounts$Var1 = factor(DayHourCounts$Var1, ordered=TRUE, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
DayHourCounts$Var2 = as.numeric(as.character(DayHourCounts$Var2))

ggplot(DayHourCounts, aes(x = Var1, y = Var2)) + geom_tile(aes(fill= Freq)) + scale_fill_gradient(name="# of Popular Articles", low="white", high="blue") + xlab("Day of Week") + ylab("Hour")


# 2. NewsDesk, SectionName, SubsectionName
blogs = read.csv("NYTimesBlogTrain.csv")
popular = subset(blogs, Popular == 1)
unpopular = subset(blogs, Popular == 0)

table(blogs$NewsDesk, blogs$Popular)
table(blogs$SectionName, blogs$Popular)
table(blogs$SubsectionName, blogs$Popular)

## logistic regression
set.seed(20150430)
split = sample.split(blogs$Popular, SplitRatio=0.7)
train = subset(blogs, split == 1)
test  = subset(blogs, split == 0)

log1 = glm(Popular ~ NewsDesk + SectionName + SubsectionName, data=train, family=binomial)
Summary(log1)
pred = predict(log1, newdata=test, type="response")

### baseline model. predict all articles are unpopular: 0.8326531
table(test$Popular)[1] / nrow(test)

### accuracy: 0.902551
cfMat = table(test$Popular, pred > 0.5)
sum(diag(cfMat)) / sum(cfMat)

### AUC: 0.8700635
ROCpred = prediction(pred, test$Popular)
as.numeric(performance(ROCpred, "auc")@y.values)

### Submission
subsData = read.csv("NyTimesBlogTest.csv")

str(subsData)
predSubs = predict(log1, newdata=subsData, type="response")

submission = data.frame(UniQueID = UniqueID, Probability1 = predSubs)
str(submission)

write.csv(submission, file="submissions/submission1.csv", row.names=FALSE)
