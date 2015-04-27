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


ggplot(WHO, aes(x = FertilityRate, y = Under15, color=Region)) + geom_point() + scale_color_brewer(palette="Dark2")



