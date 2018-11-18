#Birgitta Paranko
#13.11.2018
# script for combining two school subject performance datasets into one dataframe.
# Data source: P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7.

# access libraries
library(dplyr)

# set working directory and read the datasets student-mat and student-por
setwd('C:/Users/Neural/Documents/GitHub/IODS-project/data')
math <- read.csv('student-mat.csv', sep=';', header=TRUE)
por <- read.csv('student-por.csv', sep=';', header=TRUE)

#explore dimensions and structure
dim(math) # math has 395 subjects and 33 variables
dim(por) # por has 649 subjects and 33 variables

str(math)
str(por) # datasets have the same variables, and they are either Int's or factorizied.

# combine math and por datasets by using the columns listed in the join_by vector
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(math, por, by=join_by)
dim(math_por) # combined data has 382 subjects and 53 variables, which of some are duplicates from the two datasets
str(math_por) # data is a combination of int and factorized variables

# create a new data frame with only the joined columns. This data frame will later be appended with the averages of the variables not in the join_by columns.
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]


# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# create alc_use column for the average use of alcohol
alc <- mutate(alc, alc_use = (Dalc + Walc)/2)
alc <- mutate(alc, high_use = alc_use>2)
glimpse(alc) # data looks ok, 382 subjects with 35 variables

# write into csv file
write.csv(alc, 'alc.csv', row.names = FALSE)
