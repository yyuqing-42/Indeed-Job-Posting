#Reading in the data
```{r}
library(readr)
data <- read_csv("~/Downloads/2018 DataFest 3/datafest2018-Updated-April12.csv")
```


#Subsetting the data
```{r}
#first subest just ca
library(dplyr)
data_ca <- data %>% filter(stateProvince=="CA")

#then just keep important variables
#jobId, industry, normTitle, normTitleCategory, descriptionCharacterLength, descriptionWordCount, experienceRequired, estimatedSalary, clicks
#possibly dichotomize: industry, normTitle, normTitleCategory, experienceRequired, numReviews 
subset_data <- data_ca[,c("jobId", "industry", "normTitle", "normTitleCategory", "descriptionCharacterLength", "descriptionWordCount", "experienceRequired", "estimatedSalary", "clicks")]

#dichotmize vars
subset_data$industry_dich <- 1
subset_data$industry_dich[which(is.na(subset_data$industry)==TRUE)] <- 0

subset_data$experienceRequired_dich <- 1
subset_data$experienceRequired_dich[which(is.na(subset_data$experienceRequired)==TRUE)] <- 0

subset_data$normTitle_dich <- 1
subset_data$normTitle_dich[which(is.na(subset_data$normTitle)==TRUE)] <- 0

subset_data$normTitleCategory_dich <- 1
subset_data$normTitleCategory_dich[which(is.na(subset_data$normTitleCategory)==TRUE)] <- 0


#cleaning data so we have on unique jobID per row 
#vars that won't stay the same: clicks=average 
clean_data <- subset_data %>% group_by(jobId, industry, normTitle, normTitleCategory, descriptionCharacterLength, descriptionWordCount, experienceRequired, estimatedSalary, industry_dich, normTitle_dich, normTitleCategory_dich, experienceRequired_dich) %>% summarise(mean_clicks = mean(clicks))

a <- table(clean_data$jobId)
a <- as.data.frame(a)
a_sub <- a[a$Freq>1,]
job_repeats <- a_sub$Var1

clean_data2 <- clean_data[!(clean_data$jobId%in%job_repeats),]

write.csv(clean_data2, "clean_data.csv")
```

#Checking for missing values 
```{r}
sum(is.na(clean_data2$descriptionCharacterLength))
sum(is.na(clean_data2$descriptionWordCount))
sum(is.na(clean_data2$experienceRequired))
sum(is.na(clean_data2$estimatedSalary))
sum(is.na(clean_data2$industry_dich))
sum(is.na(clean_data2$normTitle_dich))
sum(is.na(clean_data2$normTitleCategory_dich))
sum(is.na(clean_data2$experienceRequired_dich))
sum(is.na(clean_data2$mean_clicks))
```

#question: What makes your job posting attractive to help a new company with their posting
##response variable = clicks

#Deciding which predictors are best for model
```{r}
#reading in the cleaned data:
data <- read.csv("clean_data.csv")

#deciding which predictors are best for the model 
model <- lm(mean_clicks~ descriptionCharacterLength + descriptionWordCount + experienceRequired + estimatedSalary+ industry_dich + normTitle_dich + normTitleCategory_dich + experienceRequired_dich, data=data)
summary(model)

#normTitle_dich vs normTitleCategory_dich does not make a difference in a bivariate model of overall model - just picked to keep normTitle_dich
#experienceRequired performs much better than experienceRequired_dich so I kept the non dichotomized version in the model 

model2 <- lm(mean_clicks~ descriptionCharacterLength + descriptionWordCount + experienceRequired + estimatedSalary+ industry_dich +  normTitle_dich , data=data)
summary(model2)

#remove experienceRequired bc it is not significant
model3 <- lm(mean_clicks~ descriptionCharacterLength + descriptionWordCount  + estimatedSalary+ industry_dich +  normTitle_dich , data=data)
summary(model3)

#remove normTitle_dich bc it is not significant
model4 <- lm(mean_clicks~ descriptionCharacterLength + descriptionWordCount  + estimatedSalary+ industry_dich , data=data)
summary(model4)
#all predictors are significant and R2=0.01733
```


#Exploring the variables chosen to be significant in model4
```{r}
plot(model4)
library(car)
vif(model4)
#descriptionCharacterLength and descriptionWordCount highly correlated to each other -as expected 

model5 <- lm(mean_clicks~  descriptionCharacterLength  + estimatedSalary+ industry_dich , data=data)
summary(model5)

plot(model5)
library(car)
vif(model5)
```

#Fixing diagnostic plots by transforming variables
```{r}
inverseResponsePlot(model5, key=TRUE)
#use log(mean_clicks)

#For the numeric predictors without zero values (only descriptionCharacterLength)
summary(powerTransform(data$descriptionCharacterLength ~1))
data$descriptionCharacterLength_transformed <- data$descriptionCharacterLength^(1/3)


#creating our final model
model_final <- lm(log(mean_clicks)~  descriptionCharacterLength_transformed  + estimatedSalary+ industry_dich , data=data)
summary(model_final)
#we now have an R2 of 0.0253


#add interaction terms
model_final2 <- lm(log(mean_clicks)~    estimatedSalary + industry_dich * descriptionCharacterLength_transformed, data=data)
summary(model_final2)
#0.02601

#analyzing final model
plot(model_final2)
```

#looking at variables independently
```{r}
#descriptionCharacterLength
model1 <- lm(mean_clicks~ descriptionCharacterLength, data=data)
summary(model1)
plot(model1)
inverseResponsePlot(model1, key=TRUE)
#transform to log(y)
summary(powerTransform(data$descriptionCharacterLength ~1))
data$descriptionCharacterLength_transformed <- data$descriptionCharacterLength^(1/3)
model1_final <- lm(log(mean_clicks) ~ descriptionCharacterLength_transformed, data=data)
summary(model1_final)    

#descriptionWordCount
model2 <- lm(mean_clicks~ descriptionWordCount, data=data)
summary(model2)
plot(model2)
inverseResponsePlot(model2, key=TRUE)
#transform to log(y)
summary(powerTransform(data$descriptionWordCount ~1))
data$descriptionWordCount_transformed <- data$descriptionWordCount^(.25)
model2_final <- lm(log(mean_clicks) ~ descriptionWordCount_transformed, data=data)
summary(model2_final)  

#experienceRequired
model3 <- lm(mean_clicks~ experienceRequired, data=data)
summary(model3)
plot(model3)
inverseResponsePlot(model3, key=TRUE)
#transform to y^1/3
#cannot transform experienceRequired because there are NAs present
model3_final <- lm(mean_clicks^(1/3) ~ experienceRequired, data=data)
summary(model3_final)  

#estimatedSalary
model4 <- lm(mean_clicks~ estimatedSalary, data=data)
summary(model4)
plot(model4)
inverseResponsePlot(model4, key=TRUE)
#transform to log(y)
#cannot transform estimatedSalary because there are 0s present 
model4_final <- lm(log(mean_clicks) ~ estimatedSalary, data=data)
summary(model4_final)  

#industry_dich
model5 <- lm(mean_clicks~ industry_dich, data=data)
summary(model5)
plot(model5)
inverseResponsePlot(model5, key=TRUE)
#transform to log(y) or y^(-.5)
#cannot transform industry_dich bc it is a dichotomized (categorical) variable 
model5_final <- lm(mean_clicks^(-.5) ~ industry_dich, data=data)
summary(model5_final)  

#normTitle_dich
model6 <- lm(mean_clicks~ normTitle_dich, data=data)
summary(model6)
plot(model6)
inverseResponsePlot(model6, key=TRUE)
#keep y as y^1
#cannot transform normTitle_dich bc it is a dichotomized (categorical) variable 
model6_final <- lm(mean_clicks ~ normTitle_dich, data=data)
summary(model6_final) 

#normTitleCategory_dich
model7 <- lm(mean_clicks~ normTitleCategory_dich, data=data)
summary(model7)
plot(model7)
inverseResponsePlot(model7, key=TRUE)
#keep y as y^1
#cannot transform normTitleCategory_dich bc it is a dichotomized (categorical) variable 
model7_final <- lm(mean_clicks ~ normTitleCategory_dich, data=data)
summary(model7_final) 

#experienceRequired_dich
model8 <- lm(mean_clicks~ experienceRequired_dich, data=data)
summary(model8)
plot(model8)
inverseResponsePlot(model8, key=TRUE)
#transform y to log(y)
#cannot transform experienceRequired_dich bc it is a dichotomized (categorical) variable 
model8_final <- lm(log(mean_clicks) ~ experienceRequired_dich, data=data)
summary(model8_final) 
```

#plotting bivariate relationships with model fit line 
#descriptionCharacterLength
```{r}
data$descriptionCharacterLength_transformed <- data$descriptionCharacterLength^(1/3)
model1_final <- lm(log(mean_clicks) ~ descriptionCharacterLength_transformed, data=data)
summary(model1_final)

s <- seq(from=min(data$descriptionCharacterLength_transformed), to=max(data$descriptionCharacterLength_transformed), length.out=nrow(data))
pred <- predict(model1_final, newdata=list(descriptionCharacterLength_transformed=s), se=TRUE)
#type="r"

plot(data$descriptionCharacterLength, data$mean_clicks, cex=.5, main="Description Character Length vs Clicks", xlab="Description Character Length", ylab="Mean Clicks Per Day")
lines(s^3, exp(pred$fit), col="red")

#predicting a single y value from a single x value
predict(model1_final, data.frame(descriptionCharacterLength_transformed=c(1)))
```

#descriptionWordCount
```{r}
data$descriptionWordCount_transformed <- data$descriptionWordCount^(.25)
model2_final <- lm(log(mean_clicks) ~ descriptionWordCount_transformed, data=data)
summary(model2_final)  

s <- seq(from=min(data$descriptionWordCount_transformed), to=max(data$descriptionWordCount_transformed), length.out=nrow(data))
pred <- predict(model2_final, newdata=list(descriptionWordCount_transformed=s), se=TRUE)
#type="r"

plot(data$descriptionWordCount, data$mean_clicks, cex=.5, main="Description Word Count vs Clicks", xlab="Description Word Count", ylab="Mean Clicks Per Day")
lines(s^4, exp(pred$fit), col="red")
```

#experienceRequired
```{r}
model3_final <- lm(mean_clicks^(1/3) ~ experienceRequired, data=data)
summary(model3_final)   

s <- seq(from=min(data$experienceRequired,na.rm=TRUE), to=max(data$experienceRequired,na.rm=TRUE), length.out=nrow(data))
pred <- predict(model3_final, newdata=list(experienceRequired=s), se=TRUE)
#type="r"

plot(data$experienceRequired, data$mean_clicks, cex=.5, main="Experience Required vs Clicks", xlab="Experience Required", ylab="Mean Clicks Per Day")
lines(s, pred$fit^3, col="red")
```

#estimatedSalary
```{r}
model4_final <- lm(log(mean_clicks) ~ estimatedSalary, data=data)
summary(model4_final)    

s <- seq(from=min(data$estimatedSalary), to=max(data$estimatedSalary), length.out=nrow(data))
pred <- predict(model4_final, newdata=list(estimatedSalary=s), se=TRUE)
#type="r"

plot(data$estimatedSalary, data$mean_clicks, cex=.5, main="Estimated Salary vs Clicks", xlab="Estimated Salary", ylab="Mean Clicks Per Day")
lines(s, exp(pred$fit), col="red")
```

#industry_dich
```{r}
model5_final <- lm(mean_clicks^(-.5) ~ industry_dich, data=data)
summary(model5_final)   

#s <- seq(from=min(data$industry_dich), to=max(data$industry_dich), length.out=nrow(data))
pred <- predict(model5_final, type="r")
#type="r"

# boxplot(data$industry_dich, data$mean_clicks, cex=.5, main="Industry Present vs Clicks", xlab="Industry Present", ylab="Mean Clicks Per Day")
# lines(c("Yes", "No"), exp(pred$fit), col="red")

```


#making recommentations for each variable
```{r}
#descriptionCharacterLength
#^(1/3)
model1_final <- lm(log(mean_clicks) ~ descriptionCharacterLength_transformed, data=data)
summary(model1_final)    
#recommendation: descriptionCharacterLength is 5,000 or smaller - definitely 10,000 or less 
#max clicks per day seems to reduce as descriptionCharacterLength goes up to 10,000, 15,000, and so on

#descriptionWordCount
#^(.25)
model2_final <- lm(log(mean_clicks) ~ descriptionWordCount_transformed, data=data)
summary(model2_final)  
#recommendation: descriptionWordCount is 500 or smaller - definitely 1,000 or less 
#max clicks per day seems to reduce as descriptionWordCount goes up to 1,000, 1,500, and so on

#experienceRequired
model3_final <- lm(mean_clicks^(1/3) ~ experienceRequired, data=data)
summary(model3_final)  
#experienceRequired between 0 and 5 receives the most amount of clicks per day, followed by experienceRequired between 5 and 10. 
#if there is a wide variety of ranges of experience you would consider, we recommend listing the experienceRequired as lower to attract more potential clicks 

#estimatedSalary
model4_final <- lm(log(mean_clicks) ~ estimatedSalary, data=data)
summary(model4_final)  
#recommendation: estimatedSalary is around between 12,500 and 50,000 (next between 50,000 to 100,000) 
#max clicks per day seems to go down from there, likely because much less people have the skillset required to get paid this higher range of salary

#industry_dich
model5_final <- lm(mean_clicks^(-.5) ~ industry_dich, data=data)
summary(model5_final)  
#highest clicks per day (375 and greater) come from postings without an industry listed (NA) (except for one observation with 1,000 clicks with industry present)
#this is likely because people interested in a variety of industries are more likely to click on your post if you don't have an industry listed
#for the most part though, the min-q3 are almost identical
#recommendation: if you have a wide variety of majors/industry background individuals that could be interested in your job posting, leave the industry NA. But, if you only want people with experience in your particular industry clicking on and applying to your position, put down the industry. 

#normTitle_dich
model6_final <- lm(mean_clicks ~ normTitle_dich, data=data)
summary(model6_final) 
#we recommend listing normTitle, min-q3 are quite similar for yes and no, but the yes group has higher values for q3-max

#normTitleCategory_dich
model7_final <- lm(mean_clicks ~ normTitleCategory_dich, data=data)
summary(model7_final) 
#we recommend listing normTitleCategory, min-q3 are quite similar for yes and no, but the yes group has higher values for q3-max

#experienceRequired_dich
model8_final <- lm(log(mean_clicks) ~ experienceRequired_dich, data=data)
summary(model8_final) 
#highest clicks per day come from experienceRequired not being listed. However, min to q3 is quite similar. We recommend not listing experience if years of experience is not important to the job, and you are therefore interested in candidates with a variety of experience. However, if you are only interested in candidates with a particular amount of experience, it should still be listed. 
```




```{r}
#separate example to show that graph code is right 
train_imp$LotArea_Transformed <- log(train_imp$LotArea)
kaggle <- lm(SalePrice^.25 ~LotArea_Transformed, data=train_imp)
summary(kaggle)
s <- seq(from=min(train_imp$LotArea_Transformed), to=max(train_imp$LotArea_Transformed), length.out=nrow(train_imp))
pred <- predict(kaggle, newdata=list(LotArea_Transformed=s),se=TRUE)
plot(train_imp$LotArea, train_imp$SalePrice)
lines(exp(s), pred$fit^4, col="red")
```
