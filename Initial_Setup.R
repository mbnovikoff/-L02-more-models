# Load package(s)
library(tidymodels)
library(tidyverse)
library(janitor)

# Seed
set.seed(3013)

## load data
wildfires_dat <- read_csv("data/wildfires.csv") %>%
  janitor::clean_names() %>%
  mutate(
    winddir = factor(winddir, levels = c("N", "NE", "E", "SE", "S", "SW", "W", "NW")),
    traffic = factor(traffic, levels = c("lo", "med", "hi")),
    wlf = factor(wlf, levels = c(1, 0), labels = c("yes", "no"))
  ) %>%
  select(-burned)


#Split and fold data
wildfire_split <- initial_split(wildfires_dat, prop = 0.8, strata = wlf) 
wildfire_train <- training(wildfire_split) 
wildfire_test <- testing(wildfire_split)

wildfire_folds <- vfold_cv(wildfire_train, v = 5, repeats = 3, strata = wlf) 

# Create recipe 

wildfire_rec <- wildfire_train %>% 
  recipe(wlf ~ . ) %>%
  step_dummy(winddir, one_hot = TRUE) %>%
  step_dummy(traffic, one_hot = TRUE) %>%
  step_center(all_predictors()) %>%
  step_scale(all_predictors())

wildfire_rec %>% 
  prep(wildfire_train) %>% 
  bake(new_data = NULL) %>% 
  view() 



save(wildfires_dat, wildfire_train, wildfire_test, wildfire_split, wildfire_folds,
     wildfire_rec,
     file = "data/initial_setup.rda")
