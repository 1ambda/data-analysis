# Final Exam

## Airline Dealy Problem

spliting data with a continuous dependent variables

```R
set.seed(15071)
split = sample(nrow(airline), 0.7*nrow(airline))
airlineTrain = airline[split,  ]
airlineTest  = airline[-split, ]
```

### Logistic Regression

```R
> lmTotalDelay = lm(TotalDelay ~ ., data=airlineTrain)
> summary(lmTotalDelay)

Call:
lm(formula = TotalDelay ~ ., data = airlineTrain)

Residuals:
   Min     1Q Median     3Q    Max 
-68.30 -16.77  -7.71   2.78 817.93 

Coefficients:
                             Estimate Std. Error t value Pr(>|t|)    
(Intercept)                -45.055881  10.107693  -4.458 8.43e-06 ***
FlightATL-ORD                4.379016   2.175661   2.013  0.04418 *  
FlightLAX-ATL                1.901867   1.967008   0.967  0.33364    
FlightLAX-ORD                5.660679  12.596163   0.449  0.65316    
FlightORD-ATL                6.303303   2.262117   2.786  0.00534 ** 
FlightORD-LAX               11.006282  12.597601   0.874  0.38232    
CarrierAmerican Airlines    -5.724074  13.025146  -0.439  0.66034    
CarrierDelta Air Lines       0.355603   3.527356   0.101  0.91970    
CarrierExpressJet Airlines   7.142202   6.574938   1.086  0.27740    
CarrierSkyWest Airlines      5.527777   4.921477   1.123  0.26140    
CarrierSouthwest Airlines    0.241642   3.924019   0.062  0.95090    
CarrierUnited Airlines       1.148722  12.937041   0.089  0.92925    
CarrierVirgin America       -5.505712  13.222651  -0.416  0.67714    
MonthJuly                   -6.345533   1.279019  -4.961 7.18e-07 ***
MonthJune                   -3.784569   1.333093  -2.839  0.00454 ** 
DayOfWeekMonday             -0.810539   1.914973  -0.423  0.67212    
DayOfWeekSaturday           -4.506943   2.065833  -2.182  0.02917 *  
DayOfWeekSunday             -5.418356   1.944548  -2.786  0.00534 ** 
DayOfWeekThursday            1.571501   1.937850   0.811  0.41742    
DayOfWeekTuesday            -4.206489   2.011211  -2.092  0.03652 *  
DayOfWeekWednesday           1.585338   1.953771   0.811  0.41715    
NumPrevFlights               1.563247   0.504670   3.098  0.00196 ** 
PrevFlightGap                0.015831   0.008055   1.965  0.04940 *  
HistoricallyLate            47.913638   3.326901  14.402  < 2e-16 ***
InsufficientHistory         13.510716   1.586589   8.516  < 2e-16 ***
OriginInVolume               5.121318   4.874897   1.051  0.29350    
OriginOutVolume              6.682176   6.209972   1.076  0.28195    
DestInVolume                14.971479   6.439830   2.325  0.02011 *  
DestOutVolume                1.221879   2.268822   0.539  0.59021    
OriginPrecip                 0.019734   0.006278   3.143  0.00168 ** 
OriginAvgWind               -0.656333   0.296051  -2.217  0.02666 *  
OriginWindGust               0.948098   0.130843   7.246 4.78e-13 ***
OriginFog                   -0.239182   1.666246  -0.144  0.88586    
OriginThunder               -0.818011   3.184140  -0.257  0.79726    
DestPrecip                   0.036874   0.006381   5.778 7.90e-09 ***
DestAvgWind                 -0.282348   0.296227  -0.953  0.34055    
DestWindGust                 0.351908   0.129804   2.711  0.00672 ** 
DestFog                     -0.997796   1.665534  -0.599  0.54914    
DestThunder                  1.363956   3.185359   0.428  0.66852    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 40.77 on 6527 degrees of freedom
Multiple R-squared:  0.09475,	Adjusted R-squared:  0.08948 
F-statistic: 17.98 on 38 and 6527 DF,  p-value: < 2.2e-16
```

### Coefficients

- Highly correlated independent variables can affect the interpretation of the coefficients.
- The coefficient indicates how the prediction changes, not how the actual value changes.

### SSE, SST, R2

[Ref: R squared](http://web.maths.unsw.edu.au/~adelle/Garvan/Assays/GoodnessOfFit.html)

> R-squared can take on any value between 0 and 1, with a value closer to 1 indicating that a greater proportion of variance is accounted for by the model. For eaxmple, R-squared value of 0.8234 means that the fir expains 82.34% of the total variation in the data about the average. 

```R
pred = predict(lmTotalDelay, newdata = airlineTest)
SSE  = sum((airlineTest$TotalDelay - pred)^2) 
SST  = sum((airlineTest$TotalDelay - mean(airlineTrain$TotalDelay))^2)
R2   = 1 - SSE / SST
```

- Our model did not overfit. Since the R-squared on the training set and the R-squared on the test set are similar
- But used independent variables only explain a small amount of the variatino in delays.

## Ebay Problem

- the Random Forest method requires the dependent variable be stored as a factor variable when training a model for classification

- `sample.split` balances the dependent variable between the training and testing sets. 

### Logistic Regression

![](http://latex.codecogs.com/gif.latex?P%28y%20%3D%201%29%20%3D%20%7B%201%20%5Cover%20%7B%201%20&plus;%20e%5E%7B-%28%7B%5Cbeta_0%20&plus;%20%5Cbeta_1x_1%20&plus;%20%5Ccdots%20&plus;%20%5Cbeta_kx_k%7D%29%7D%7D%20%7D)

![](http://latex.codecogs.com/gif.latex?Odds%20%3D%20%7B%20P%28y%20%3D%201%29%20%5Cover%20P%28y%20%3D%200%29%7D)

- Odds > 1 is more likely if y = 1
- Odds < 1 is more likely if y = 0

It turns out that **Odds** are equal to `e` raised to the power of the linear regression equation

![](http://latex.codecogs.com/gif.latex?Odds%20%3D%20e%5E%7B%5Cbeta_0%20&plus;%20%5Cbeta_1x_1%20&plus;%20%5Ccdots%20&plus;%20%5Cbeta_kx_k%7D)

![](http://latex.codecogs.com/gif.latex?log%28Odds%29%20%3D%20%7B%5Cbeta_0%20&plus;%20%5Cbeta_1x_1%20&plus;%20%5Ccdots%20&plus;%20%5Cbeta_kx_k%7D)

This is called the **Logit**. The bigger the Logit is, The bigger `P(y = 1)`

- A positive beta value increases the Logit which in turn increases the Odds of 1
- A negative beta value decreases the Logit which in turn decreases the Odds of one

> The coefficients of the model are the log odds associated with that variable; so we see that the odds of being sold are exp(0.8325406)=2.299153 those of an otherwise identical shoe in the baseline category for the style variable (which is "Open Toe"). This means the stiletto is predicted to have 129.9% higher odds of being sold. 

### AUC

> AUC is the proportion of the time the model can differentiate between a randomly selected shoe that was sold a randomly selected shoe that was not sold.

- A model with threshold 0 predicts 1 for all observatinos, yielding a 100% true positive rate and a 100% false positive rate.

![](http://www.unc.edu/courses/2010fall/ecol/563/001/images/lectures/lecture22/fig4.png)

[Ref - www.unc.edu](http://www.unc.edu/courses/2010fall/ecol/563/001/docs/lectures/lecture22.htm)

```R
# 2.10 AUC

library(ROCR)
rocPred = prediction(glmPred, ebayTest$sold)
AUC = as.numeric(performance(rocPred, "auc")@y.values)

# 2.11 plot AUC 

rocPerf = performance(rocPred, "tpr", "fpr")
plot(rocPerf, colorize=TRUE, print.cutoffs.at = seq(0, 1, 0.1), text.ajd=c(-0.2, 1.7))
```

![](https://raw.githubusercontent.com/1ambda/data-analysis/master/analytics-edge/final/screenshots/ROC.png)

### k-fold Cross-Validation

![](http://cse3521.artifice.cc/images/k-fold-cross-validation.jpg)

[Ref - answermeup.com](http://answermeup.com/questions/perform-k-fold-cross-validation.html)

- If using 10-fold cross-validation with 3 different parameter sets, 30 odels are trained on subsets of the trianing set and evaluated on a portion of the trianing set.

```R
set.seed(144)
library(caret)

numFolds = trainControl(method="cv", number = 10)
cpGrid = expand.grid(.cp=seq(0.001, 0.05, 0.001))
train(sold ~ biddable + startprice + condition + heel + style + color + material, data=ebayTrain, method="rpart", trControl = numFolds, tuneGrid=cpGrid)

# 2.16 train CART model

cartEbay = rpart(sold ~ biddable + startprice + condition + heel + style + color + material, data=ebayTrain, method="class", cp=0.004)
summary(cartEbay)
```

### text mining

```R
# 2.17 building a corpus

library(tm)
corpus = Corpus(VectorSource(ebay$description))
corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus, content_transformer(tolower)) # corpus[[1]]
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords("english"))
corpus = tm_map(corpus, stemDocument)
dtm    = DocumentTermMatrix(corpus)

# 2.18

sparceDtm = removeSparseTerms(dtm, 0.90)
descriptionText = as.data.frame(as.matrix(sparceDtm))

# 2.19

sort(colSums(descriptionText))

# 2.20 adding `D` in front of all the variable names
names(descriptionText) = paste0("D", names(descriptionText))

descriptionText$sold = ebay$sold
descriptionText$biddable = ebay$biddable
descriptionText$startprice = ebay$startprice
descriptionText$condition = ebay$condition
descriptionText$heel = ebay$heel
descriptionText$style = ebay$style
descriptionText$color = ebay$color
descriptionText$material = ebay$material

# 2.21

textTrain = subset(descriptionText, split == TRUE)
textTest  = subset(descriptionText, split == FALSE) 

glmText = glm(sold ~ ., data=textTrain, family=binomial)
summary(glmText)

# 2.22 auc

textTrainPred = predict(glmText, data=textTrain, type="response")
rocTrainPred  = prediction(textTrainPred, textTrain$sold)
aucTrain      = as.numeric(performance(rocTrainPred, "auc")@y.values)

textTestPred  = predict(glmText, newdata=textTest, type="response")
rocTestPred   = prediction(textTestPred, textTest$sold)
aucTest       = as.numeric(performance(rocTestPred, "auc")@y.values)
```

`glmText` is overfitted, and removing variables would improve its test set performance

<br/>

## Hubway Trips

### Normalization

```R
library(caret)
preproc = preProcess(hubway)
hubwayNorm = predict(preproc, hubway)
```

### Clustering

```R
# 3.8 k-means
set.seed(5000)
k = 10

km = kmeans(hubwayNorm, centers = k)
sort(table(km$cluster))
hubwayNorm$Cluster = km$cluster

> km$centers

# output

       Duration    Morning  Afternoon    Evening      Weekday        Male
1  -0.034237161 -0.6957001 -0.8159893  1.7328821  0.452730346  0.59720321
2  -0.031644628 -0.6957001  1.2254436 -0.5770702  0.452730346 -0.11039559
3  -0.075974588  1.2746943 -0.8159893 -0.5770702  0.002308007  0.59720321
4  -0.033395894  1.4312812 -0.8159893 -0.5766432  0.211890485  0.53694181
5   0.010658714 -0.6957001 -0.8159893  1.3165203 -2.208808422  0.02391135
6  -0.029700264 -0.6957001  1.2076942 -0.5770702  0.444257434  0.20767851
7   0.009374313  1.3613204 -0.8159893 -0.5770702  0.071729589 -1.67446286
8   0.105065026 -0.6952729  1.2098284 -0.5770702 -2.208808422 -0.13141006
9  -0.110953214  1.4020577 -0.8159893 -0.5770702  0.452730346  0.59720321
10  0.466193222 -0.6898820 -0.8126896  1.7146806  0.447352956 -1.65174391
           Age
1  -0.21374647
2  -0.54633125
3  -0.75156212
4   1.70549223
5  -0.43695957
6   1.30751246
7  -0.07416553
8  -0.18546466
9   0.26224992
10 -0.31480304
```
