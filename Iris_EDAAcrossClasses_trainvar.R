#Kaggle Personalized Medicine Competition
#Part 3. 

##--comparing across classes--##

names(c1gene_count)<-c("Gene", "Count_C1")
names(c2gene_count)<-c("Gene", "Count_C2")
names(c3gene_count)<-c("Gene", "Count_C3")
names(c4gene_count)<-c("Gene", "Count_C4")
names(c5gene_count)<-c("Gene", "Count_C5")
names(c6gene_count)<-c("Gene", "Count_C6")
names(c7gene_count)<-c("Gene", "Count_C7")
names(c8gene_count)<-c("Gene", "Count_C8")
names(c9gene_count)<-c("Gene", "Count_C9")
names(c1var_count)<-c("Variation", "Count_C1")
names(c2var_count)<-c("Variation", "Count_C2")
names(c3var_count)<-c("Variation", "Count_C3")
names(c4var_count)<-c("Variation", "Count_C4")
names(c5var_count)<-c("Variation", "Count_C5")
names(c6var_count)<-c("Variation", "Count_C6")
names(c7var_count)<-c("Variation", "Count_C7")
names(c8var_count)<-c("Variation", "Count_C8")
names(c9var_count)<-c("Variation", "Count_C9")
#renamed columns in each metadata to avoid ambiguity

library(dplyr)
GeneCount_ls<-list(c1gene_count,c2gene_count,c3gene_count,c4gene_count,c5gene_count,c6gene_count,c7gene_count,c8gene_count,c9gene_count) #put dataframes into a list for more efficient function or loop design
VarCount_ls<-list(c1var_count,c2var_count,c3var_count,c4var_count,c5var_count,c6var_count,c7var_count,c8var_count,c9var_count)
PairCount_ls<-list(pair_freq_c1,pair_freq_c2,pair_freq_c3,pair_freq_c4,pair_freq_c5,pair_freq_c6,pair_freq_c7,pair_freq_c8,pair_freq_c9)

gene_classmatch<-Reduce(function(x,y)merge(x,y,all=TRUE), GeneCount_ls) #big df that shows each gene's occurence in each class
var_classmatch<-Reduce(function(x,y)merge(x,y,all=TRUE), VarCount_ls) #big df that shows each variation's occurence in each class
join_all(PairCount_ls,by=c("Gene","Variation"),type="inner") #all unique, caution: wanted to inner join individual pairs (C1&C2, C1&C3...), does this do just that or is it looking for common pairs across ALL 9 classes? 

head(GeneCount_ls[[1]])#returns the first df
length(GeneCount_ls) #9 dfs

noshare_gene<-gene_classmatch$Gene[rowSums(is.na(gene_classmatch))>7] #returns all genes that aren't shared across classes
share_gene<-gene_classmatch$Gene[!rowSums(is.na(gene_classmatch))>7] #returns all genes that are shared across classes

subset(gene_classmatch, subset=gene_classmatch$Gene==gene)

gene_query2<-function(gene){
  if (which(gene==gene_classmatch$Gene)){
    gene_rSum<-rowSums(is.na(gene_classmatch)) 
    if (gene_rSum>7) ##how to assess the rowSum for each row???
  }
}

gene_query2("AGO2")
gene_query2("ASXL1")

gene_query<-function(gene){
  if (which(gene==share_gene)){
    subset(gene_classmatch, subset=gene_classmatch$Gene==gene, na.rm=TRUE)
  } else { 
    print(paste(gene, "is unique to its class"))
  }
} #this function enables checking the genes that do occur in multiple classes but not unique to one class or not in dataset at all
gene_query("AGO2")
gene_query("AKT1")
gene_query("ASXL1")

merge(pair_freq_c1, pair_freq_c2, by.x="Gene", by.y="Variation") #0 pairs in common

##fancier version of the function, can also tell if the genes are not sharing classes 
gene_query<-function(gene){
  if (which(gene==share_gene)){
    return(paste(gene, "is in 2 or more classes"))
    if (which(gene==noshare_gene))
      return(paste(gene, "is in 1 or less class"))
  } else { print("not in dataset")
  }
}
#returns error:argument is of length zero

function(gene){
  if (is.na(gene_classmatch$Count_C1|gene_classmatch$!Count_C1)){
    return(NA)
  } else if (){
    
  }
}
#check the Class 1 with any other classes, if not both numeric, iterate through classes (Class 2 v.s Class 3)
#when there is more than two numeric values in a gene, also return that