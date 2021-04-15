# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(tictoc)

# Set seed and load in initial setup components
set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# Random Forest Model
rf_model <- rand_forest(mode = "classification",
                        min_n = tune(),
                        mtry = tune()) %>% 
            set_engine("ranger")

# Random Forest Workflow
rf_workflow <- workflow() %>% 
  add_model(rf_model) %>% 
  add_recipe(wildfire_rec)

# Random Forest Parameters
rf_params <- parameters(rf_model) %>% 
  update(mtry = mtry(range = c(1, 8))) # Have 9 columns so I set upper to 8

# Random Forest Grid
rf_grid <- grid_regular(rf_params, levels = 4)

# Starts the timer before tuning
tic("random forest")

# Random Forest tune
rf_tune <- rf_workflow %>%
  tune_grid(resamples = wildfire_folds, grid = rf_grid)

# Computes elapsed time 
toc(log = TRUE)

#Store runtime 
rf_runtime <- tic.log(format = TRUE)

# Save objects into RDA file
save(rf_tune, rf_workflow, rf_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/rf_tune.rda"))