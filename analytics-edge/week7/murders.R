murders = read.csv("murders.csv")
str(murders)

# US 
stateMap = map_data("state")
str(stateMap)

library(ggplot2)
ggplot(stateMap, aes(x=long, y=lat, group=group)) + geom_polygon(fill="white", color="black")

murders$region = tolower(murders$State)
# join stateMap and murders using "region" field
murderMap = merge(stateMap, murders, by="region")
str(murderMap)

ggplot(murderMap, aes(x = long, y = lat, group=group, fill=Murders)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide="legend")

# due to large population
ggplot(murderMap, aes(x = long, y = lat, group=group, fill=Population)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide="legend")

# create new variable MurderRate
murderMap$MurderRate = murderMap$Murders / murderMap$Population * 100000
str(murderMap$MurderRate)

ggplot(murderMap, aes(x = long, y = lat, group=group, fill=MurderRate)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide="legend")

# Washington DC is an outlier with a very high murder rate,
# but it's such a small region on the map that we cannot even see it.
# so remove observations with murder rate above 10
ggplot(murderMap, aes(x = long, y = lat, group=group, fill=MurderRate)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide="legend", limits=c(0, 10))

# GunOwnership Rate
ggplot(murderMap, aes(x = long, y = lat, group=group, fill=GunOwnership)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide="legend")
