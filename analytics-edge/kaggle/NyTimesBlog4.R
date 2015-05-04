
# submission 4: Logistic + Clustering

## libraries
library(ggplot2)
library(caTools)
library(rpart)
library(rpart.plot)
library(randomForest)
library(reshape)
library(data.table)
library(cluster)
library(fpc)

Sys.setlocale("LC_ALL", "C")

blogsTrain = read.csv("NYTimesBlogTrain.csv")
blogsTest  = read.csv("NYTimesBlogTest.csv")

## training

### k-means clustering 
data = blogsTrain
data = data.frame(setDT(data)[,c("SubsectionName", "Snippet", "Headline", "Abstract", "WordCount", "PubDate", "Popular"):=NULL])

# convert long-format into wide-format
data = data.frame(data, value=1.0)
temp1 = cast(data, UniqueID ~ NewsDesk, fill=0.0) 
temp2 = cast(data, UniqueID ~ SectionName, fill=0.0)
merged = merge(temp1, temp2, by = "UniqueID")
str(merged)

set.seed(2015)
k = 3
km = kmeans(merged[, -1], centers = k) # kmeans except UniqueID

# plotcluster(merged, km$cluster)
table(km$cluster) # A: 3138, B: 1548, C: 1846

A = data.frame(merged[km$cluster==1, ])
colSums(A[, -1]) # Travel, Opinion, Arts, Styles, Health, Culture, Foreign. No Business

B = data.frame(merged[km$cluster==2, ])
colSums(B[, -1]) # US, Multimedia, Opinion, V1.x, V1.y (no tagged)

C = data.frame(merged[km$cluster==3, ])
colSums(C[, -1]) # Business, Tech, Crosswords


## logistic regression using clustered data

## test

groupA = blogsTrain[UniqueID == A$UniqueID] 
groupB = blogsTrain[UniqueID == B$UniqueID] 
groupC = blogsTrain[UniqueID == C$UniqueID] 

cartA = rpart(Popular ~ NewsDesk + SectionName, data=groupA, method="class")
cartB = rpart(Popular ~ NewsDesk + SectionName, data=groupB, method="class")
cartC = rpart(Popular ~ NewsDesk + SectionName, data=groupC, method="class")

## preparation for submission

test = blogsTest
test = data.frame(setDT(test)[,c("SubsectionName", "Snippet", "Headline", "Abstract", "WordCount", "PubDate"):=NULL])

# convert long-format into wide-format
test = data.frame(test, value=1.0)
temp1 = cast(test, UniqueID ~ NewsDesk, fill=0.0) 
temp2 = cast(test, UniqueID ~ SectionName, fill=0.0)
merged = merge(temp1, temp2, by = "UniqueID")

set.seed(2016)
k = 3
km = kmeans(merged[, -1], centers = k) # kmeans except UniqueID

// plotcluster(merged, km$cluster)
table(km$cluster) # A: 1290, B: 102, C: 478 

A = data.frame(merged[km$cluster==1, ])
colSums(A[, -1]) # Travel, Opinion, Arts, Styles, Health, Culture, Foreign. No Business

B = data.frame(merged[km$cluster==2, ])
colSums(B[, -1]) # US, Multimedia, Opinion, V1.x, V1.y (no tagged)

C = data.frame(merged[km$cluster==3, ])
colSums(C[, -1]) # Business, Tech, Crosswords


## submission
