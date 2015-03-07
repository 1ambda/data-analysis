mvt = read.csv("mvtWeek1.csv")

nrow(mvt)

str(mvt)

max(mvt$ID)

min(mvt$Beat)

nrow(subset(mvt, Arrest == TRUE))

nrow(subset(mvt, LocationDescription == "ALLEY"))

## convert text into date type
DateConvert = as.Date(strptime(mvt$Date, "%m/%d/%y %H:%M"))
mvt$Month = months(DateConvert)
mvt$Weekday = weekdays(DateConvert)
mvt$Date = DateConvert

table(mvt$Month)
which.min(table(mvt$Month))

table(mvt$Weekday)
which.max(table(mvt$Weekday))

Arrested = subset(mvt, Arrest == TRUE)
table(Arrested$Month)
which.max(table(Arrested$Month))

## Visualization
hist(mvt$Date, breaks=100)

boxplot(mvt$Date ~ mvt$Arrest)

## 3.3 For what proportion of motor vehicle thefts in 2001 was an arrest made?

getArrestedCrimeProp <- function(year) {
  CrimeInYear = subset(mvt, Year == year)
  ArrestedTable = table(CrimeInYear$Arrest)
  return (prop.table(ArrestedTable))
}

getArrestedCrimeProp(2001)
getArrestedCrimeProp(2007)
getArrestedCrimeProp(2012)

## 4.1 Popular Location

LocDesc = sort(table(mvt$LocationDescription))
tail(LocDesc, n=6)

## 4.2 Top5
Top5 = subset(mvt, 
              LocationDescription == "STREET" |
                LocationDescription == "PARKING LOT/GARAGE(NON.RESID.)" |
                LocationDescription == "ALLEY" |
                LocationDescription == "GAS STATION" |
                LocationDescription == "DRIVEWAY - RESIDENTIAL")
nrow(Top5)


Top5$LocationDescription = factor(Top5$LocationDescription)
table(Top5$LocationDescription, Top5$Arrest)

## 4.4 On which of day of week do the most motor vehicle thefts at gas stations happen?
TheftAtGasStation = subset(Top5, LocationDescription == "GAS STATION")
table(TheftAtGasStation$Weekday)
which.max(table(TheftAtGasStation$Weekday))

## 4.5 On which day of week do the fewest motor vehicle thefts in residential driveways happen?

summary(Top5$LocationDescription)
TheftAtDriveway = subset(Top5, LocationDescription == "DRIVEWAY - RESIDENTIAL")
table(TheftAtDriveway$Weekday)
which.min(table(TheftAtDriveway$Weekday))


