# Birgitta Paranko
# 11.11.2018
# script for downloading and creating learning2014 dataset

### all installations here ###

install.packages("tidyverse")

### library access ###
library(dplyr)

### read dataset ###

lrn14 <- read.table('http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt', sep='\t', header=TRUE)

### explore dimensions and structure ####

dim(lrn14)
str(lrn14)

# dataset has 183 rows of subjects, and 60 columns of different variables. Most of the variables are integers, only the gender is factorized (1=female, 2=male).

### create learning2014 data###

# create vectors of questions related to new variables (age, gender, attitude, deep, surface and strategic learning, points)
# (as defined in the datacamp exercises)

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select columns from the lrn14
deep_columns <- select(lrn14, one_of(deep_questions))
surface_columns <- select(lrn14, one_of(surface_questions))
strategic_columns <- select(lrn14, one_of(strategic_questions))

# take rowmeans to get a mean value for each subject
lrn14$deep <- rowMeans(deep_columns)
lrn14$surf <- rowMeans(surface_columns)
lrn14$stra <- rowMeans(strategic_columns)

# create learning2014 dataframe by selecting keep_columns from the original dataframe
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
learning2014_all <- select(lrn14, one_of(keep_columns))

# only take subjects that have exam points > 0
learning2014 <- filter(learning2014_all, Points>0)

### save and read dataframe ###
write.csv(learning2014, 'learning2014.csv')
learning2014_read <- read.csv('learning2014.csv')
str(learning2014_read) # types ok
head(learning2014_read) # structure ok

