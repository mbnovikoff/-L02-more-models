# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(tictoc)


set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# Model
neural_model <- mlp(mode = "classification",
                    hidden_units = tune(),
                    penalty = tune()) %>%
  set_engine("nnet")

# Parameters
neural_param <- parameters(neural_model) 

# Grid
neural_grid <- grid_regular(neural_param)

# Workflow
neural_workflow <- workflow() %>%
  add_model(neural_model) %>%
  add_recipe(wildfire_rec)

tic("slnn")


# Tune
neural_tune <- neural_workflow %>%
  tune_grid(resamples = wildfire_folds, grid = neural_grid)


toc(log = TRUE)
slnn_runtime <- tic.log(format = TRUE)

save(neural_tune, neural_workflow, slnn_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/neural_tune.rda"))

