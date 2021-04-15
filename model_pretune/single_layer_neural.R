# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(tictoc)

# Set seed and load in initial setup components
set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# Single Layer Neural Network Model
neural_model <- mlp(mode = "classification",
                    hidden_units = tune(),
                    penalty = tune()) %>%
  set_engine("nnet")

# Single Layer Neural Network Parameters
neural_param <- parameters(neural_model) 

# Single Layer Neural Network Grid
neural_grid <- grid_regular(neural_param)

# Single Layer Neural Network Workflow
neural_workflow <- workflow() %>%
  add_model(neural_model) %>%
  add_recipe(wildfire_rec)

# Starts the timer before tuning
tic("slnn")


# Single Layer Neural Network Tune
neural_tune <- neural_workflow %>%
  tune_grid(resamples = wildfire_folds, grid = neural_grid)

# Computes elapsed time 
toc(log = TRUE)

# Store runtime 
slnn_runtime <- tic.log(format = TRUE)

# Save objects into RDA file
save(neural_tune, neural_workflow, slnn_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/neural_tune.rda"))

