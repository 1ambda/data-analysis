edges = read.csv("edges.csv")
users = read.csv("users.csv")

str(edges)
str(users)

table(users$school, users$region)
table(users$gender, users$school)

(table(edges$V1))
sum(table(edges$V2)) / 59 * 2 

# 2.1
install.packages("igraph")
library(igraph)

# igraph: http://www.inside-r.org/packages/cran/igraph/docs/graph.data.frame
# edges, directed, vertices
g = graph.data.frame(edges, FALSE, users)

# 2.2
plot(g, vertex.size=5, vertex.label=NA)

# 2.3
degree(g)
table(degree(g) >= 10)

V(g)$size = degree(g)/2 + 2
plot(g, vertex.label=NA)

table(V(g)$size)
summary(degree(g)) / 2 + 2

# 3.1 - color
V(g)$color = "black"
V(g)$color[V(g)$gender == "A"] = "red"
V(g)$color[V(g)$gender == "B"] = "gray"
plot(g, vertex.label=NA)

# 3.2 - color using school
V(g)$color[V(g)$school == "A"] = "red"
V(g)$color[V(g)$school == "AB"] = "grey"
plot(g, vertex.label=NA)

# 3.3 - color using local 
V(g)$color[V(g)$locale == "A"] = "red"
V(g)$color[V(g)$locale == "B"] = "grey"
plot(g, vertex.label=NA)






