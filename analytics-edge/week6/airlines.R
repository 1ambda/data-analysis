
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
