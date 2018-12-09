# Data wrangling with BPRS and RATS data
# Birgitta Paranko
# 5.12.2018

# access libraries
library(dplyr)
library(tidyr)

# read data. Loading data directly from the URL failed, so I copied first copied the data into local text files.
BPRS <- read.table('BPRS_orig.txt', sep  =" ", header = T)
RATS <- read.table('RATS_orig.txt', sep  ="\t", header = T)


#### BRPS ####

# Look at the (column) names of BPRS
names(BPRS)  # treatment, subject and weeks

# Look at the structure of BPRS
str(BPRS) # integers, 40 obs and 11 variables

# Print out summaries of the variables
summary(BPRS)

# Factor treatment & subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# Convert to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)

# Extract the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5,5)))

# Take a glimpse at the BPRSL data
glimpse(BPRSL)

##### RATS #######

names(RATS) # ID, group and weeks
str(RATS) # 16 observations, 13 variables, all integers
summary(RATS)

# Factor variables ID and Group
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Glimpse the data
glimpse(RATS)

# Convert data to long form
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3,3))) 

# Glimpse the data
glimpse(RATSL)

write.csv(BPRSL, "BPRSL.csv", row.names = FALSE)
write.csv(RATSL, "RATSL.csv", row.names = FALSE)
# Summary: The original data was in wide form. This means that all the observations from one individual are on one row.
# In the longitudal data all the observations are on different rows. 
# Eg in the original BPRS data the variables were treatment, subject and bprs values during different weeks.
# In the longitudal data each brps value is on different row. In other words, the data from one individual is 
# divided into sub-observations.
