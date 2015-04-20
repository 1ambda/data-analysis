
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
