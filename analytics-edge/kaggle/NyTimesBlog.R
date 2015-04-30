
# libraries
library(ggplot2)

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


# 2. NewsDesk
blogs = read.csv("NYTimesBlogTrain.csv")
popular = subset(blogs, Popular == 1)
unpopular = subset(blogs, Popular == 0)

table(blogs$NewsDesk, blogs$Popular)

# 3. SectionName, SubsectionName
table(blogs$SectionName, blogs$Popular)
table(blogs$SubsectionName, blogs$Popular)




