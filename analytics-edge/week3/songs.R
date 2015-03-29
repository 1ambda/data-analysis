songs = read.csv("songs.csv")
str(songs)
table(songs$year)

MichaelJackson = subset(songs, artistname == "Michael Jackson")
MichaelJackson$songtitle = factor(MichaelJackson$songtitle)
str(MichaelJackson$songtitle) # drop unused factor

table(MichaelJackson$songtitle, MichaelJackson$Top10)
table(songs$timesignature)

# 1.5
songs$songtitle[which.max(songs$tempo)]

# 2.1
songsTrain = subset(songs, year <= 2009)
songsTest = subset(songs, year == 2010)

# 2.2 remove non-numeric variables from training, test set
nonvars = c("year", "songtitle", "artistname", "songID", "artistID")
songsTrain = songsTrain[, !(names(songs) %in% nonvars)]
songsTest = songsTest[, !(names(songs) %in% nonvars)]

# build logistic regresison model
songsLog1 = glm(Top10 ~ ., data=songsTrain, family=binomial)
summary(songsLog1)

cor(songsTrain$loudness, songsTrain$energy) # multicollinearity

# 3.1
songsLog2 = glm(Top10 ~ . - loudness, data=songsTrain, family=binomial)
summary(songsLog2)

# 3.2
songsLog3 = glm(Top10 ~ . - energy, data=songsTrain, family=binomial)
summary(songsLog3)

# 4.1

predictTest = predict(songsLog3, type="response", newdata=songsTest)
table(songsTest$Top10, predictTest > 0.45)

# baseline model
table(songsTest$Top10)
(314) / (314 + 59)

