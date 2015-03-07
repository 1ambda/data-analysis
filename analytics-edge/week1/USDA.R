USDA = read.csv("USDA.csv")

tapply(USDA$Iron, USDA$Protein, summary, na.rm=TRUE)
