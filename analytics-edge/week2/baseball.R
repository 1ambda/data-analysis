baseball = read.csv("baseball.csv")

str(baseball)

moneyball = subset(baseball, Year < 2002)

str(moneyball)

moneyball$RD = moneyball$RS - moneyball$RA
str(moneyball)
plot(moneyball$RD, moneyball$W)

WinsReg = lm(W ~ RD, data=moneyball)
summary(WinsReg)

RunsReg = lm(RS ~ OBP + SLG + BA, data=moneyball)
summary(RunsReg)

RunsReg2 = lm(RS ~ OBP + SLG, data=moneyball)
summary(RunsReg2)

rank = c(1,2,3,3,4,4,4,4,5,5)
wins1 = c(94, 88, 95, 88, 93, 94, 98, 97, 93, 94)
wins2 = c(97, 97, 92, 93, 92, 96, 94, 96, 92, 90)
cor(rank, wins1)
cor(rank, wins2)
