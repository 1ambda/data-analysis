# Kaggle Competition: Popular News Articles

## Variables

- NewsDesk = the New York Times desk that produced the story (Business, Culture, Foreign, etc.)
- SectionName = the section the article appeared in (Opinion, Arts, Technology, etc.)
- SubsectionName = the subsection the article appeared in (Education, Small Business, Room for Debate, etc.)
- Headline = the title of the article
- Snippet = a small portion of the article text
- Abstract = a summary of the blog article, written by the New York Times
- WordCount = the number of words in the article
- PubDate = the publication date, in the format "Year-Month-Day Hour:Minute:Second"
- UniqueID = a unique identifier for each article

```R
'data.frame':	6532 obs. of  10 variables:
 $ NewsDesk      : Factor w/ 13 levels "","Business",..: 2 3 2 2 9 9 9 9 8 3 ...
 $ SectionName   : Factor w/ 16 levels "","Arts","Business Day",..: 4 2 3 3 5 5 5 5 10 2 ...
 $ SubsectionName: Factor w/ 9 levels "","Asia Pacific",..: 1 1 3 3 1 1 1 1 1 1 ...
 $ Headline      : Factor w/ 6319 levels " 1914: Turkish Desire for War",..: 3557 3704 4376 1315 4015 465 1266 1022 6128 3186 ...
 $ Snippet       : Factor w/ 6215 levels ""," Retail sales rebounded in October. Sliding oil and gas prices are giving Americans more money to spend. And Walmart tries a ne"| __truncated__,..: 315 4430 3478 777 2818 261 479 3600 2220 2935 ...
 $ Abstract      : Factor w/ 6215 levels ""," Retail sales rebounded in October. Sliding oil and gas prices are giving Americans more money to spend. And Walmart tries a ne"| __truncated__,..: 316 4430 3478 778 2819 262 480 3600 2221 2936 ...
 $ WordCount     : int  508 285 1211 1405 181 245 258 893 1077 188 ...
 $ PubDate       : Factor w/ 6523 levels "2014-09-01 00:01:32",..: 33 32 31 30 29 28 27 26 25 24 ...
 $ Popular       : int  1 0 0 1 1 1 0 1 1 0 ...
 $ UniqueID      : int  1 2 3 4 5 6 7 8 9 10 ...
```

<br/>

## Baseline Model

```R
> table(blogs$Popular)[2] / nrow(blogs)
        1 
0.1673301 

> table(blogs$Popular)

   0    1 
5439 1093 
> 
```

<br/>

## Hypothesis

- NewsDesk, SectionName + Subsection Name
- Headline
- Snippet

### 1. PubDate

```R
> table(blogs$PubWeekday, blogs$Popular)
           
               0    1
  Friday    1003  161
  Monday    1010  214
  Saturday   138   52
  Sunday     212  100
  Thursday  1033  195
  Tuesday   1016  174
  Wednesday 1027  197

> table(blogs$PubHour, blogs$Popular)
    
       0   1
  0  103  22
  1   25   3
  2   21   3
  3   57   3
  4  169   2
  5  240  11
  6  190  30
  7  369  25
  8  299  39
  9  267  49
  10 315  69
  11 414  93
  12 428  94
  13 390  57
  14 375  77
  15 345  93
  16 382  74
  17 348  52
  18 269  60
  19 140  53
  20 114  44
  21  76  34
  22  57  85
  23  46  21
  ```

as you can see

- Workday 10 ~ 23
- Friday 10 ~ 17
- Saturday X
- Sunday 18 ~ 23

### 2. NewDesk


```R
 table(blogs$NewsDesk, blogs$Popular)
          
              0    1
           1710  136
  Business 1301  247
  Culture   626   50
  Foreign   372    3
  Magazine   31    0
  Metro     181   17
  National    4    0
  OpEd      113  408
  Science    73  121
  Sports      2    0
  Styles    196  101
  TStyle    715    9
  Travel    115    1
```

`Oped`, `Science`, `Style` is popular. `Business`?

### 3. Section Name, Subsection Name

```R
> table(blogs$SectionName, blogs$Popular)
                  
                      0    1
                   2171  129
  Arts              625   50
  Business Day      999   93
  Crosswords/Games   20  103
  Health             74  120
  Magazine           31    0
  Multimedia        139    2
  N.Y. / Region     181   17
  Open                4    0
  Opinion           182  425
  Sports              1    0
  Style               2    0
  Technology        280   50
  Travel            116    1
  U.S.              405  100
  World             209    3
> 
```

`Opinion`, `Crosswords/Games`, `Health`, `U.S`, `Technology`

```R
> table(blogs$SubsectionName, blogs$Popular)
                   
                       0    1
                    3846  980
  Asia Pacific       200    3
  Dealbook           864   88
  Education          325    0
  Fashion & Style      2    0
  Politics             2    0
  Room For Debate     61    1
  Small Business     135    5
  The Public Editor    4   16
> 
```

`Dealbook`, `The Public Editor`

### 4. Logistic Regression Using Newsdesk, Section, Subsection

Let's do logistic regression using all data

```R
> log1 = glm(Popular ~ NewsDesk + SectionName + SubsectionName, data=train, family="binomial")
```

- AIC: `3595.3`
- NewsDesk: `OpEd`, `Science`, `Styles`, `TStyle`
- SectionName: `Business Day`, `Crosswords/Games`, `Multimedia`, `U.S`
- SubsectionName: `Dealbook`, `The Public Editor`
- and we found some `NA` in our model.

Now, we feed only training data into our logistic regression model.

- smaller AIC: `2530.9`
- NewsDEsk: `OpEd`, `TStyle`
- SectionName: `Crosswords/Games`, `U.S`
- SubsectionName: `The Public Editor`

somewhat disappointing

```R
> library(caTools)
> set.seed(20150430)
> split = sample.split(blogs$Popular, SplitRatio=0.7)
> train = subset(blogs, split == 1)
> test  = subset(blogs, split == 0)

> log1 = glm(Popular ~ NewsDesk + SectionName + SubsectionName, data=train, family="binomial")

> summary(log1)

Call:
glm(formula = Popular ~ NewsDesk + SectionName + SubsectionName, 
    family = "binomial", data = train)

Deviance Residuals: 
     Min        1Q    Median        3Q       Max  
-1.91830  -0.43733  -0.38370  -0.00013   2.98279  

Coefficients: (5 not defined because of singularities)
                                  Estimate Std. Error z value Pr(>|z|)    
(Intercept)                     -2.299e+00  1.156e-01 -19.894  < 2e-16 ***
NewsDeskBusiness                 9.520e-01  1.167e+00   0.816   0.4145    
NewsDeskCulture                 -2.391e-01  2.102e-01  -1.138   0.2553    
NewsDeskForeign                 -1.627e+01  6.109e+02  -0.027   0.9788    
NewsDeskMagazine                -1.627e+01  1.631e+03  -0.010   0.9920    
NewsDeskMetro                   -2.728e-01  3.335e-01  -0.818   0.4133    
NewsDeskNational                -1.627e+01  4.612e+03  -0.004   0.9972    
NewsDeskOpEd                     2.894e+00  1.144e+00   2.531   0.0114 *  
NewsDeskScience                  2.030e+01  3.428e+03   0.006   0.9953    
NewsDeskSports                  -1.627e+01  6.523e+03  -0.002   0.9980    
NewsDeskStyles                  -1.369e+00  7.281e-01  -1.881   0.0600 .  
NewsDeskTStyle                  -2.138e+00  4.266e-01  -5.011 5.42e-07 ***
NewsDeskTravel                   1.415e+01  6.523e+03   0.002   0.9983    
SectionNameArts                         NA         NA      NA       NA    
SectionNameBusiness Day         -2.091e+00  1.300e+00  -1.609   0.1076    
SectionNameCrosswords/Games      2.733e+00  1.175e+00   2.325   0.0201 *  
SectionNameHealth               -1.737e+01  3.428e+03  -0.005   0.9960    
SectionNameMagazine                     NA         NA      NA       NA    
SectionNameMultimedia           -1.627e+01  6.692e+02  -0.024   0.9806    
SectionNameN.Y. / Region                NA         NA      NA       NA    
SectionNameOpen                 -1.627e+01  3.766e+03  -0.004   0.9966    
SectionNameOpinion               6.493e-01  1.143e+00   0.568   0.5701    
SectionNameSports               -2.856e-11  9.224e+03   0.000   1.0000    
SectionNameStyle                -1.490e+01  4.612e+03  -0.003   0.9974    
SectionNameTechnology           -2.728e-01  1.178e+00  -0.232   0.8169    
SectionNameTravel               -1.627e+01  6.523e+03  -0.002   0.9980    
SectionNameU.S.                  3.966e+00  7.396e-01   5.363 8.19e-08 ***
SectionNameWorld                 3.064e-07  3.815e+03   0.000   1.0000    
SubsectionNameAsia Pacific       1.428e+01  3.766e+03   0.004   0.9970    
SubsectionNameDealbook           1.120e+00  6.022e-01   1.861   0.0628 .  
SubsectionNameEducation         -2.023e+01  4.358e+02  -0.046   0.9630    
SubsectionNameFashion & Style           NA         NA      NA       NA    
SubsectionNamePolitics          -3.966e+00  6.523e+03  -0.001   0.9995    
SubsectionNameRoom For Debate   -2.039e+00  1.525e+00  -1.337   0.1813    
SubsectionNameSmall Business            NA         NA      NA       NA    
SubsectionNameThe Public Editor  2.949e+00  1.314e+00   2.245   0.0248 *  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 4129.6  on 4571  degrees of freedom
Residual deviance: 2468.9  on 4541  degrees of freedom
AIC: 2530.9

Number of Fisher Scoring iterations: 17
```

