# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(tictoc)


set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# Model
rf_model <- rand_forest(mode = "classification",
                        min_n = tune(),
                        mtry = tune()) %>% 
            set_engine("ranger")

# Workflow
rf_workflow <- workflow() %>% 
  add_model(rf_model) %>% 
  add_recipe(wildfire_rec)

#Parameters
rf_params <- parameters(rf_model) %>% 
  update(mtry = mtry(range = c(1, 8))) # Have 9 columns so I set upper to 8

# Grid
rf_grid <- grid_regular(rf_params, levels = 4)

tic("random forest")

# Tune
rf_tune <- rf_workflow %>%
  tune_grid(resamples = wildfire_folds, grid = rf_grid)

toc(log = TRUE)

rf_runtime <- tic.log(format = TRUE)

save(rf_tune, rf_workflow, rf_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/rf_tune.rda"))