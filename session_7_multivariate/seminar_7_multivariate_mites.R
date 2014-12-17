######################################################################################################
#######################         Examining community data - Ordinations         ####################### 
#######################                        9 November 2014                 ####################### 
#######################                    Jon Bray & Olivia Burge             ####################### 
######################################################################################################

rm(list = ls()) # deletes entire workspace

if(!require(vegan)){
  install.packages("vegan")
  library(vegan)
}

if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}

if(!require(fortunes)){
  install.packages("fortunes")
  library(fortunes)
}

#########  A primer on data set up ############

# R (and vegan) recognises and deals with both unordered and ordered factors. 
# Unordered factors are internally coded as dummy variables, 
# but one redundant level is removed or aliased. 
# With default contrasts, the removed level is the first one. 
# Ordered factors are expressed as polynomial contrasts. 
# Both of these contrasts explained in standard R documentation.

# You should not make your own dummy variables, use R factor coding. R will
# internally change these factors into dummies in a consistent and correct way.

# Note differences here... Not all factors are equal. Shrub is ordinal (i.e. it has a factor that is ordered from low to high).
# But in vegan things have been made simple for us. 

str(mite.env)

# if you need to do this with some of your own data. It's pretty simple.

d <- c(1,2,3)
e <- c("Low", "Medium", "High")
f <- c("Don't let", "Si", "drive, you'll get left behind")

mydata <- data.frame(d,e,f)
names(mydata) <- c("Response","Extent", "Driver")
str(mydata)

mydata$Extent <- ordered(mydata$Extent) 
mydata$Driver <- factor(mydata$Driver)
str(mydata)
rm(mydata)

########## Loading mite data for session ########## 

data(mite)
data(mite.env)
data(mite.xy) # and x y coordinates associated with Borcards (1992, 1994) mite data

mite
?mite
?mite.env
?mite.xy

names(mite)
names(mite.env)

# Conduct a PCA on continuous data, commonly used for environmental
# variable reduction. Say we want to combine variables that are similar
# in for SEM we may use PCA.

mite.env2<- cbind(mite.env$SubsDens, mite.env$WatrCont, mite.env$Shrub)
colnames(mite.env2)<-c("SubsDens2", "WatrCont2", "Shrub2")

pca.mite.env<-rda(mite.env2)
plot(pca.mite.env)

str(pca.mite.env)
bstick.pca <- bstick(pca.mite.env)
plot(bstick.pca)
?bstick
scree.plot <- screeplot(pca.mite.env, bstick = T) #most of the inertia/
# variance is captured in the first axis. So it should correlate well with variates.
pca.site.scores <- scores(pca.mite.env) #extract the scores. 
cor.test(pca.site.scores$sites[,1],mite.env$SubsDens, method=("pearson"))
cor.test(pca.site.scores$sites[,1],mite.env$WatrCont, method=("pearson"))
# and it does.

## Now that we have created a reduced set of variables, we are not actually going to use them
# in the rest of this session. You might however for structural equation modelling, 
# as gradients in other analyses.  They are also used as a clustering method in remote sensing
# data to classify the images into landuse types.




###################################################################################################
####################################    Unconstrained: NMDS     ###################################
###################################################################################################

# NMDS is a common & robust form of unconstrained ordination.  

mite.dis <- vegdist(mite) 
mite.dis # I have done this to give you an appreciation of a dissimilarity matrix. It is simply a serries of pairwise comparisons.
meta.nmds.mite <- metaMDS(mite.dis)

stressplot(meta.nmds.mite)

meta.nmds.mite # stress <0.1 is very good, 0.1-0.2 is good and stress 0.2-0.3 may be considered a poor fit.
#Stress is low at 0.15 and R^2 are high.

## Plotting NMDS:
plot(meta.nmds.mite[["points"]][,2] ~ meta.nmds.mite[["points"]][,1], main="Mite" ,xlab = "NMDS Axis 1", ylab ="NMDS Axis 2",
pch = c(16,1)[as.numeric(mite.env$Topo)],  # change the character types using 'pch' 
col = c("black","black")[as.numeric(mite.env$Topo)], # change the color using either numerics. See R book. Although may be designated by "black" as here.
cex = c(2,2)[as.numeric(mite.env$Topo)]) #change point sizes. Useful for visualising data that has some gradient that increases, in relation to categories.



###################################################################################################
####################################    ANOSIM     ################################################
###################################################################################################


## On to anosim - Are there differences between some of these categores?

?anosim # Distances are converted to ranks, any distance measure can be used.  Complements
# NMDS in this sense (which uses ranks)

ano1 <- anosim(mite.dis, mite.env$Topo, permutations = 999, distance = "bray")
plot(ano1) # Large positive R signifies dissimilarity between groups. 
#
ano1
summary(ano1) 

###################################################################################################
##################################################### Adonis ######################################################## 
###################################################################################################

# Uses a non-parametric multivariate anova (AKA permanova) 
# to assess how much of the variation in composition is explained by the variables you feed to it.

# It differs from envfit most structurally in that it compares the entire dissimilarity matrix between 
# sites, rather than the two or four or so dimensions that the composition is projected into using the NMDS
# it is the recommended test according to the package maintener (Oksansen), and can also be used with ranks
# to mimic anosim() [but is non-parametric, which is why it's preferred]

##################################################################################################################### 

############# NB: 
# The tests are sequential: the terms are evaluated in the order as they appear in the formula. 
# This is __not__ type III, which means that if you want the effect of variable X given the variation
# explained by EVERYTHING ELSE, it needs to come last in the formula.

######## As the package maintainer himself says: 
# “Type III” test means that every term is evaluated after all other terms. 
# This means fitting several adonis models, each term in turn as the last, and taking the statistics from the last term. 
# This can be done manually, we are no planning a canned routine for this.

mite.env$SubsDens_scaled <- scale(mite.env$SubsDens) #scaling the variables
mite.env$WatrCont_scaled <- scale(mite.env$WatrCont)

adonis.mite <- adonis(formula = mite ~ SubsDens_scaled + WatrCont_scaled + Substrate + Shrub + Topo, 
                      data = mite.env,
                      method = "bray")
adonis.mite

adonis.mite2 <- adonis(formula = mite ~ SubsDens_scaled + Substrate + Shrub + Topo + WatrCont_scaled, 
                       data = mite.env,
                       method = "bray")
adonis.mite2 # note that the R^2 values change depending on where in the formula the variable comes. 

adonis.mite3 <- adonis(formula = mite ~ SubsDens_scaled + Substrate+ Topo + WatrCont_scaled + Shrub, 
                       data = mite.env,
                       method = "bray")
adonis.mite3

adonis.mite4 <- adonis(formula = mite ~ SubsDens_scaled + Topo + WatrCont_scaled + Shrub + Substrate, 
                       data = mite.env,
                       method = "bray")
adonis.mite4

adonis.mite5 <- adonis(formula = mite ~ Topo + WatrCont_scaled + Shrub + Substrate + SubsDens_scaled, 
                       data = mite.env,
                       method = "bray")
adonis.mite5


# Let's visualise the effect of Topo by plotting the 95% CIs
plot(meta.nmds.mite)
ordihull(meta.nmds.mite, mite.env$Topo, col = "royalblue")  # side note: these are the outlines around each group. 
# Useful if you ever want to see the intercept() between two groups
ordiellipse(meta.nmds.mite, mite.env$Topo, col = "forestgreen")  #significant - but they overlap - why?

## All these functions (anosim, adonis, and MRPP [not coverred today] are sensitive to differences in dispersion of points. 
# A significant result does not necessarily mean that the location of the groups are different, 
# but some of the groups may be more heterogeneous than others.


## More advanced : you use adonis on the environmental variables AND the PCNMs, or just the PCNMs, 
# instead of just using the environmental variables. 
# The PCNMs are the principal coordinates of the spatial coordinates of the plots

# [diversion] - why use PCNMs? Why not just a regular distance matrix of each plot from each other 
# (like the AA driving maps between cities)?
# PCNM _truncates_ the large distances, meaning they can't be expressed in two dimensions anymore. 
?pcnm # explains it a bit further.  

# NB note in the help how this is considered to be ## more powerful ## than using a distance matrix and doing a partial mantel
# (which may also read about elsewhere)
# and for extra bonus reading: Dray, Stéphane, Pierre Legendre, and Pedro R. Peres-Neto. "Spatial modelling: a comprehensive framework for principal coordinate analysis of neighbour matrices (PCNM)." ecological modelling 196.3 (2006): 483-493.

############################# adonis in GGPLOT ############################# 
vegdist

# Let's visualise the effect of topo this time by plotting the 95% CIs, ggplot style

## data 
#data for NMDS points
meta.nmds.mite <- metaMDS(mite)
mite.NMDS.data <- mite.env #there are other ways of doing this. But this is the way I do it for ease of plotting
mite.NMDS.data$NMDS1 <- meta.nmds.mite$points[ ,1] #this puts the NMDS scores for the plots into a new dataframe. you could put them into an existing one if you preferred.
mite.NMDS.data$NMDS2 <- meta.nmds.mite$points[ ,2]

# species data - this is for only having the most common species labelled

stems <- colSums(mite) #total abundances for each species
spps <- data.frame(scores(meta.nmds.mite, display = "species")) #dataframe of species scoes for plotting
spps$species <- row.names(spps) # making a column with species names
spps$colsums <- stems #adding the colSums from above
spps <- spps[!is.na(spps$NMDS1) & !is.na(spps$NMDS2),] #removes NAs
spps.colmedian <- median(spps$colsums) #create an object that is the median of the abundance of the measured species
spps.colmean <- mean(spps$colsums) #creates a mean instead if you wish to use
spps2 <- subset(spps, spps$colsums > spps.colmedian) #select the most abundant species. Could discard fewer by going something like - spps$colsums>(spps.colmedian/2) instead
spps2$species <- factor(spps2$species) #otherwise factor doesn't drop unused levels and it will throw an error



# function for ellipsess - just run this, is used later ####
veganCovEllipse <- function (cov, center = c(0, 0), scale = 1, npoints = 100) 
{
  theta <- (0:npoints) * 2 * pi/npoints
  Circle <- cbind(cos(theta), sin(theta))
  t(center + scale * t(Circle %*% chol(cov)))
}



##  data for ellipse
df_ell.mite.Topo <- data.frame() #sets up a data frame before running the function.
for(g in levels(mite.NMDS.data$Topo)){
  df_ell.mite.Topo <- rbind(df_ell.mite.Topo, 
                            cbind(as.data.frame(with(mite.NMDS.data[mite.NMDS.data$Topo==g,], 
                                                     veganCovEllipse(cov.wt(cbind(NMDS1,NMDS2),
                                                                            wt=rep(1/length(NMDS1),
                                                                                   length(NMDS1)))$cov,center=c(mean(NMDS1),mean(NMDS2))))), Topo=g))
}

# data for labelling the ellipse
NMDS.mean.mite.topo = aggregate(mite.NMDS.data[ ,c("NMDS1", "NMDS2")], 
                                list(group = mite.NMDS.data$Topo), mean)


plot_mite_5 <-ggplot(mite.NMDS.data, aes(x = NMDS1, y = NMDS2))+
  geom_path(data = df_ell.mite.Topo, aes(x = NMDS1, y = NMDS2, group = Topo, linetype = Topo))+ #this is the ellipse, seperate ones by Site. If you didn't change the "alpha" (the shade) then you need to keep the "group 
  geom_point(aes(shape = Topo), size = 3) + #puts the site points in from the ordination, shape determined by site, size refers to size of point
  scale_shape_manual(values = c(2, 16))+
  scale_linetype_manual(values = c("dotted", "longdash"))+
  geom_text(data = NMDS.mean.mite.topo, aes(x = NMDS1, 
                                            y = NMDS2, 
                                            label = group)) + 
  theme_bw() + #for aesthetics
  theme(legend.key = element_blank(),  #removes the box around each legend item
        legend.position = c(0,0), 
        legend.justification = c(0,0),
        legend.background = element_rect(colour = "grey"))
plot_mite_5


## this time withe the most populous species, so we can see which are associated with each topo type
plot_mite_5 + 
  geom_text(data = spps2, aes(x = spps2$NMDS1, y = spps2$NMDS2, label=species), 
            size = 3.3, 
            hjust = 1.1)



###################################################################################################
####################################### betadisper ##################################################################################################################################################
###################################################################################################



??betadisper
beta.mite<-betadisper(mite.dis, mite.env$Topo) # I used to good effect with biomass categories of an invasive. It examines variance between groups within the community.
TukeyHSD(beta.mite) 
anova(beta.mite)


plot(meta.nmds.mite[["points"]][,2] ~ meta.nmds.mite[["points"]][,1], main="Mite" ,xlab = "NMDS Axis 1", ylab ="NMDS Axis 2",
pch = c(16,1)[as.numeric(mite.env$Topo)],  # change the character types using 'pch' 
col = c("black","black")[as.numeric(mite.env$Topo)], # change the color using either numerics. See R book. Although may be designated by "black" as here.
cex = c(2,2)[as.numeric(mite.env$Topo)]) #change point sizes. Useful for visualising data that has some gradient that increases, in relation to categories.
ordiellipse(meta.nmds.mite, mite.env$Topo, display="sites", kind = c("sd","se"))
mite.env$Topo #So it appears there is significantly less variance in communities associted with hummocks


###################################################################################################
#############################   Constained ordinations   ##########################################
###################################################################################################

### Constrained
# Conduct an RDA.

#Without Hellinger transformation
miteEnvRDA <- rda(mite ~ SubsDens + WatrCont + Shrub + Substrate + Topo, data=mite.env)

plot(miteEnvRDA)

miteEnvRDA<-step(miteEnvRDA, test="perm")

miteEnvRDA
plot(miteEnvRDA) #Major outlier and seemingly a poor fit. Most of the variance remains
# remains unaccounted for.

####    With Hellinger transformation ####
fortune(163)
# A drawback of euclidean distance can be that sites that have no shared species can look more 
# similar than sites sharing some species. This is dealt with through standardising, and a 
# common method is Hellinger. 
# Decostand is the function in vegan that applies the transformation.

mite.hell <- decostand(mite, "hel") # hellinger: square root of observed values that have first been divided by row (site) sums (Legendre & Gallagher 2001).
miteEnvRDA<- rda(mite.hell ~ SubsDens + WatrCont + Shrub + Substrate + Topo, data = mite.env) 
miteEnvRDA<- step(miteEnvRDA)
plot(miteEnvRDA)
miteEnvRDA #around half of the variance is now accounted for.

# So on the first ordination there is one PCA axis and one RDA axis, seems counter intuitive, however there is
# only one constraining varible. Remember without constraining variables RDA conducts PCA.

# 67 was also seriously influencing the ordination here. But we're forgetting scaling.
# Scaling species variances. Hellinger does this for us. Or we may use scaling within the RDA command. 
?rda #see scale option.

miteEnvRDAscaled <- rda(mite ~ SubsDens + WatrCont + Shrub + Substrate + Topo, 
                        scale = TRUE, data=mite.env)
miteEnvRDAscaled # we our unconstrained variance is now proportionally higher.
miteEnvRDAscaledR<-step(miteEnvRDAscaled, test= "perm") #Thus producing  
# a reduced model has been produced giving us the variables that 
# may be most important to determining community composition.
plot(miteEnvRDAscaledR)
summary(miteEnvRDAscaledR)

#So we use the hellinger model.
anova(miteEnvRDA) #so the overall model is explaining significant 
# amounts of variation and the individual predictors are also 
# explaining significnat variation.
miteEnvRDA 
# create a reduced environmental matrix of these variables
env.reduced<-mite.env[ , c("Shrub", "SubsDens", "Topo", "WatrCont")]
env.reduced


# Fundamental differences are present here that are only apparent where we
# examine the plots and read the axes as linear combinations of the 
# constraining variables.



# So these ordinations identify niche controls or habitat filters potentially. 
# Perhaps with observaitonal data we are best to describe them as associations.
# where causality is likely but not proved.

# But do we see variance in space also?

require(mgcv) #install this if you don't have it

pcnm.mite <- pcnm(dist(mite.xy)) #(see note above about PCNM)
pcnm.mite
#The following are maps of the derived PCNM gradients in the sample plot.
plot(mite.xy, xlim=c(-4,6.5))

#Ordisurf plots straight from the PCNM description. Allows examination of how some of these variables are shaped.
ordisurf(mite.xy, scores(pcnm.mite, choi=1), bubble = 4, main = "PCNM 1")
ordisurf(mite.xy, scores(pcnm.mite, choi=2), bubble = 4, main = "PCNM 2")
ordisurf(mite.xy, scores(pcnm.mite, choi=14), bubble = 4, main = "PCNM 14")
str(pcnm.mite)
pcnm.mite

## 43 Vectors???
#So which if any are important?
pcnm.scores <- scores(pcnm.mite)
pcnm.scores<-data.frame(pcnm.scores)

# Permutation testing can be a bit of a slow process. So I've already done and we'll skip this bit.
#pcnm.rda1<-rda(mite.hell~PCNM1+PCNM2+PCNM3+PCNM4+PCNM5+PCNM6+PCNM7+PCNM8+PCNM9+PCNM10+
#PCNM11+PCNM12+PCNM13+PCNM14+PCNM15, test="perm")
#pcnm.rda1<-step(pcnm.rda1, test="perm") # Loads are significant
  
pcnm.rda2<-rda(mite.hell ~ PCNM16 + PCNM17 + PCNM18 + PCNM19 + PCNM20, data=pcnm.scores)
pcnm.rda2<-step(pcnm.rda2, test="perm") # 

pcnm.rda3<-rda(mite.hell ~ PCNM21+PCNM22+PCNM23+PCNM24+PCNM25+PCNM26+PCNM27+PCNM28+PCNM29+PCNM30+PCNM31+PCNM32+PCNM33+PCNM34+PCNM35+PCNM36+PCNM37+PCNM38+PCNM39+PCNM40+PCNM41+PCNM42+PCNM43, data=pcnm.scores)
pcnm.rda3<-step(pcnm.rda3, test="perm") # 37.?

pcnm.rda<-rda(formula = mite.hell ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM6 +
PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM37, data=pcnm.scores)
pcnm.rda<-step(pcnm.rda, test="perm")
pcnm.rda #54% of variance is constrained here.

#So 1,2,3,4,6,7,8,9,10,11, explain significants amount of variation and are uncorrelated with one another.
cor.test(pcnm.scores$PCNM2,pcnm.scores$PCNM6, method=("pearson")) #and ofcourse all are diffent.
#usually there are not quite so many....

attach(pcnm.scores)
spatial.reduced <- pcnm.scores[ , c("PCNM1", "PCNM2", "PCNM3", "PCNM4", "PCNM6", "PCNM7", "PCNM8", 
    "PCNM9", "PCNM10", "PCNM11", "PCNM37")]
str(spatial.reduced)
rm(pcnm.scores)

# The pcnm backwards stepwise selected variables explain very significant levels of variability.

# But is there overlap with environmental drivers?

## See detailed documentation: #vegandocs("partition") ## 

# 1) We have found the minimum RDA model with environmental variables
# 2) We have found the RDA model with spatial variables
# 3) Run variance paritioning
# 4) a-c Test each individual matrix for significance
# 5) Create euler or area proportional Venn diagram
 
# 3) Variance partitioning
mite.partition <- varpart(mite.hell, ~ ., spatial.reduced, data = env.reduced) 
mite.partition

# 4) Test individual matrices for significance
rda.result1 <- rda(mite.hell ~Topo + Shrub + SubsDens + WatrCont + Condition(as.matrix(spatial.reduced)), data = env.reduced)
anova(rda.result1, step=200, perm.max=300)

mm.env <- model.matrix(~ SubsDens + WatrCont + Topo, env.reduced[-1])
rda.result2 <- rda(mite.hell ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM37 + Condition(mm.env), data = spatial.reduced)
anova(rda.result1, step=200, perm.max=300)

# 5) create (in this case) Venn diagrame to show results of varpart
showvarparts(3)
plot(mite.partition)


# So pure environmental relationships explain little, while pure spatial variables explain more.
# But there is massive overlap.
# Half of the data is explicable through these two drivers.
# Across such small spatial gradients would be expect strong spatial structuring?
# Distance decay? Unmeasured environmental variables?




######################################################################################################
########################################    dbRDA   ##############################################
######################################################################################################
# AKA distance-based RDA - assumes linear relationship between response and environment;
# used for carrying out constrained ordinations with non-Euclidean distances

?capscale

dbRDAmiteEnv <- capscale(mite.hell ~ SubsDens + WatrCont + Substrate + Shrub + Topo, 
                         sqrt.dist=F, data=mite.env, distance="bray") #Bray-Curtis is one of the most common choices for calculating dissimilarity
mite.env
plot(dbRDAmiteEnv)

anova(dbRDAmiteEnv, by = "term", step=200)

dbRDAmiteEnvR <- step(dbRDAmiteEnv, test="perm")

plot(dbRDAmiteEnvR)
summary(dbRDAmiteEnvR)

# other tricks
vegemite(mite)
vegemite(mite, scale = "log")
tabasco(mite)

# From here I typically export to illustrator setting a specific frame size e.g. 5x4 inches. 
#See options for saving in the ggplot tutorial as well. 

