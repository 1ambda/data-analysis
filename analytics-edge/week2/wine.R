wine = read.csv("wine.csv")

model1 = lm(Price ~ HarvestRain + WinterRain, data=wine)
summary(model1)

cor(wine$WinterRain, wine$Price)
cor(wine)


model4 = lm(Price ~ WinterRain + AGST + HarvestRain + Age, data=wine)

wineTest = read.csv("wine_test.csv")
str(wineTest)

predictTest = predict(model4, newdata=wineTest)
predictTest
SSE = sum((wineTest$Price - predictTest)^2)
SST = sum((wineTest$Price - mean(wine$Price))^2)
1 - SSE/SST
