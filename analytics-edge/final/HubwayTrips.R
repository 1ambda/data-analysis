
# 3.1 

hubway = read.csv("HubwayTrips.CSV") 
str(hubway)

# 3.2

weekdays = subset(hubway, Weekday == 1)
weekends = subset(hubway, Weekday == 0)

mean(hubway$Duration)
mean(weekdays$Duration)
mean(weekends$Duration)

# 3.3

morning   = subset(hubway, Morning == 1)
afternoon = subset(hubway, Afternoon == 1)
evening   = subset(hubway, Evening == 1)

nrow(morning)
nrow(afternoon)
nrow(evening)

# 3.4

male = subset(hubway, Male == 1)
nrow(male) / nrow(hubway)

# 3.6 normalizing the data

library(caret)
preproc = preProcess(hubway)
hubwayNorm = predict(preproc, hubway)

# 3.7 h-clustering

str(hubwayNorm) # too many observations to handle h-custering

# 3.8 k-means
set.seed(5000)
k = 10

km = kmeans(hubwayNorm, centers = k)
sort(table(km$cluster))
hubwayNorm$Cluster = km$cluster


c1 = subset(hubwayNorm, Cluster == 1)
c2 = subset(hubwayNorm, Cluster == 2)
c3 = subset(hubwayNorm, Cluster == 3)
c4 = subset(hubwayNorm, Cluster == 4)
c5 = subset(hubwayNorm, Cluster == 5)
c6 = subset(hubwayNorm, Cluster == 6)
c7 = subset(hubwayNorm, Cluster == 7)
c8 = subset(hubwayNorm, Cluster == 8)
c9 = subset(hubwayNorm, Cluster == 9)
c10 = subset(hubwayNorm, Cluster == 10)

mean(c10$Male)
mean(c10$Weekday)
mean(c10$Evening)

## or simpliy, km$clusters

# 3.10
mean(c9$Afternoon)
mean(c8$Weekday)
mean(c8$Duration)

# 3.11

km$centers

# 3.14

set.seed(8000)
k = 20
hubwayNorm$Cluster = NULL
km2 = kmeans(hubwayNorm, centers = k)

sort(table(km2$cluster))

# 3.15

km2$centers 
