# Stock Dynamics

## load data frames

IBM = read.csv("IBMStock.csv")
GE = read.csv("GEStock.csv")
ProcterGamble = read.csv("ProcterGambleStock.csv")
CocaCola = read.csv("CocaColaStock.csv")
Boeing = read.csv("BoeingStock.csv")

## convert text into date

IBM$Date = as.Date(IBM$Date, "%m/%d/%y")
GE$Date = as.Date(GE$Date, "%m/%d/%y")
ProcterGamble$Date = as.Date(ProcterGamble$Date, "%m/%d/%y")
CocaCola$Date = as.Date(CocaCola$Date, "%m/%d/%y")
Boeing$Date = as.Date(Boeing$Date, "%m/%d/%y")

nrow(IBM) ## 1.1
IBM$Date[1] ## 1.2
IBM$Date[480] ## 1.3
mean(IBM$StockPrice) ## 1.4
min(GE$StockPrice) ## 1.5
max(CocaCola$StockPrice) ## 1.5
median(Boeing$StockPrice) ## 1.7
sd(ProcterGamble$StockPrice) ## 1.8


## 2 Visualizing Stock Dynamics

plot(CocaCola$Date, CocaCola$StockPrice, col="red", type="l")
lines(ProcterGamble$Date, ProcterGamble$StockPrice, col="blue", lty=2)
abline(v=as.Date(c("2000-03-01")), lwd=1)
abline(v=as.Date(c("1983-03-01")), lwd=1)

## 3 Visualizing 1995-2005
plot(CocaCola$Date[301:432], CocaCola$StockPrice[301:432], type="l", col="red", ylim=c(0,210))
lines(Boeing$Date[301:432], Boeing$StockPrice[301:432], type="l", col="blue", ylim=c(0,210))
lines(IBM$Date[301:432], IBM$StockPrice[301:432], type="l", col="green", ylim=c(0,210), lwd=2)
lines(GE$Date[301:432], GE$StockPrice[301:432], type="l", col="orange", ylim=c(0,210))
lines(ProcterGamble$Date[301:432], ProcterGamble$StockPrice[301:432], type="l", col="black", ylim=c(0,210))
abline(v=as.Date(c("2000-03-01")), lwd=1)
abline(v=as.Date(c("1997-09-01")), lwd=1)
abline(v=as.Date(c("1997-11-01")), lwd=1)

## 4 Monthly Trends

IBM_MonthAvg = tapply(IBM$StockPrice, months(IBM$Date), mean)
IBM_MonthAvg > mean(IBM$StockPrice)

GE_MonthAvg = tapply(GE$StockPrice, months(GE$Date), mean)
which.max(GE_MonthAvg)
Coke_MonthAvg = tapply(CocaCola$StockPrice, months(CocaCola$Date), mean)
which.max(Coke_MonthAvg)
