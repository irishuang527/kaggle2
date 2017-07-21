---
  title: "CMTH642_Assignment02_Solutions_Christopher_Scott"
author: "Christopher Scott"
date: "July 20, 2017"
output: word_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## 1. 
Create a visualization to illustrate the distribution of values for Total Fat, Protein and Carbohydrate.  (12 points) 
```{r}
# First import USDAclean csv fie on disk as USDAclean_Scott
USDAclean_Scott <- read.csv("F:/CMTH642/Assignments/Assignment02/USDAclean.csv", header = TRUE, stringsAsFactors = F)
USDAmini <- subset(USDAclean_Scott, select= c(TotalFat, Protein, Carbohydrate))
boxplot(USDAmini, ylab ='Content (grams)', las = 2, col = c('red', 'green', 'blue'), names = c('Total Fat', 'Protein', 'Carbohydrate'))
```

## 2.
Create a visualization to illustrate the relationship between a food's Total Fat content and its Calorie content.  (12 points) 
```{r}
# scatterplot and the regression line
mod1 <- lm(USDAclean_Scott$Calories ~ USDAclean_Scott$TotalFat)
plot(USDAclean_Scott$TotalFat, USDAclean_Scott$Calories, xlim=c(min(USDAclean_Scott$TotalFat), max(USDAclean_Scott$TotalFat)+20), ylim=c(min(USDAclean_Scott$Calories)-20, max(USDAclean_Scott$Calories)+20), xlab = "Total Fat", ylab = "Calories")
abline(mod1)
```

## 3.
Create a logistic regression model, using HighCalories as the dependent variable, and Carbohydrate, Protein, Total Fat and Sodium as independent variables. (16 points) 
```{r}
mod2  <- glm( formula = HighCalories ~ Carbohydrate + Protein + TotalFat + Sodium, family = binomial(), data = USDAclean_Scott)
mod2
```

## 4.
Which independent variable is not significant? (10 points) 
```{r}
# The slope of the Calories ~ Sodium is almost 0, unlike the other independenrt variables, hence it is not significant
```

## 5.
Which independent variable has the strongest positive predictive power in the model? (10 points) 
```{r}
# Take the 4 independent variables and calulate the Person correlation coefficient with HighCalories as X or Y 
cor(USDAclean_Scott$Sodium, USDAclean_Scott$HighCalories,  method = c("pearson"))
cor(USDAclean_Scott$Carbohydrate, USDAclean_Scott$HighCalories, method = c("pearson"))
cor(USDAclean_Scott$Protein, USDAclean_Scott$HighCalories, method = c("pearson"))
cor(USDAclean_Scott$TotalFat, USDAclean_Scott$HighCalories, method = c("pearson"))

cor(USDAclean_Scott$HighCalories, USDAclean_Scott$Sodium , method = c("pearson"))
cor(USDAclean_Scott$HighCalories, USDAclean_Scott$Carbohydrate , method = c("pearson"))
cor(USDAclean_Scott$HighCalories, USDAclean_Scott$Protein , method = c("pearson"))
cor(USDAclean_Scott$HighCalories, USDAclean_Scott$TotalFat ,  method = c("pearson"))

#same correlation values whether USDAclean_Scott$HighCalories is X or Y
# Carbohydarate has the most positive predictive power because it has the highest positive Pearson correlation coefficient
```

## 6.
Create a script for a HealthCheck function to detect unhealthy foods. Foods that are high in salt, sugar and fat fail the HealthCheck, while all other foods pass. Foods that pass the HealthCheck should be assigned a 1, while foods that fail should be assigned a 0. Use the algorithm flowchart below as a basis for this script. (20 points)

## 7.
Add a new column called HealthCheck to the USDAclean data frame using the output of the function. (10 points) 
```{r}
USDAclean_Scott$HealthCheck = 0
USDAclean_Scott$HealthCheck <- as.integer(USDAclean_Scott$HealthCheck)

for (i in 1:length(USDAclean_Scott$ID)) {
if (USDAclean_Scott[i,"HighSodium"] == 0) {
USDAclean_Scott[i,"HealthCheck"] <- 1
} else if (USDAclean_Scott[i,"HighSugar"] == 0) {
USDAclean_Scott[i,"HealthCheck"] <- 1
} else if (USDAclean_Scott[i,"HighTotalFat"] == 0) {
USDAclean_Scott[i,"HealthCheck"] <- 1
}
}
```

## 8. 
How many foods in the USDAclean data frame fail the HealthCheck? (10 points) 
```{r}
sum(USDAclean_Scott$HealthCheck == 0)
# There are 237 records that fail the HealthCheck screen 
```

## 9.
Export the final USDAclean_Scott file to disk as a CSV file
```{r}
write.csv(USDAclean_Scott, file = "F:/CMTH642/Assignments/Assignment02/USDAclean_Scott.csv", row.names = F)
```