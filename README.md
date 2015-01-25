# Getting and Cleaning Data course project 
## Data analysis process description

### Input data
The original data set was provided in several files. The training and test data sets were split into two parts and in each part the actual observations were stored separately from the labels and variable names. 

The goal was to bring these components into a tidy data set, then use it to generate further statistical observations. To simplify some of these steps the functions in the dplyr library were used.

### Processing the data
To achieve this goal the following steps were taken:

1. Read the input files into individual data tables and vectors

      a. The training and test data sets were read to store the actual observations
      
      b. The activity labels were read and stored
      
      c. The subject identifiers were read and stored
      
      d. The variable names were read and stored in a vector
      
2. Filter the relevant columns from the input observation data sets to include only the mean or standard deviation related variables

3. Merge the data sets

      a. Merge the observations with their respective additional data (labels and subject IDs)
      
      b. Merge the training and test data sets
      
      c. Rename the columns to be more readable
      
4. Create a new data set more suited for grouped data (dplyr)

5. Generate a data set grouped by subject and activity

```{r}
gpd_dt<-group_by(new_dataset, subject, activity_label)
```

6. Calculate the mean of each variable grouped by subject and activity

```{r}
# Calculate means for each vriable except grouping variables (activity names and subjects)
grouped_means <- gpd_dt %>% summarise_each(funs(mean))
```

7. Save the results in a text file

```{r}
write.table(grouped_means, file = "group_avgs.txt", row.name=FALSE)
```
