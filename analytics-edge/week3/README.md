
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

### Baseline, R-Squared

![](http://www.ats.ucla.edu/stat/mult_pkg/faq/general/Psuedo3.gif)

where N is the number of observations in the model, y is the dependent variable, y-bar is the mean of the y values, and y-hat is the value predicted by the model. The numerator of the ratio is the sum of the squared differences between the actual y values and the predicted y values

[from](http://www.ats.ucla.edu/stat/mult_pkg/faq/general/Psuedo_RSquareds.htm)

### Split Data Using caTools

```R
set.seed(88)
split = sample.split(quality$PoorCare, SplitRatio = 0.75) # 25% test data

qualityTrain = subset(quality, split == TRUE)
qualityTest = subset(quality, split == FALSE)
```

### AIC, AUC,

(1) AIC

small AIC os better

(2) AUC

The AUC measures discrimination, that is, the ability of the model to correctly classify those that are low risk vs. high risk.
Consider the situation in which patients are already correctly classified into these two groups. You randomly pick on from the low risk group and one from the high risk group and do the test on both. The patient with the more abnormal test result should be the one from the high risk group. The area under the curve is the percentage of randomly drawn pairs for which this is true (that is, the test correctly classifies the two patients in the random pair).


### Multiple Imputation

```R
> install.packages("mice")
Error in install.packages : Updating loaded packages
> library(mice)
> polling = read.csv("PollingData.csv")
> install.packages("mice")
Error in install.packages : Updating loaded packages
> library(mice)
> simple = polling[c("Rasmussen", "SurveyUSA", "PropR", "DiffCount")]
> summary(simple)
   Rasmussen          SurveyUSA            PropR          DiffCount
 Min.   :-41.0000   Min.   :-33.0000   Min.   :0.0000   Min.   :-19.000  
 1st Qu.: -8.0000   1st Qu.:-11.7500   1st Qu.:0.0000   1st Qu.: -6.000  
 Median :  1.0000   Median : -2.0000   Median :0.6250   Median :  1.000  
 Mean   :  0.0404   Mean   : -0.8243   Mean   :0.5259   Mean   : -1.269  
 3rd Qu.:  8.5000   3rd Qu.:  8.0000   3rd Qu.:1.0000   3rd Qu.:  4.000  
 Max.   : 39.0000   Max.   : 30.0000   Max.   :1.0000   Max.   : 11.000  
 NA's   :46         NA's   :71
> set.seed(144)
> imputed = complete(mice(simple))

 iter imp variable
  1   1  Rasmussen  SurveyUSA
  1   2  Rasmussen  SurveyUSA
  1   3  Rasmussen  SurveyUSA
  1   4  Rasmussen  SurveyUSA
  1   5  Rasmussen  SurveyUSA
  2   1  Rasmussen  SurveyUSA
  2   2  Rasmussen  SurveyUSA
  2   3  Rasmussen  SurveyUSA
  2   4  Rasmussen  SurveyUSA
  2   5  Rasmussen  SurveyUSA
  3   1  Rasmussen  SurveyUSA
  3   2  Rasmussen  SurveyUSA
  3   3  Rasmussen  SurveyUSA
  3   4  Rasmussen  SurveyUSA
  3   5  Rasmussen  SurveyUSA
  4   1  Rasmussen  SurveyUSA
  4   2  Rasmussen  SurveyUSA
  4   3  Rasmussen  SurveyUSA
  4   4  Rasmussen  SurveyUSA
  4   5  Rasmussen  SurveyUSA
  5   1  Rasmussen  SurveyUSA
  5   2  Rasmussen  SurveyUSA
  5   3  Rasmussen  SurveyUSA
  5   4  Rasmussen  SurveyUSA
  5   5  Rasmussen  SurveyUSA
> summary(imputed)
   Rasmussen         SurveyUSA           PropR          DiffCount
 Min.   :-41.000   Min.   :-33.000   Min.   :0.0000   Min.   :-19.000  
 1st Qu.: -8.000   1st Qu.:-11.000   1st Qu.:0.0000   1st Qu.: -6.000  
 Median :  3.000   Median :  1.000   Median :0.6250   Median :  1.000  
 Mean   :  1.731   Mean   :  1.517   Mean   :0.5259   Mean   : -1.269  
 3rd Qu.: 11.000   3rd Qu.: 18.000   3rd Qu.:1.0000   3rd Qu.:  4.000  
 Max.   : 39.000   Max.   : 30.000   Max.   :1.0000   Max.   : 11.000  
> polling$Rasmussen = imputed$Rasmussen
> polling$SurveyUSA = imputed$SurveyUSA
> summary(polling)
         State          Year        Rasmussen         SurveyUSA         DiffCount           PropR
 Arizona    :  3   Min.   :2004   Min.   :-41.000   Min.   :-33.000   Min.   :-19.000   Min.   :0.0000  
 Arkansas   :  3   1st Qu.:2004   1st Qu.: -8.000   1st Qu.:-11.000   1st Qu.: -6.000   1st Qu.:0.0000  
 California :  3   Median :2008   Median :  3.000   Median :  1.000   Median :  1.000   Median :0.6250  
 Colorado   :  3   Mean   :2008   Mean   :  1.731   Mean   :  1.517   Mean   : -1.269   Mean   :0.5259  
 Connecticut:  3   3rd Qu.:2012   3rd Qu.: 11.000   3rd Qu.: 18.000   3rd Qu.:  4.000   3rd Qu.:1.0000  
 Florida    :  3   Max.   :2012   Max.   : 39.000   Max.   : 30.000   Max.   : 11.000   Max.   :1.0000  
 (Other)    :127
   Republican
 Min.   :0.0000  
 1st Qu.:0.0000  
 Median :1.0000  
 Mean   :0.5103  
 3rd Qu.:1.0000  
 Max.   :1.0000  

>
```

### Baseline model

```R
> table(train$Republican)

 0  1
47 53
> table(sign(train$Rasmussen))

-1  0  1
42  3 55
> table(train$Republican, sign(train$Rasmussen))

    -1  0  1
  0 42  2  3
  1  0  1 52
>
```

### Build a model

select a independent variable using `cor`

```R
> cor(train)
다음에 오류가 있습니다cor(train) : 'x'는 반드시 수치형이어야 합니다
> str(train)
'data.frame':	100 obs. of  7 variables:
 $ State     : Factor w/ 50 levels "Alabama","Alaska",..: 1 1 2 2 3 3 4 4 5 5 ...
 $ Year      : int  2004 2008 2004 2008 2004 2008 2004 2008 2004 2008 ...
 $ Rasmussen : int  11 21 16 16 5 5 7 10 -11 -27 ...
 $ SurveyUSA : int  18 25 21 21 15 8 5 9 -11 -24 ...
 $ DiffCount : int  5 5 1 6 8 9 8 5 -8 -5 ...
 $ PropR     : num  1 1 1 1 1 1 1 1 0 0 ...
 $ Republican: int  1 1 1 1 1 1 1 1 0 0 ...
> cor(train[c("Rasmussen", "SurveyUSA", "DiffCount", "PropR", "Republican")])
           Rasmussen SurveyUSA DiffCount     PropR Republican
Rasmussen  1.0000000 0.9194508 0.5124098 0.8404803  0.8021191
SurveyUSA  0.9194508 1.0000000 0.5541816 0.8756581  0.8205806
DiffCount  0.5124098 0.5541816 1.0000000 0.8273785  0.8092777
PropR      0.8404803 0.8756581 0.8273785 1.0000000  0.9484204
Republican 0.8021191 0.8205806 0.8092777 0.9484204  1.0000000
> model1 = glm(Republican ~ PropR, data=train, family=binomial)
> summary(model1)

Call:
glm(formula = Republican ~ PropR, family = binomial, data = train)

Deviance Residuals:
     Min        1Q    Median        3Q       Max  
-2.22880  -0.06541   0.10260   0.10260   1.37392  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)
(Intercept)   -6.146      1.977  -3.108 0.001882 **
PropR         11.390      3.153   3.613 0.000303 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 138.269  on 99  degrees of freedom
Residual deviance:  15.772  on 98  degrees of freedom
AIC: 19.772

Number of Fisher Scoring iterations: 8

>
```

Select two variables using `cor`. Use less cor variables to improve model.

```R
> cor(train[c("Rasmussen", "SurveyUSA", "DiffCount", "PropR", "Republican")])
           Rasmussen SurveyUSA DiffCount     PropR Republican
Rasmussen  1.0000000 0.9194508 0.5124098 0.8404803  0.8021191
SurveyUSA  0.9194508 1.0000000 0.5541816 0.8756581  0.8205806
DiffCount  0.5124098 0.5541816 1.0000000 0.8273785  0.8092777
PropR      0.8404803 0.8756581 0.8273785 1.0000000  0.9484204
Republican 0.8021191 0.8205806 0.8092777 0.9484204  1.0000000
> model2 = glm(Republican ~ SurveyUSA + DiffCount, data=train, family=binomial)
> summary(model2)

Call:
glm(formula = Republican ~ SurveyUSA + DiffCount, family = binomial,
    data = train)

Deviance Residuals:
     Min        1Q    Median        3Q       Max  
-2.01196  -0.00698   0.01005   0.05074   1.54975  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)  
(Intercept)  -1.1405     1.2456  -0.916   0.3599  
SurveyUSA     0.2976     0.1949   1.527   0.1267  
DiffCount     0.7673     0.4188   1.832   0.0669 .
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 138.269  on 99  degrees of freedom
Residual deviance:  12.439  on 97  degrees of freedom
AIC: 18.439

Number of Fisher Scoring iterations: 10

> pred2 = predict(model2, type="response")
> table(train$Republican, pred2 >= 0.5)

    FALSE TRUE
  0    45    2
  1     1   52
>
```

### Evaluate models

```R
# baseline
> table(test$Republican, sign(test$Rasmussen))

    -1  0  1
  0 18  2  4
  1  0  0 21
> table(test$Republican, pred2Test >= 0.5)

    FALSE TRUE
  0    23    1
  1     0   21
>
```

```R
> subset(test, pred2Test >= 0.5 & Republican == 0)
     State Year Rasmussen SurveyUSA DiffCount     PropR Republican
24 Florida 2012         2         0         6 0.6666667          0

```
