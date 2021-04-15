# Loading in initial setup
library(tidymodels)
library(tictoc)
library(tidyverse)

# Set seed and load in initial setup components
set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# MARS Model
mars_model <- mars(num_terms = tune(),
                          prod_degree = tune()) %>%
                     set_engine("earth") %>% 
  set_mode("classification")

# MARS Parameters
mars_param <- parameters(mars_model) %>%
  update(num_terms = num_terms(range = c(1,200)))

# MARS Grid
mars_grid <- grid_regular(mars_param, levels = 4)

# MARS Workflow
mars_workflow <- workflow() %>%
  add_model(mars_model) %>%
  add_recipe(wildfire_rec)

# Starts the timer before tuning
tic("mars")

# MARS Tune
mars_tune <- mars_workflow %>%
  tune_grid(resamples = wildfire_folds, grid = mars_grid)

# Computes elapsed time 
toc(log = TRUE)

# Store runtime
mars_runtime <- tic.log(format = TRUE)

# Save objects into RDA file
save(mars_tune, mars_workflow,mars_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/mars_tune.rda"))

