##---import files---##

getwd()
testvar <- read.csv("../test_variants.csv",header=TRUE)
traintvar <- read.csv("../training_variants.csv",header=TRUE)

dat <- readLines("../test_text_new_delim.txt") #turn into a character vector of 5669 elements
splitdat<-strsplit(dat,split="^%^",fixed=TRUE) #turn into a list of ID and text
head(splitdat) #file is too big, faster to just see head/tails
subtest<-sapply(splitdat,function(x)x[2]) #subset the text portion because ID numbers are just number sequences
head(subtest,n=2) #check only texts are returned and in right order
ID=-1:5667 #prepare an ID vector, created a "-1" ID because of difficult in removing the first "NA" in the text character vector
Text=rep(NA,times=5669) #inserting NA to match length with the ID and prepare for a dataframe
testdf2=as.data.frame(cbind(ID,Text)) #convert type into data frame
length(subtest) #check the length of text to make sure it matches the nrow of testdf
nrow(testdf2) #check nrow of testdf
testdf2$Text<-subtest #insert the character vector into the dataframe
head(testdf, n=1) #check text exists and ID matches
tail(testdf, n=1) #check the end of the document
testdf<-testdf2 
names(testdf)<-c("ID","Text") 
testdf<-testdf[-1,] #remove the ID=-1 and the NA
head(testdf,n=1) #check the first row is now the original first record, but index of the dataframe is weird, off by 2
rownames(testdf)<-1:nrow(testdf) #switch back to normal index

train <- readLines("../training_text_new_delim.txt") 
splittrain<-strsplit(train,split="^%^",fixed=TRUE) 
head(splittrain) 
subtrain<-sapply(splittrain,function(x)x[2]) 
head(subtrain,n=2) 
trainID=-1:3320 
trainText=rep(NA,times=3322) 
traindf=as.data.frame(cbind(trainID,trainText)) 
length(subtrain) 
nrow(traindf) 
traindf$trainText<-subtrain 
head(traindf, n=1) 
tail(traindf, n=1) 
names(traindf)<-c("ID","Text")
traindf<-traindf[-1,] 
head(traindf,n=1) 
rownames(traindf)<-1:nrow(traindf) 
