 
CPS = read.csv("CPSData.csv")

## 1. loading and summarizing the dataset

sort(table(CPS$Industry))

sort(table(CPS$State))

prop.table(table(CPS$Citizenship))

Hispanics = CPS[CPS$Hispanic == 1,]
table(Hispanics$Race)

## 2. Evaluating Missing Values

summary(CPS)
is.na(CPS$Married)
table(CPS$Region, is.na(CPS$Married))
table(CPS$Sex, is.na(CPS$Married))
table(CPS$Age, is.na(CPS$Married))
table(CPS$Citizenship, is.na(CPS$Married))

table(CPS$State, is.na(CPS$MetroAreaCode)) ## 2.3

table(CPS$Region, is.na(CPS$MetroAreaCode)) ## 2.4

tapply(is.na(CPS$MetroAreaCode), CPS$State, mean) ## 2.5

## 3. Intergrating Metropolitan area data

MetroAreaMap = read.csv("MetroAreaCodes.csv")
CountryMap   = read.csv("CountryCodes.csv") 

nrow(MetroAreaMap)
nrow(CountryMap)

CPS = merge(CPS, MetroAreaMap, by.x="MetroAreaCode", by.y="Code", all.x=TRUE)
summary(CPS)

sort(table(CPS$MetroArea)) ## 3.3

sort(tapply(CPS$Hispanic == 1, CPS$MetroArea, mean) * 100) ## 3.4

sort(tapply(CPS$Race == "Asian", CPS$MetroArea, mean) * 100) ## 3.5

sort(tapply(CPS$Education == "No high school diploma", CPS$MetroArea, mean, na.rm=TRUE)) ## 3.6

## 4. Intergrating Country of Birth Data

CPS = merge(CPS, CountryMap, by.x="CountryOfBirthCode", by.y="Code", all.x=TRUE)
summary(CPS)
str(CPS)
levels(CPS$Country)

sort(table(CPS$Country)) ## 4.2


NYNJ_Metro = subset(CPS, MetroArea == "New York-Northern New Jersey-Long Island, NY-NJ-PA")
mean(NYNJ_Metro$Country != "United States", na.rm=TRUE) ## 4.3

## 4.4

Indian = subset(CPS, Country == "India")
sort(table(Indian$MetroArea))

Brazilian = subset(CPS, Country == "Brazil")
sort(table(Brazilian$MetroArea))

Somalian = subset(CPS, Country == "Somalia")
sort(table(Somalian$MetroArea))

