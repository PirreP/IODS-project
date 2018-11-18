#Birgitta Paranko
#13.11.2018
# script for combining two school subject performance datasets into one dataframe.
# Data source: P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7.

# set working directory and read the datasets student-mat and student-por
setwd('C:/Users/Neural/Documents/GitHub/IODS-project/data')
math <- read.csv('student-mat.csv', sep=';', header=TRUE)
por <- read.csv('student-por.csv', sep=';', header=TRUE)

#explore dimensions and structure
dim(math) # math has 395 subjects and 33 variables
dim(por) # por has 649 subjects and 33 variables

str(math)
str(por) # datasets have the same variables, and they are either Int's or factorizied.
