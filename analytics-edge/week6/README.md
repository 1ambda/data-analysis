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





