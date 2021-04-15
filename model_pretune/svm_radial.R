# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(kernlab)
library(tictoc)


set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# Model
svm_radial_model <-
  svm_rbf(cost = tune(),
          rbf_sigma = tune()) %>% 
  set_engine("kernlab") %>% 
  set_mode("classification")

# Parameters
svm_radial_param <- parameters(svm_radial_model)

# Grid
svm_radial_grid <- grid_regular(svm_radial_param, levels = 4)

# Workflow
svm_radial_workflow <- workflow() %>%
  add_model(svm_radial_model) %>%
  add_recipe(wildfire_rec)

tic("svmradial")


# Tune
svm_radial_tune <- svm_radial_workflow %>%
  tune_grid(resamples = wildfire_folds, grid = svm_radial_grid)


toc(log = TRUE)

svm_radial_runtime <- tic.log(format = TRUE)

save(svm_radial_tune, svm_radial_workflow, svm_radial_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/svm_radial_tune.rda"))