emails = read.csv("energy_bids.csv", stringsAsFactors=FALSE)
str(emails)

emails$email[1]
strwrap(emails$email[1])
emails$responsive[1]

strwrap(emails$email[2])
emails$responsive[2]

# unbalanced: typical in predictive coding problems.
table(emails$responsive)

library(tm)
corpus = Corpus(VectorSource(emails$email))
strwrap(corpus[[1]])

# pre-processing
# corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords("english"))
corpus = tm_map(corpus, stemDocument)
strwrap(corpus[[1]])

# remove sparse words 
dtm = DocumentTermMatrix(corpus)
dtm # document: 855, terms: 22064
dtm = removeSparseTerms(dtm, 0.97)
dtm # document: 855, terms: 788

labeledTerms = as.data.frame(as.matrix(dtm))
labeledTerms$responsive = emails$responsive
str(labeledTerms)

# split data
library(caTools)
set.seed(144)
split = sample.split(labeledTerms$responsive, SplitRatio=0.7)
train = subset(labeledTerms, split == TRUE)
test = subset(labeledTerms, split == FALSE)

# CART
library(rpart)
library(rpart.plot)
emailCART = rpart(responsive ~ ., data=train, method="class")
prp(emailCART)

pred = predict(emailCART, newdata=test)
pred[1:10, ]
pred.prob = pred[, 2]
# confusion matrix
cfm = table(test$responsive, pred.prob >= 0.5)
accuracy = sum(diag(cfm)) / sum(cfm) # 0.856
baseline = 215 / (nrow(test)) # 0.836

# in predictive coding
# we'll assign a higher cost to false negative than false positive
library(ROCR)
predROCR = prediction(pred.prob, test$responsive)
perfROCR = performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize=TRUE)

# AUC: 0.7936
# our model can differentiate between a randomly selected 
# responsive and non-reponsive
AUC = performance(predROCR, "auc")@y.values
