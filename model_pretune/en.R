# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(tictoc)

# Set seed and load in initial setup components
set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# Elastic Net Recipe
en_rec <- recipe(wlf ~ . , data = wildfire_train) %>%   
                step_dummy(all_nominal(), -all_outcomes()) %>%   
                step_normalize(all_predictors()) %>%   
                step_interact(wlf ~ (.)^2) %>%
                step_zv(all_predictors()) %>% 
                step_normalize(all_predictors())

# Elastic Net Model
en_model <- logistic_reg(penalty = tune(),
                       mixture = tune()) %>% 
  set_mode("classification") %>% 
  set_engine("glmnet")

# Elastic Net Parameters
en_params <- parameters(en_model)

en_grid <- grid_regular(en_params, levels = 5)

# Elasting Net Workflow
en_workflow <- workflow() %>% 
  add_model(en_model) %>% 
  add_recipe(en_rec)

# Starts the timer before tuning
tic("en")


# Elastic Net Tune
en_tune <- en_workflow %>%
    tune_grid(resamples = wildfire_folds,
    grid = en_grid) 


# Computes elapsed time 
toc(log = TRUE)

# Store runtime
en_runtime <- tic.log(format = TRUE)

# Save objects into RDA file
save(en_tune, en_workflow, en_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/en_tune.rda"))
