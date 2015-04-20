## Recommendation 

- Content Filtering
- Collaborative Filtering

### Clustering

- Hierarchical
- K-means

To make clusters, we have to define the concept of distance will be used in clustering algorithms

- Euclidean Distance
- Mahanttan Distance
- Maximum Coordinate Distance
- Minimum Distance
- Maximum Distance
- Centroid Distance 

When we are computing distances, It's highly influenced by **the scale** of the variables. So we need nomalization first 

### Hierarchical Clustering

![](http://upload.wikimedia.org/wikibooks/en/2/28/Agglomerative_clustering_dendogram.png) 

In dendrogram, the height of vertical lines represents distance between points of clusters. 

- Look at statistics (mean, min, max, etc) for each cluster and each variables
- See if the clusters have a feature in common that was not used in the clustering (like an outcome)

## Heart Attack

**Claims Data** offers an expansive view of a patient's health history. It may reveal indicative signals and patterns

- *Incorporating Clustering*: Patierns in each bucket (cluster) may have different characteristics. So we need to train models on each cluster

for example, *cluster 1, ..., k* with *model 1, ..., k*

### K-means clustering

1. Specify desired number of clusters `k`
2. Randomly assign each data pointer to a cluster
3. Compute cluster centroids
4. Re-assign each point to the closest cluster centroid
5. Re-compute cluster centroids
6. Re-compute 4 and 5 until no improvement is made

Practical Considerations

- The number of clusters `k` can be selected from previous knowledge or experiments
- Can strategically select initial partition of points into clusters if you have som knowledge of the data
- Can run algorithm several times with different random starting points

**Random Forest** + **Clustering** = **High Performance**

> If you wanted to find more unusual patterns, you would increase the number of clusters since the clusters would become smaller and more patterns would probably emerge. 

```R
movies = read.table("movieLens.txt", header=FALSE, sep="|", quote="\"")
str(movies)

colnames(movies) = c("ID", "Title", "ReleaseDate", "VideoReleaseDate", "IMDB", "Unknown", "Action", "Adventure", "Animation", "Childrens", "Comedy", "Crime", "Documentary", "Drama", "Fantasy", "FilmNoir", "Horror", "Musical", "Mystery", "Romance", "SciFi", "Thriller", "War", "Western")
str(movies)

movies$ID = NULL
movies$ReleaseDate = NULL
movies$VideoReleaseDate = NULL
movies$IMDB = NULL
str(movies)

# remove duplicated observations
movies = unique(movies)
str(movies)

table(movies$Comedy)
table(movies$Western)
table(movies$Romance, movies$Drama)

# hierarchical clustering
distance = dist(movies[2:20], method="euclidean")
cluster = hclust(distance, method="ward.D")
plot(cluster)

# grouping into 10 clusters
groups = cutree(cluster, k=10)
tapply(movies$Action, groups, mean)
tapply(movies$Romance, groups, mean)

# find a specific movie
subset(movies, Title == "Men in Black (1997)")
groups[257]

# adventure, action, sci-fi cluster
cluster2 = subset(movies, groups == 2)
cluster2$Title[1:10]

groups2 = cutree(cluster, k=2)
groups2[1:10]
cluster2[6, ]
tapply(movies$Drama, groups2, mean)

# simply
colMeans(subset(movies[2:20], groups2 == 2))
```

## Image Segmentation

> `n*(n-1) / 2` pairwise distance computation required

```R
# gray scale image segmentation using K-means
# gray scale. all the intensity values ranging from 0 to 1
flower = read.csv("flower.csv", header=FALSE)
str(flower)

# convert data frame into matrix
flowerMatrix = as.matrix(flower)
str(flowerMatrix)

# convert matrix into vector. we can't convert directly frame into vector
flowerVector = as.vector(flowerMatrix)
str(flowerVector)

# 1. create diatance matrix
distance = dist(flowerVector, method="euclidean")

# 2. create intensity cluster
cluster = hclust(distance, method="ward.D")
plot(cluster)
rect.hclust(cluster, k=3, border="red")

flowerCluster = cutree(cluster, k=3)
table(flowerCluster)
tapply(flowerVector, flowerCluster, sum)

# convert vector into matrix to draw image
dim(flowerCluster) = c(50, 50)
image(flowerCluster, axes=FALSE) # clustered pixels
image(flowerMatrix,  axes=FALSE, col = grey(seq(0, 1, length=256))) # original
```

### MRI image segmentation using K-means

```R
healthy = read.csv("healthy.csv", header=FALSE)
str(healthy)

# convert frame into matrix
healthyMatrix = as.matrix(healthy)
str(healthyMatrix)

image(healthyMatrix, axes=FALSE, col=grey(seq(0, 1, length=256)))

# convert matrix into vector
healthyVector = as.vector(healthyMatrix)

# we can't create distance matrix
str(healthyVector)
# n = 365636, so n*(n-1)/12 = 66844659430 computation required
# so we can't use hierarchical clustering because of high resolution
# distance = dist(healthyVector, method="euclidean")

# K-means clustering
k = 5
set.seed(1)
KMC = kmeans(healthyVector, centers=k, iter.max=1000)

str(KMC)

cluster = KMC$cluster
KMC$centers[2]

# convert vector into matrix
dim(cluster) = c(nrow(healthyMatrix), ncol(healthyMatrix)) 
image(cluster, axes=FALSE, col=rainbow(k))
```

### Detecting Tumors 

```R
# detecting tumors
tumor = read.csv("tumor.csv", header=FALSE)
str(tumors)
tumorMatrix = as.matrix(tumor)
tumorVector = as.vector(tumorMatrix)

# we will treat the healthy vector as training set
# and the tumor vector as a testing set

install.packages("flexclust")
library(flexclust)

# class KCCA stands for K-Centroids Cluster Analysis
KMC.kcca = as.kcca(KMC, healthyVector) # use training set
str(KMC.kcca)

tumorClusters = predict(KMC.kcca, newdata=tumorVector)
dim(tumorClusters) = c(nrow(tumorMatrix), ncol(tumorMatrix))
image(tumorClusters, axes=FALSE, col=rainbow(k))
```

#### Healty Brain

![](https://raw.githubusercontent.com/1ambda/data-analysis/master/analytics-edge/week6/images/healthy.png) 

### Tumor (red area)

![](https://raw.githubusercontent.com/1ambda/data-analysis/master/analytics-edge/week6/images/tumor.png) 

<br/>

### Comparison of Methods

(1) **Linear Regression**

Can predicting a continuous outcome.

- Simple, well recognized
- Works on small and large datasets

But,

- Assumes a linear relationship (`Y = a log(X) + b`)

(2) **Logistic Regression**

Can predict a categorical outcomes.

- Computes probabilties that can be used to assess confidence of the prediction

But,

- Assume a linear relationship

(3) **CART**

Can predict a categorical outcome.

- Can handle datasets without a lienar relationship
- Easy to explain and interpret

But,

- May not work well with small datasets

(4) **Random Forest**

Same as CART

- Can improve accuracy over CART

But,

- Many parameters to adjust
- **NOT** as easy to explain as CART

(5) Hierarchical Clustering

Finding similar groups and Cluster into smaller groups and **applying predictive methods on groups**

- No need to select number of clusters a priori
- Visualize with a dendogram

But,

- **Hard to use with large datasets**

(6) K-means Clustering

Same as Hierarchical Clustering

- Works with any dataset size

But,

- need to select number of clusters before running algortihm

### Stock Prediction: Logistic Reg + Clustering

**We can improve our logistic regression models using clustering**

```R
# PREDICTING STOCK RETURNS

stocks = read.csv("StocksCluster.csv")
str(stocks)

## Q 1.2
table(stocks$PositiveDec) / nrow(stocks) # or simply use 'mean' 

## Q 1.3
sort(cor(stocks))

## Q 1.4
summary(stocks)

## Q 2.1
set.seed(144)
library(caTools)
split = sample.split(stocks$PositiveDec, SplitRatio = 0.7)
train = subset(stocks, split == TRUE)
test  = subset(stocks, split == FALSE)

stocksLog = glm(PositiveDec ~ ., data=train, family=binomial)
predLogTrain = predict(stocksLog, type="response")
cfMatrixLogTrain = table(train$PositiveDec, predLogTrain > 0.5)
accuracyLogTrain = sum(diag(cfMatrixLogTrain)) / sum(cfMatrixLogTrain)

## 2.2
predLogTest = predict(stocksLog, newdata=test, type="response")
cfMatrixLogTest = table(test$PositiveDec, predLogTest > 0.5)
accuracyLogTest = sum(diag(cfMatrixLogTest)) / sum(cfMatrixLogTest)

## 2.3: baseline
mean(test$PositiveDec)

## 3.1 clustering

# Needing to know the dependent variable value to assign an observation
# to a cluster defeats the purpose of the methodology
cTrain = train
cTrain$PositiveDec = NULL
cTest = test
cTest$PositiveDec = NULL

## 3.2
library(caret)
preproc = preProcess(cTrain)
normTrain = predict(preproc, cTrain)
normTest  = predict(preproc, cTest)

mean(normTrain$ReturnJan)
mean(normTest$ReturnJan)

## 3.3
# Since normTest was constructed by subtracting by the mean `ReturnJan` value
# from the training set,
# this explains why the mean value of RegurnJan is slightly negative in normTest

## 3.4
set.seed(144)
k = 3
km = kmeans(normTrain, centers=3)
kClustersTrain = km$cluster

table(kClustersTrain)

## 3.5 prediction using clusters (flexclust package)
library(flexclust)
km.kcca = as.kcca(km, normTrain) # K-Centroids Cluster Analysis
clusterTrain = predict(km.kcca)
clusterTest  = predict(km.kcca, newdata=normTest)

table(clusterTest)

## Q 4.1
stockTrain1 = subset(train, clusterTrain == 1)
stockTrain2 = subset(train, clusterTrain == 2)
stockTrain3 = subset(train, clusterTrain == 3)
stockTest1 = subset(test, clusterTest == 1)
stockTest2 = subset(test, clusterTest == 2)
stockTest3 = subset(test, clusterTest == 3)

tapply(train$PositiveDec, clusterTrain, mean)
tapply(test$PositiveDec, clusterTest, mean)

## Q 4.2
stockLogModel1 = glm(PositiveDec ~ ., data=stockTrain1, family="binomial")
stockLogModel2 = glm(PositiveDec ~ ., data=stockTrain2, family="binomial")
stockLogModel3 = glm(PositiveDec ~ ., data=stockTrain3, family="binomial")

summary(stockLogModel1)
# + Jan, Mar, Apr, May, July, Aug, Sep, Oct
# - Feb, Nov, June

summary(stockLogModel2)
# + Jan, Feb, Apr, May, June, July, Sep, 
# - Mar, Aug, Oct, Nov

summary(stockLogModel3)
# + Mar, Apr, May, June, July, Aug, Sep, Oct
# - Jan, Feb, Nov

## Q 4.3
predTest1 = predict(stockLogModel1, newdata=stockTest1, type="response")
predTest2 = predict(stockLogModel2, newdata=stockTest2, type="response")
predTest3 = predict(stockLogModel3, newdata=stockTest3, type="response")

cfMatrix1 = table(stockTest1$PositiveDec, predTest1 > 0.5)
cfMatrix2 = table(stockTest2$PositiveDec, predTest2 > 0.5)
cfMatrix3 = table(stockTest3$PositiveDec, predTest3 > 0.5)

accuracy1 = sum(diag(cfMatrix1)) / sum(cfMatrix1) # 0.6194
accuracy2 = sum(diag(cfMatrix2)) / sum(cfMatrix2) # 0.5504
accuracy3 = sum(diag(cfMatrix3)) / sum(cfMatrix3) # 0.6458

## 4.4
AllPredictions = c(predTest1, predTest2, predTest3)
AllOutcomes    = c(stockTest1$PositiveDec, stockTest2$PositiveDec, stockTest3$PositiveDec)

cfMatrixAll = table(AllOutcomes, AllPredictions > 0.5)
OverAllAccuracy = sum(diag(cfMatrixAll)) / sum(cfMatrixAll)
OverAllAccuracy # 0.5788716

# baseline : 0.5460564
# only logistic reg: 0.5670697

# summary: we can improve our logistic regression model with clustering
```

### User Segmentation

```R
airlines = read.csv("AirlinesCluster.csv")

## Q 1.1
summary(airlines)

## Q 1.2 - Normalizing
## If we don't normalize the data, the clustering will be dominated
## by the variables that are on a large scale

## Q 1.3
install.packages("caret")
library(caret)

preproc = preProcess(airlines)
airlinesNorm = predict(preproc, airlines)
summary(airlinesNorm)

# Hierarchical Clustering

## Q 2.1
airlinesMatrix = as.matrix(airlinesNorm)
airlinesVector = as.vector(airlinesMatrix)
distance = dist(airlinesNorm, method = "euclidean")

dendrogram = hclust(distance, method="ward.D")
plot(dendrogram)
hClusters = cutree(dendrogram, k = 5)

## Q 2.2
table(hClusters)

## Q 2.3
for (name in names(airlines)) {
    print(name)
    print(tapply(airlines[[name]], hClusters, mean))
}

## Q 3.1
set.seed(88)
k = 5

KMC = kmeans(airlinesNorm, centers=5, iter.max=1000)
kClusters = KMC$cluster
table(kClusters)
str(KMC)

## Q 3.2
table(hClusters, kClusters)
```

### Clusetring Blog Articles

**Hierarchical** vs **K-means**

```R
# hierarchical clustering
dailykos = read.csv("dailykos.csv")
str(dailykos)

## 1. convert frame into vector
dailykosMatrix = as.matrix(dailykos)
dailykosVector = as.vector(dailykos)

## 2. get distance. takes long time
distance = dist(dailykosVector, method = "euclidean")

## 3. build hierarchical clustering
hCluster = hclust(distance, method="ward.D")

## 4. plot dendogram
plot(hCluster)

## 5. select 7 clusters
rect.hclust(hCluster, k=7, border="red")

## 6. split data into 7 clusters
hClusters = cutree(hCluster, k=7)

## Q 1.4 
table(hClusters)

## Q 1.5 - look at the top n works in each cluster
hc1 = subset(dailykos, hClusters == 1)
tail(sort(colMeans(hc1)))

## Q 1.6
hc2 = subset(dailykos, hClusters == 2)
tail(sort(colMeans(hc2)))

hc3 = subset(dailykos, hClusters == 3)
tail(sort(colMeans(hc3)))

hc4 = subset(dailykos, hClusters == 3)
tail(sort(colMeans(hc4)))

hc5 = subset(dailykos, hClusters == 5)
tail(sort(colMeans(hc5)))

hc6 = subset(dailykos, hClusters == 6)
tail(sort(colMeans(hc6)))

hc7 = subset(dailykos, hClusters == 7)
tail(sort(colMeans(hc7)))

# K-means clustering
k = 7
set.seed(1000)
KMC = kmeans(dailykosVector, centers=k)
kClusters = KMC$cluster

## Q 2.1
table(kClusters)

## Q 2.2

kc1 = subset(dailykosVector, kClusters == 1)
kc2 = subset(dailykosVector, kClusters == 2)
kc3 = subset(dailykosVector, kClusters == 3)
kc4 = subset(dailykosVector, kClusters == 4)
kc5 = subset(dailykosVector, kClusters == 5)
kc6 = subset(dailykosVector, kClusters == 6)
kc7 = subset(dailykosVector, kClusters == 7)

tail(sort(colMeans(kc1)))
tail(sort(colMeans(kc2)))
tail(sort(colMeans(kc3)))
tail(sort(colMeans(kc4)))
tail(sort(colMeans(kc5)))
tail(sort(colMeans(kc6)))
tail(sort(colMeans(kc7)))


## Q 2.3
table(hClusters, kClusters)
tail(sort(colMeans(kc2)))
tail(sort(colMeans(hc7)))

## Q 2.4
tail(sort(colMeans(kc3)))
tail(sort(colMeans(hc5)))

## Q 2.5
tail(sort(colMeans(kc7)))
tail(sort(colMeans(hc1)))
tail(sort(colMeans(hc4)))

## Q 2.6
table(hClusters, kClusters)
tail(sort(colMeans(kc6)))
tail(sort(colMeans(hc2)))
```
