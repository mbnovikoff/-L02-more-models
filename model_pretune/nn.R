# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(tictoc)

# Set seed and load in initial setup components
set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# Nearest Neighbors Model
nn_model <- nearest_neighbor(mode = "classification", 
                             neighbors = tune()) %>% 
                              set_engine("kknn")

# Nearest Neighbors Workflow
nn_workflow <- workflow() %>% 
  add_model(nn_model) %>% 
  add_recipe(wildfire_rec)

# Nearest Neighbors Parameters
nn_params <- parameters(nn_model) 

# Nearest Neighbors Grid
nn_grid <- grid_regular(nn_params, levels = 4)


# Starts the timer before tuning
tic("nn")


# Nearest Neighbors Tune
nn_tune <- nn_workflow %>%
  tune_grid(resamples = wildfire_folds,
            grid = nn_grid)

# Computes elapsed time 
toc(log = TRUE)

# Store runtime
nn_runtime <- tic.log(format = TRUE)

# Save objects into RDA file
save(nn_tune, nn_workflow, nn_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/nn_tune.rda"))