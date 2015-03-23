climate = read.csv("climate_change.csv")
str(climate)

cl_train = subset(climate, Year <= 2006)
cl_test = subset(climate, YEAR > 2006)

model1 = lm(Temp ~ MEI + CO2 + CH4 + N2O + CFC.11 + CFC.12 + TSI + Aerosols, data=cl_train)
summary(model1)

model2 = lm(Temp ~ MEI + TSI + N2O + Aerosols, data=cl_train)
summary(model2)

model3 = step(model1)
summary(model3)

predictTest = predict(model3, newdata=cl_test)
predictTest

SSE = sum((cl_test$Temp - predictTest)^2)
SST = sum((cl_test$Temp - mean(cl_train$Temp))^2)

1 - SSE / SST
