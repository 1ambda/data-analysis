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
