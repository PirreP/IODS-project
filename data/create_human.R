#access libraries
library(dplyr)

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

write.csv(human, 'human.csv', row.names=TRUE)
