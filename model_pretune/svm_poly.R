# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(kernlab)
library(tictoc)


set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# Model
svm_poly_model <-
  svm_poly(cost = tune(),
           degree = tune(),
           scale_factor = tune()) %>% 
  set_engine("kernlab") %>% 
  set_mode("classification")

# Parameters
svm_poly_param <- parameters(svm_poly_model)

# Grid
svm_poly_grid <- grid_regular(svm_poly_param, levels = 5)

# Workflow
svm_poly_workflow <- workflow() %>%
  add_model(svm_poly_model) %>%
  add_recipe(wildfire_rec)

tic("svmpoly")


# Tune
svm_poly_tune <- svm_poly_workflow %>%
  tune_grid(resamples = wildfire_folds, grid = svm_poly_grid)

toc(log = TRUE)

svm_poly_runtime <- tic.log(format = TRUE)

save(svm_poly_tune, svm_poly_workflow, svm_poly_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/svm_poly_tune.rda"))