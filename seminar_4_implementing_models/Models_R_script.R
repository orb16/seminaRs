################################################################################
################################################################################
#                     Seminar 4 - Basic models in R                            #                                              
#                   Ursula Torres and Hannah Franklin                          #
#          University of Canterbury 29/09/14 & Lincoln University 30/09/14     #
################################################################################
################################################################################


#####################################
#####1. SIMPLE LINEAR REGRESSION#####
#####################################


##########Import data#############

tannin_data<-read.table("tannin.txt",header=TRUE)
names(tannin_data)

#is there a relationship between tannin and growth?

#########Visualise the data##########

plot(tannin_data$tannin, tannin_data$growth,xlab="Tannin",ylab="Growth")

#########Linear regression############

#fit the regression model
model.output<-lm(tannin_data$growth ~ tannin_data$tannin)

#alternatively if you specify the data name, you don't need to put $....
model.output<-lm(growth ~ tannin, data=tannin_data)

#what does the model.output object contain?
names(model.output)

#add a regression line to the plot
abline(model.output)

#interpret the results:
summary(model.output)


#########Checking the model##########

#graphically
par(mfrow=c(2,2))#divide your plot window into 2 by 2 plots

plot(model.output)

#many other ways to check the model, depending of your data
#for example, here we can apply the Shapiro-Wilk test for checking the normality of the residuals

shapiro.test(model.output$residuals)#normal distribution


#####Practise exercise ######

#fit a regression model to see if there is a relationship between fiber and caterpillar growth?



#examine the regression data



#Is there a significant effect? 

#What is the direction of this effect / slope of the regression line?



# Extra for experts: Try to plot fiber vs growth and add a regression line?
#hint use the function plot, syntax plot(x, y)
par(mfrow=c(1,1))#return you plot window to one panel only




#############################################
######2. MULTIPLE LINEAR REGRESSION##########
#############################################


##########Import data########################

pollution_ozone<-read.table("ozone.data.txt",header=TRUE)
names(pollution_ozone)

##########visualise correlations#############
#pollution_ozone[,1:3] means selecting columns 1 to 3, the explanatory variables

pairs(pollution_ozone[,1:3], panel=panel.smooth)


#########Multiple linear regression##########


#saturated model (all predictors + two way interactions + three way interaction)
model.output2<-lm(ozone~temp*wind*rad,data=pollution_ozone)

summary(model.output2) # coefficients table
anova(model.output2)  # main effects - check significance


#model with all predictors + two way interactions only
model.output3<-lm(ozone~temp+wind+rad+temp:wind+wind:rad+temp:rad,data=pollution_ozone)

summary(model.output3)
anova(model.output3) # three-way interaction is no longer there


#equivalent command for having model with all predictors + two way interactions only
model.output3<-lm(ozone~(temp+wind+rad)^2,data=pollution_ozone)
summary(model.output3)
 

#########Simplification of the model##########

model.step<-step(model.output3)

output.model.step<-summary(model.step)

#export results

capture.output(output.model.step,file="model.step.ozone.txt")

#########Checking the model###################################

#graphically
par(mfrow=c(2,2))
plot(model.step)


#########Applying a transformation within the model##########

#examine the distribution of the response variable
par(mfrow=c(1,1))
hist(pollution_ozone$ozone) # left skewed - try log transformation

hist(log(pollution_ozone$ozone))

#run the model again on log transformed data
model_log<-lm(log(ozone) ~ temp + wind + rad + temp:wind + temp:rad,data=pollution_ozone)

#recheck the log model

par(mfrow=c(2,2))
plot(model_log)

summary(model_log)


# Predictor variables may also be transformed. Deciding which transformation is appropriate takes practise, consult your statistics text books for advice. 
# To modify the predictor variables, you have to use the function I() to be able to use the notation for powers
# Example:
# model_log2<-lm(log(ozone) ~ I(temp^2) + wind + rad ,data=pollution_ozone)

#########################################
#########3. ANOVA #######################
#########################################

##########Create the data frame##########

paint_data <- data.frame(adhf = c(4.0,4.5,4.3,5.6,4.9,5.4,3.8,3.7,4.0,5.4,4.9,5.6,5.8,6.1,6.3,5.5,5.0,5.0), primer = (rep(rep(1:3,rep(3,3)),2)),applic = (rep(c("D","S"),c(9,9))))

names(paint_data)
paint_data

#########Single factor ANOVA##########

####Does application method affect paint adhesion force?####

#Visualise the data

#plot(x,y) produced a box-plot when x is a factor
par(mfrow=c(1,1))

plot(paint_data$applic, paint_data$adhf,xlab="Application Method",ylab="Adhesion Force")

#bartlett.test - example of a test that can be used to test if variance are equal across groups in a factorial variable (other tests exist)
bartlett.test(paint_data$adhf ~ paint_data$applic) 


#Single factor ANOVA model

anova1<-aov(adhf ~ applic , data=paint_data)

anova(anova1) #ANOVA table
summary.lm(anova1) # gives a coefficients table as for as lm and R2 value


#checking the model
par(mfrow=c(2,2))
plot(anova1)

#NOTE: using the lm function with a variable that is a factor is the equivalent of running an ANOVA and produce the same result
anova2<-lm(adhf ~ applic, data=paint_data)

anova(anova2)   #ANOVA table
summary(anova2) #coefficients table


####Does primer type affect paint adhesion force?####

anova3<-aov(adhf ~ primer , data=paint_data)

anova(anova3) # look at the df for "primer" (for a factor df = no. groups - 1)

str(paint_data) # str function to examine the type of variables in the data 


#coding as a factor with-in the model
anova4<-aov(adhf ~ as.factor(primer), data=paint_data)

anova(anova4) # look at the df for "primer" again


#interpret the results

summary.lm(anova4) # coefficients table compares groups within a factor to the base group (for primer this is primer 1 in this case) - but doesn't tell us if primer 2 and 3 are different.

par(mfrow=c(1,1))
plot(as.factor(paint_data$primer), paint_data$adhf,xlab="Primer Type",ylab="Adhesion Force")


#multiple comparisons using post-hoc tests - Example Tukeys HSD test

TukeyHSD(anova4,"as.factor(primer)")  # we see that primer 2 and 3 do differ

#many other post hoc tests available, Fishers LSD (LSD.test function in agricolae package) and several options using the "multcomp" package (glht function)


#########Multi-factor ANOVA##########

####Does primer type, application method and the interaction (between these variables) affect paint adhesion force?####

#two-way anova with interaction
anova5<-aov(adhf ~ as.factor(primer) * applic , data=paint_data)

anova(anova5) 



#############################################################
#########4. Generalised linear models #######################
#############################################################

#Open iris data set 
data(iris)
head(iris)

#GLM gaussian distribution:continuous variable and factor

model_gen<-glm(Sepal.Length~Petal.Length+Petal.Width+Species,family=gaussian,data=iris)
summary(model_gen)
anova(model_gen)


###GLM poisson error
data(warpbreaks)
warpbreaks

model_breaks<-glm(breaks~wool*tension, warpbreaks, family=poisson)
summary(model_breaks)

#############################################################
################Binomial GLM exercise #######################
#############################################################

###### Load in data - "distribution_trout.txt" ####



##### Explore the data ####






##### run a model  ####

#Is the presence/absence of the trout related to flow, ammonium and pH and their interactions?

#hint - remember that this is binomial data






##### simplify the model ####





##### check the model ####





##### export the data from the final model in txt file ####



