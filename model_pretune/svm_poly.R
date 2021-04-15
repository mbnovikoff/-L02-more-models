# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(kernlab)
library(tictoc)

# Set seed and load in initial setup components
set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# SVM Poly Model
svm_poly_model <-
  svm_poly(cost = tune(),
           degree = tune(),
           scale_factor = tune()) %>% 
  set_engine("kernlab") %>% 
  set_mode("classification")

# SVM Poly Parameters
svm_poly_param <- parameters(svm_poly_model)

# SVM Poly Grid
svm_poly_grid <- grid_regular(svm_poly_param, levels = 3)

# SVM Poly Workflow
svm_poly_workflow <- workflow() %>%
  add_model(svm_poly_model) %>%
  add_recipe(wildfire_rec)

# Starts the timer before tuning
tic("svmpoly")


# SVM Poly Tune
svm_poly_tune <- svm_poly_workflow %>%
  tune_grid(resamples = wildfire_folds, grid = svm_poly_grid)

# Computes elapsed time 
toc(log = TRUE)

# Store runtime
svm_poly_runtime <- tic.log(format = TRUE)

# Save objects into RDA file
save(svm_poly_tune, svm_poly_workflow, svm_poly_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/svm_poly_tune.rda"))