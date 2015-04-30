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



