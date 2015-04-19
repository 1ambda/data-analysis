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



