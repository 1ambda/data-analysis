
emails = read.csv("emails.csv", stringsAsFactors=FALSE)
str(emails)

table(emails$spam)

# 1.3
emails$text[[1]]

# 1.5
max(nchar(emails$text))

# 1.6
which.min(nchar(emails$text))

# 2.1: building a model
library(tm)
corpus = Corpus(VectorSource(emails$text))
corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords("english"))
corpus = tm_map(corpus, stemDocument)
dtm = DocumentTermMatrix(corpus)

# 2.2
spdtm = removeSparseTerms(dtm, 0.95)

# 2.3
emailSparse = as.data.frame(as.matrix(spdtm))
# make syntactically valid names
colnames(emailSparse) = make.names(colnames(emailSparse))
# the most freq word
which.max(colSums(emailSparse))

# 2.4
emailSparse$spam = emails$spam
freqHams = (colSums(subset(emailSparse, spam == 0)) >= 5000)
table(freqHams)["TRUE"]

# 2.5
freqSpams = (colSums(subset(emailSparse, spam == 1)) >= 1000)
table(freqSpams)["TRUE"] # varaible "spam" is the dependent varaible
# or sort(colSums(subset(emailSparse, spam == 1)))

# 3.: Building ML models
emailSparse$spam = as.factor(emailSparse$spam) # convert to factor var

# split data
library(caTools)
set.seed(123)

split = sample.split(emailSparse$spam, SplitRatio = 0.7)
train = subset(emailSparse, split == TRUE)
test  = subset(emailSparse, split == FALSE)

library(rpart)
library(rpart.plot)
library(randomForest)

spamLog = glm(spam ~ ., data=train, family=binomial)
spamCART = rpart(spam ~., data=train, method="class") # binary classification prb
set.seed(123)
spamRF = randomForest(spam ~., data=train)

# get probabilities
predTrainLog = predict(spamLog, type="response")
predTrainCART = predict(spamCART)[, 2]
predTrainRF = predict(spamRF, type="prob")[, 2]

# when doing logistic regression if you get
# "algorithm didn't converge", "fitted prob numerically 0 or 1 occured" means
# 'overfitting', first message indicates particularly severe overffting
table(predTrainLog < 0.00001)
table(predTrainLog > 0.99999)

# 3.2: no significant variables is a symptom of logistric regression no converging
summary(spamLog)

# 3.3
prp(spamCART)

# 3.4: log accuracy: 0.9990025 which is meaning severe overfitting
cfMatrixTrainLog = table(train$spam, predTrainLog >= 0.5)
accuracyTrainLog = sum(diag(cfMatrixTrainLog)) / sum(cfMatrixTrainLog)

# 3.5 log AUC: 0.9999959
library(ROCR)
predROCRTrainLog = prediction(predTrainLog, train$spam)
predAUCTrainLog = performance(predROCRTrainLog, "auc")@y.values

# 3.6: CART accuracy: 0.6117207
# or just
# predTrainCART = predict(spamCART, type="class") : using classification type
# cfMatrixTrainCART = table(train$spam, predTrainCART)
cfMatrixTrainCART = table(train$spam, predTrainCART > 0.5)
accuracyTrainCART = sum(diag(cfMatrixTrainCART)) / sum(cfMatrixTrainCART)
accuracyTrainCART

# 3.7: CART AUC: 0.9696044
predROCRTrainCART = prediction(predTrainCART, train$spam)
predAUCTrainCART = performance(predROCRTrainCART, "auc")@y.values
predAUCTrainCART

# 3.8 Random Forest accuracy: 0.9793017
# or just 
# predTrainRF = predict(spamRF)
# cfMatrixTrainRF = table(train$spam, predTrainRF)
cfMatrixTrainRF = table(train$spam, predTrainRF > 0.5)
accuracyTrainRF = sum(diag(cfMatrixTrainRF)) / sum(cfMatrixTrainRF)
accuracyTrainRF

# 3.9 Random Forest AUC: 0.9979116
predROCRTrainRF = prediction(predTrainRF, train$spam)
predAUCTrainRF  = performance(predROCRTrainRF, "auc")@y.values
predAUCTrainRF

# 4.1: Logistic Regression accuracy: 0.9505239
predTestLog  = predict(spamLog, newdata=test, type="response")
predTestCART = predict(spamCART, newdata=test)[, 2]
predTestRF   = predict(spamRF, newdata=test, type="prob")[, 2]

cfMatrixTestLog = table(test$spam, predTestLog > 0.5)
accuracyTestLog = sum(diag(cfMatrixTestLog)) / sum(cfMatrixTestLog)
accuracyTestLog

# 4.2 LR AUC: 0.9627517
predROCRTestLog = prediction(predTestLog, test$spam)
predAUCTestLog  = performance(predROCRTestLog, "auc")@y.values
predAUCTestLog

# 4.3 CART accuracy: 0.9394645
cfMatrixTestCART = table(test$spam, predTestCART > 0.5)
accuracyTestCART = sum(diag(cfMatrixTestCART)) / sum(cfMatrixTestCART)
accuracyTestCART 

# 4.4 CART AUC: 0.963176
predROCRTestCART = prediction(predTestCART, test$spam)
predAUCTestCART  = performance(predROCRTestCART, "auc")@y.values
predAUCTestCART

# 4.5 RF accuracy: 0.9749709
cfMatrixTestRF = table(test$spam, predTestRF > 0.5)
accuracyTestRF = sum(diag(cfMatrixTestRF)) / sum(cfMatrixTestRF)
accuracyTestRF 

# 4.5 RF AUC: 0.9975656
predROCRTestRF = prediction(predTestRF, test$spam)
predAUCTestRF  = performance(predROCRTestRF, "auc")@y.values
predAUCTestRF  

# as you can see,
# logistic regression model demonstrates the greatest degree of overfitting
# Both CART and RF had very similary accuracies on the training and testing sets.
# However, logistic regression obtained neary perfect at training set and
# poor performance on the testing sets
