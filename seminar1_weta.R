# R intro: basic data import and paired ttest.

#install package (this one is necessary for getting data off github directly)
install.packages("RCurl")
library(RCurl)

# get data
url <- getURL("https://raw.githubusercontent.com/orb16/seminaRs/master/weta.ttest2.csv")
weta.edge <- read.csv(text= url, header = T)

# run the ttest. See we put "paired = TRUE" as the default is unpaired
weta.ttest<- t.test(weta~distance, data = weta.edge, paired = TRUE)
weta.ttest

# a different way of doing it - manually enter the data (a different way this time - spot the difference)
edge<-c(9,7,7,6,4,13)
interior<-c(0,3,1,5,2,2)
t.test(edge,interior, paired = TRUE)

# plot data
install.packages("ggplot2")
library(ggplot2)

ggplot(data = weta.edge, aes(x = distance, y = weta))+ 
  geom_boxplot()+
  theme_bw()
