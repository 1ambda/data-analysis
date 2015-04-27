# Week7, Visualization

[Ref: Analytics Edge Week7, in edx.org]

In **ggplot**, the mapping of data properties to visual properties is done by adding layers to the plot

**ggplot** graphics consist of at least 3 elements

- **data**
- **aesthetic mapping:** describing how variables in the data frame are mapped to graphical attributes (color, shape, x-y axes, subsets, ...)
- **geometric objects:** determine how values are rendered graphically

## ggplot example: WHO

```R
WHO = read.csv("WHO.csv")
str(WHO)

plot(WHO$GNI, WHO$FertilityRate)

install.packages("ggplot2")
library(ggplot2)

# aesthetic mapping
scatterplot = ggplot(WHO, aes(x = GNI, y = FertilityRate))

scatterplot + geom_point()
scatterplot + geom_line()

scatterplot + geom_point(color="blue", size=3, shape=17) 
scatterplot + geom_point(color="darkred", size=3, shape=8) 

scatterplot + geom_point(color="blue", size=3, shape=15) + ggtitle("Fertility Rate vs. Gross National Income")

# save plot as a pdf file
fertilityGNIplot = scatterplot + geom_point(color="darked", size=3, shape=1)
pdf("fertilityGNIplot1.pdf")
print(fertilityGNIplot) 
dev.off()

coloredPlot = ggplot(WHO, aes(x = GNI, y = FertilityRate, color=Region)) + geom_point()
pdf("fertilityGNIplot2ColoredByRegion.pdf")
print(coloredPlot)
dev.off()

ggplot(WHO, aes(x = GNI, y = FertilityRate, color=LifeExpectancy)) + geom_point()

# plot with logistic regression
ggplot(WHO, aes(x = FertilityRate, y = Under15)) + geom_point()
ggplot(WHO, aes(x = log(y), FertilityRate = Under15)) + geom_point()

model = lm(Under15 ~ log(FertilityRate), data=WHO)
# highly significant, R-squared
summary(model)

# by dfault, ggplot will draw a 95% confidence interval shaded around the line
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method="lm")

# 99% confidence interval
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method="lm", level=0.99)

# take away the confidence interval altohether, orange linear regression line
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method="lm", se=FALSE, color="orange")

# palette
ggplot(WHO, aes(x = FertilityRate, y = Under15, color=Region)) + geom_point() + scale_color_brewer(palette="Dark2")
```

## ggplot example: Crime

```R
mvt = read.csv("mvt.csv", stringsAsFactors=FALSE)
str(mvt)

# parse string into date type
mvt$Date = strptime(mvt$Date, format="%m/%d/%y %H:%M")
str(mvt)

mvt$Weekday = weekdays(mvt$Date)
mvt$Hour = mvt$Date$hour
str(mvt)

WeekdayCounts = as.data.frame(table(mvt$Weekday))
str(WeekdayCounts)

# plot using ggplot
library(ggplot2)

ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group=1))
WeekdayCounts$Var1 = factor(WeekdayCounts$Var1, ordered=TRUE, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group=1), linetype=2) + xlab("Day of the Week") + ylab("Total Motor Vehicle Thefts")
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group=1), alpha=0.3) + xlab("Day of the Week") + ylab("Total Motor Vehicle Thefts")

# heat map
table(mvt$Weekday, mvt$Hour)
           
               0    1    2    3    4    5    6    7    8    9   10   11   12
  Friday    1873  932  743  560  473  602  839 1203 1268 1286  938  822 1207
  Monday    1900  825  712  527  415  542  772 1123 1323 1235  971  737 1129
  Saturday  2050 1267  985  836  652  508  541  650  858 1039  946  789 1204
  Sunday    2028 1236 1019  838  607  461  478  483  615  864  884  787 1192
  Thursday  1856  816  696  508  400  534  799 1135 1298 1301  932  731 1093
  Tuesday   1691  777  603  464  414  520  845 1118 1175 1174  948  786 1108
  Wednesday 1814  790  619  469  396  561  862 1140 1329 1237  947  763 1225
           
              13   14   15   16   17   18   19   20   21   22   23
  Friday     857  937 1140 1165 1318 1623 1652 1736 1881 2308 1921
  Monday     824  958 1059 1136 1252 1518 1503 1622 1815 2009 1490
  Saturday   767  963 1086 1055 1084 1348 1390 1570 1702 2078 1750
  Sunday     789  959 1037 1083 1160 1389 1342 1706 1696 2079 1584
  Thursday   752  831 1044 1131 1258 1510 1537 1668 1776 2134 1579
  Tuesday    762  908 1071 1090 1274 1553 1496 1696 1816 2044 1458
  Wednesday  804  863 1075 1076 1289 1580 1507 1718 1748 2093 1511
```

```R
DayHourCounts = as.data.frame(table(mvt$Weekday, mvt$Hour))
str(DayHourCounts)

# factor to numeric
DayHourCounts$Hour = as.numeric(as.character(DayHourCounts$Var2))
str(DayHourCounts)

ggplot(DayHourCounts, aes(x = Hour, y = Freq)) + geom_line(aes(group=Var1, color=Var1), size=1)

colorLineMVT = ggplot(DayHourCounts, aes(x = Hour, y = Freq)) + geom_line(aes(group=Var1, color=Var1), size=1)
pdf("colorLineMVT.pdf")
print(colorLineMVT)
dev.off()

# use heat map instead of plot
DayHourCounts$Var1 = factor(DayHourCounts$Var1, ordered=TRUE, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
str(DayHourCounts)

ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill = Freq))
ggplot(DayHourCounts, aes(x = Var1, y = Hour)) + geom_tile(aes(fill = Freq)) + scale_fill_gradient(name="Total MV Thefts", low="white", high="red") + theme(axis.title.y = element_blank())

heatmapMVT = ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill = Freq)) + scale_fill_gradient(name="Total MV Thefts", low="white", high="red") + theme(axis.title.y = element_blank())
pdf("heatmapMVT.pdf")
print(heatmapMVT)
dev.off()

# draw map with data
install.packages("maps")
install.packages("ggmap")
library(maps)
library(ggmap)

chicago = get_map(location="chicago", zoom=11)
ggmap(chicago)
ggmap(chicago) + geom_point(data=mvt[1:100, ], aes(x=Longitude, y=Latitude))

LatLonCounts = as.data.frame(table(round(mvt$Longitude, 2), round(mvt$Latitude, 2)))
str(LatLonCounts)

# convert char factors into numeric
LatLonCounts$Long = as.numeric(as.character(LatLonCounts$Var1))
LatLonCounts$Lat = as.numeric(as.character(LatLonCounts$Var2))
str(LatLonCounts)

crimeMapChicago = ggmap(chicago) + geom_point(data=LatLonCounts, aes(x = Long, y = Lat, color=Freq, size=Freq)) + scale_color_gradient(low="yellow", high="red")
pdf("crimeMapChicago.pdf")
print(crimeMapChicago)
dev.off()

crimeHeatMapChicago = ggmap(chicago) + geom_tile(data=LatLonCounts, aes(x=Long, y=Lat, alpha=Freq), fill="red")
pdf("crimeHeatMapChicago.pdf")
print(crimeHeatMapChicago)
dev.off()

ValidLatLonCounts = subset(LatLonCounts, Freq > 0)
ggmap(chicago) + geom_tile(data=ValidLatLonCounts, aes(x=Long, y=Lat, alpha=Freq), fill="red")
```

## Social Network

```R
edges = read.csv("edges.csv")
users = read.csv("users.csv")

str(edges)
str(users)

table(users$school, users$region)
table(users$gender, users$school)

(table(edges$V1))
sum(table(edges$V2)) / 59 * 2 

# 2.1
install.packages("igraph")
library(igraph)

# igraph: http://www.inside-r.org/packages/cran/igraph/docs/graph.data.frame
# edges, directed, vertices
g = graph.data.frame(edges, FALSE, users)

# 2.2
plot(g, vertex.size=5, vertex.label=NA)

# 2.3
degree(g)
table(degree(g) >= 10)

V(g)$size = degree(g)/2 + 2
plot(g, vertex.label=NA)

table(V(g)$size)
summary(degree(g)) / 2 + 2

# 3.1 - color
V(g)$color = "black"
V(g)$color[V(g)$gender == "A"] = "red"
V(g)$color[V(g)$gender == "B"] = "gray"
plot(g, vertex.label=NA)

# 3.2 - color using school
V(g)$color[V(g)$school == "A"] = "red"
V(g)$color[V(g)$school == "AB"] = "grey"
plot(g, vertex.label=NA)

# 3.3 - color using local 
V(g)$color[V(g)$locale == "A"] = "red"
V(g)$color[V(g)$locale == "B"] = "grey"
plot(g, vertex.label=NA)
```

### Wordcloud using Tweets







