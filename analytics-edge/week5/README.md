## Text Analysis using Tweets

is hard since

- Homonyms
- Metaphors
- Sarcasm

### Twitter Data

- Output variable: **Amazon Mechanical Turk**

### A Bag of Words

Since fully understanding text is difficult, we can use simpler approach. Count the number of times each words appears.

### Cleaning up irregularities

`PoWer`, `POWER` -> `power`

### Removing Stopwords

Only meaningful in a sentence. (e.g *the, is, at, which*). There are unlikely to improve machine learning prediction quality.

### Stemming

`argue`, `argued`, `argues`, `arguing`. These words can be represented by a common **stem** `argu`.

Algorithmic process of performing this reduction is called stemming.

(1) Database of words

- **Pro:** handles exceptions
- **Con:** won't handle new words, band for the Internet

(2) Rule-based algorithm

- **Pro:** handles new/unknown words well
- **Con:** many exceptions, misses words like *child* and *children*

(3) Porter Stemmer

### in R 

```R
> str(tweets)
'data.frame':	1181 obs. of  2 variables:
 $ Tweet: Factor w/ 1133 levels "text example1"| __truncated__,..: 658 1068 754 905 57 324 819 1117 9 745 ...
 $ Avg  : num  2 2 1.8 1.8 1.8 1.8 1.8 1.6 1.6 1.6 ...

> tweets$Negative = as.factor(tweets$Avg <= -1)
```

[CRAN: tm package](http://cran.r-project.org/web/packages/tm/index.html)

the `tm` package introduces a concept called **corpus**.

A corpus is a collection of documents. We'll need to convert our tweets to a corpus for pre-processing. `tm` can create a corpus in many different ways. 

### Pre-processing

```R
> corpus = Corpus(VectorSource(tweets$Tweet))

> corpus = Corpus(VectorSource(tweets$Tweet))
> corpus[[1]]
<<PlainTextDocument (metadata: 7)>>
I have to say, Apple has by far the best customer care service I have ever received! @Apple @AppStore
> corpus = tm_map(corpus, PlainTextDocument)
> corpus = tm_map(corpus, content_transformer(tolower))
> corpus[[1]]
<<PlainTextDocument (metadata: 7)>>
i have to say, apple has by far the best customer care service i have ever received! @apple @appstore
> corpus = tm_map(corpus, removePunctuation)
> corpus[[1]]
<<PlainTextDocument (metadata: 7)>>
i have to say apple has by far the best customer care service i have ever received apple appstore
> corpus = tm_map(corpus, removeWords, c("apple", stopwords("english")))
> corpus[[1]]
<<PlainTextDocument (metadata: 7)>>
   say    far  best customer care service   ever received  appstore
> corpus = tm_map(corpus, stemDocument)
> corpus[[1]]
<<PlainTextDocument (metadata: 7)>>
   say    far  best custom care servic   ever receiv  appstor
> 
```

### Bag of words

The `tm` package provides a function called `DocumentTermMatrix` that generates a matrix where thr rows coreespond to documents, in our case tweets, and columns correspond to words in throse tweets.

The value in the matrix are the number of times that word appears in each document.

```R
> frequencies = DocumentTermMatrix(corpus)
frequencies
> <<DocumentTermMatrix (documents: 1181, terms: 3289)>>
Non-/sparse entries: 8980/3875329
Sparsity           : 100%
Maximal term length: 115
Weighting          : term frequency (tf)
> inspect(frequencies[1000:1005, 505:515])
<<DocumentTermMatrix (documents: 6, terms: 11)>>
Non-/sparse entries: 1/65
Sparsity           : 98%
Maximal term length: 9
Weighting          : term frequency (tf)

              Terms
Docs           cheapen cheaper check cheep cheer cheerio cherylcol chief
  character(0)       0       0     0     0     0       0         0     0
  character(0)       0       0     0     0     0       0         0     0
  character(0)       0       0     0     0     0       0         0     0
  character(0)       0       0     0     0     0       0         0     0
  character(0)       0       0     0     0     0       0         0     0
  character(0)       0       0     0     0     1       0         0     0
              Terms
Docs           chiiiiqu child children
  character(0)        0     0        0
  character(0)        0     0        0
  character(0)        0     0        0
  character(0)        0     0        0
  character(0)        0     0        0
  character(0)        0     0        0
  ```

This data is what we call sparse. This means that there are **many zeros** in our matrix.

Alos, we can find most freq terms (words) using `findFreqTerms` function.

```R
> findFreqTerms(frequencies, lowfreq=20)
 [1] "android"              "anyon"                "app"                 
 [4] "appl"                 "back"                 "batteri"             
 [7] "better"               "buy"                  "can"                 
[10] "cant"                 "come"                 "dont"                
[13] "fingerprint"          "freak"                "get"                 
[16] "googl"                "ios7"                 "ipad"                
[19] "iphon"                "iphone5"              "iphone5c"            
[22] "ipod"                 "ipodplayerpromo"      "itun"                
[25] "just"                 "like"                 "lol"                 
[28] "look"                 "love"                 "make"                
[31] "market"               "microsoft"            "need"                
[34] "new"                  "now"                  "one"                 
[37] "phone"                "pleas"                "promo"               
[40] "promoipodplayerpromo" "realli"               "releas"              
[43] "samsung"              "say"                  "store"               
[46] "thank"                "think"                "time"                
[49] "twitter"              "updat"                "use"                 
[52] "via"                  "want"                 "well"                
[55] "will"                 "work"                
> 
```

The # of terms is an issue for two main reasons.

- One is computational. (of course!)
- The other is that the ratio of indepndent variables to observations will affect how good the model will generalize.

Now, remove sparse terms.

```R
# remove some sparse terms
# only keep terms that appear in 0.5% or more of the tweets
sparse = removeSparseTerms(frequencies, sparse=0.995)
sparse # only 309 terms

tweetsSparse = as.data.frame(as.matrix(sparse))
str(tweetsSparse)
# add `X` into some variables which startwith numbers
colnames(tweetsSparse) = make.names(colnames(tweetsSparse))
str(tweetsSparse)

tweetsSparse$Negative = tweets$Negative
str(tweetsSparse)
```

### Build CART

```R
# CART 
library(rpart)
library(rpart.plot)

twCART = rpart(Negative ~ ., data=train, method="class")
prp(twCART)
predictTwCART = predict(twCART, newdata=test, type="class")

# confusion matrix
cfMatrix = table(test$Negative, predictTwCART)
# accuracy: 0.8788
sum(diag(cfMatrix)) / sum(cfMatrix)

# baseline: 0.8450
baselineTable = table(test$Negative)
(300) / sum(baselineTable)
```

As you can see, Our CART model does better than the simple baseline model.

We can increase accuracy using **Random Forest**

```R
# random forest
library(randomForest)
set.seed(123)
twForest = randomForest(Negative ~ ., data=train)
predictTwForest = predict(twForest, newdata=test)
cfMatrix2 = table(test$Negative, predictTwForest)
# accuracy: 0.8845
sum(diag(cfMatrix2)) / sum(cfMatrix2)
```

A logistic regression model with a large number of variables is particulary at risk for overfitting.

```R
# logistic regression
twLog = glm(Negative ~ ., data=train, family = "binomial")
predictTwLog = predict(twLog, newdata=test, type="response")

# accuracy: 0.80
logCfMatrix = table(test$Negative, predictTwLog > 0.5)
sum(diag(logCfMatrix)) / sum(logCfMatrix)
```

## IBM Watson

#### Step 1: Question Analysis

Trying to find the **Lexical Answer Type** (LAT) of the question.

- Ex: *Mozart's last and perhaps most powerful symphony share its name with this planet*
- Ex: *Simmaer than only Greenland, it's the world's second largest island*

Also perform **relation detection** to find relationships among words, and **decomposition** to split the question into different clues.

#### Step 2: Hypothesis Generation

Uses the question analysis from Step 1 to product **candidate answer** by searching the databases.

Then each candidate answer plugged back into the question in place of the LAT is considered a hypothesis

- Hypothesis 1: *Mozart's last and perhaps most powerful symphony shares its name with* **Mercury**

If the correct answer is not generated at this stage, Watson has no hope of getting the question right.

This step errors on the side of generating a lot of hypotheses, and leaves it up to the next step to find the correct answer.

#### Step 3: Scoring Hypothesis

Compute **confidence levels** for each possible answer combining a large number of different methods.

- Need to accurately estimate the prob of a proposed anser being correct
- Watson will only buzz in if a confidence level is ahove a threshold.

#### Lighweight Scoring Algorithm

Watson starts with **lightweight scoring algorithms** to prune down large set of hypotheses.

- Ex: *What is the likelihood that a candidate anser is an instance of the LAT?*

If this likelihood is not very high, throw away the hypothesis.

#### Scoring Analytics

Watson uses **passage search** to gather supporting evidence for each candidate answer. Retrieve passages that contain the hypothesis text

### Step 4: Final Merging and Ranking

Select the single best supported hypothesis. To do this, need to merge similar answers. Then, Rank the hypothesis and estimate confidence using logistic regression.

The training data is a set of historical *Jeopardy* questions. Each of the scoring algorithms is an independent variable. Then, logistic regression is used to predict whether or not a candidate answer is correct.

## Predictive Coding



