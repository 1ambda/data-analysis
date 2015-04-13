trials = read.csv("clinical_trial.csv", stringsAsFactors=FALSE)
str(trials)

# 1.1
max(nchar((trials$abstract)))

# 1.2
table(nchar(trials$abstract) == 0)
table(nchar(trials$abstract) == 0)["TRUE"]

# 1.3
which.min(nchar(trials$title))
trials$title[1258]

# 2.1: text mining
library(tm)
corpusTitle    = Corpus(VectorSource(trials$title))
corpusTitle    = tm_map(corpusTitle, content_transformer(tolower))
corpusTitle    = tm_map(corpusTitle, PlainTextDocument)
corpusTitle    = tm_map(corpusTitle, removePunctuation)
corpusTitle    = tm_map(corpusTitle, removeWords, stopwords("english"))
corpusTitle    = tm_map(corpusTitle, stemDocument)
corpusAbstract = Corpus(VectorSource(trials$abstract))
corpusAbstract = tm_map(corpusAbstract, content_transformer(tolower))
corpusAbstract = tm_map(corpusAbstract, PlainTextDocument)
corpusAbstract = tm_map(corpusAbstract, removePunctuation)
corpusAbstract = tm_map(corpusAbstract, removeWords, stopwords("english"))
corpusAbstract = tm_map(corpusAbstract, stemDocument)

dtmTitle    = DocumentTermMatrix(corpusTitle)
sparseTitle    = removeSparseTerms(dtmTitle, 0.95)
dtmTitle    = as.data.frame(as.matrix(sparseTitle))
dtmAbstract = DocumentTermMatrix(corpusAbstract)
sparseAbstract = removeSparseTerms(dtmAbstract, 0.95)
dtmAbstract = as.data.frame(as.matrix(sparseAbstract))

sparseTitle
sparseAbstract

# 2.2
mean(nchar(trials$title))
mean(nchar(trials$abstract))

# 2.3
which.max(colSums(dtmAbstract))
colSums(dtmAbstract)[212]

# 3.1: building a model
colnames(dtmTitle)    = paste0("T", colnames(dtmTitle))
colnames(dtmAbstract) = paste0("A", colnames(dtmAbstract))
dtm = cbind(dtmTitle, dtmAbstract)
dtm$trial = trials$trial

# 3.2
ncol(dtm)

# 3.3: split data
library(caTools)
set.seed(144)
split = sample.split(dtm$trial, SplitRatio=0.7)
train = subset(dtm, split == TRUE)
test  = subset(dtm, split == FALSE)

library(rpart)
library(rpart.plot)
trialCART1 = rpart(trial ~ ., data=train, method="class")
pred1 = predict(trialCART1) # without default threshold
max(pred1[, 2]) # 3.5
pred1 = pred1[, 2]


cfMatrix1 = table(train$trial, pred1 > 0.5)

# 3.6
accuracy1 = sum(diag(cfMatrix1)) / sum(cfMatrix1) # 0.8233487
baseline1 = table(train$trial)["0"] / sum(table(train$trial)) # 0.5606759

# 3.7
cfMatrix1
(441) / (131 + 441) # sensitivity: 0.770979
(631) / (631 + 99)  # specificity: 0.8643836

# 4.1: Evaluating the model on the **testing** set
predTest = predict(trialCART1, newdata=test) # don't use class field to use ROCR's prediction
predTest = predTest[, 2]
testCfMatrix = table(test$trial, predTest)
testAccuracy = sum(diag(testCfMatrix)) / sum(testCfMatrix) # 0.75800645

# 4.2: ROCR
library(ROCR)
predTestROCR = prediction(predTest, test$trial)
AUC = performance(predTestROCR, "auc")@y.values
AUC

# A false negative is more costly than a false positive
# the decision maker should use a prob threshold less than 0.5 for the ML model

