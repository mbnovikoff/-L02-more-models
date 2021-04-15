# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(tictoc)


set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# Model
nn_model <- nearest_neighbor(mode = "classification", 
                             neighbors = tune()) %>% 
                              set_engine("kknn")

# Workflow
nn_workflow <- workflow() %>% 
  add_model(nn_model) %>% 
  add_recipe(wildfire_rec)

# Parameters
nn_params <- parameters(nn_model) 

# Grid
nn_grid <- grid_regular(nn_params, levels = 4)

tic("nn")


# Tune
nn_tune <- nn_workflow %>%
  tune_grid(resamples = wildfire_folds,
            grid = nn_grid)

toc(log = TRUE)

nn_runtime <- tic.log(format = TRUE)

save(nn_tune, nn_workflow, nn_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/nn_tune.rda"))