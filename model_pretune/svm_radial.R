# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(kernlab)
library(tictoc)

# Set seed and load in initial setup components
set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# SVM Radial Model
svm_radial_model <-
  svm_rbf(cost = tune(),
          rbf_sigma = tune()) %>% 
  set_engine("kernlab") %>% 
  set_mode("classification")

# SVM Radial Parameters
svm_radial_param <- parameters(svm_radial_model)

# SVM Radial Grid
svm_radial_grid <- grid_regular(svm_radial_param, levels = 4)

# SVM Radial Workflow
svm_radial_workflow <- workflow() %>%
  add_model(svm_radial_model) %>%
  add_recipe(wildfire_rec)

# Starts the timer before tuning
tic("svmradial")


# SVM Radial Tune
svm_radial_tune <- svm_radial_workflow %>%
  tune_grid(resamples = wildfire_folds, grid = svm_radial_grid)

# Computes elapsed time 
toc(log = TRUE)

# Store runtime
svm_radial_runtime <- tic.log(format = TRUE)

# Save objects into RDA file
save(svm_radial_tune, svm_radial_workflow, svm_radial_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/svm_radial_tune.rda"))