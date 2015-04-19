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
