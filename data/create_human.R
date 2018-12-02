# Birgitta Paranko
# edited 2.12.2018
# Data wrangling for human_development and gender_inequality datasets

#access libraries
library(dplyr)
library(tidyr)

# load human_development and gender_inequality datasets
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# explore datasets
str(hd) # 195 observations, 8 variables. chr, num and int values
str(gii)# 195 observations, 10 variables. int, char, num
summary(hd) # no summary for gross.national.... because it's 'char'
summary(gii)


# rename columns
names(hd) <- c('HDI_rank', 'country', 'HDI', 'Life_exp', 'education_exp', 'education_mean', 'GNI', 'GNI_HDI_rank_diff')
names(gii) <- c('GII_rank', 'country', 'GII', 'mmortality', 'birth_rate', 'parliament_repr', 'sec_edu_f', 'sec_edu_m', 'labour_f', 'labour_m'  )

# add new variables to gii
gii <- mutate(gii, edu2_sex=sec_edu_f/sec_edu_m, labour_sex=labour_f/labour_m)

# join hd and gii datasets, keep countries that are included in both datasets
human <- inner_join(hd, gii, by='country')
dim(human) # 195 observations, 19 variables

# save 'human' to data folder

write.csv(human, 'human.csv', row.names=FALSE)


###### part2 #######
# we will continue wrangling the human data. The data consists of 195 countries and 19 variables that describe the 
# countries human development index and gender inequality. In addition to the original variables, we have also added
# two variables, edu2_sex=sec_edu_f/sec_edu_m, labour_sex=labour_f/labour_m, which describe the ratio between
# gender specific education and labour scores.

# read the table
human <- read.csv('human.csv', header=TRUE, sep=',')

# manipulate GNI variable to numeric
str(human$GNI) ## GNI seems to be a factor
human$GNI <- as.numeric(human$GNI) # values abecame integers instead of doubles :/

# keep only the following columns
keep <-  c("country", "edu2_sex", "labour_sex", "education_exp", "Life_exp", "GNI", "mmortality", "birth_rate", "parliament_repr")
human <- dplyr::select(human, one_of(keep))

names(human) <- c( "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# remove rows with missing values

complete.cases(human)
human <- human[complete.cases(human), ]

# remove regions (last 7 rows)
human <- human[-c(155:162),]

#change countries as rownames
row.names(human) <- human$Country
human <- human[,-1]

#overwrite human-data with the new data

write.csv(human, 'human.csv', row.names = TRUE)
