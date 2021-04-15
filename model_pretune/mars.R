# Loading in initial setup
library(tidymodels)
library(tictoc)
library(tidyverse)


set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")

# Model
mars_model <- mars(num_terms = tune(),
                          prod_degree = tune()) %>%
                     set_engine("earth") %>% 
  set_mode("classification")

# Paramters
mars_param <- parameters(mars_model) %>%
  update(num_terms = num_terms(range = c(1,200)))

# Grid
mars_grid <- grid_regular(mars_param, levels = 4)

# Workflow
mars_workflow <- workflow() %>%
  add_model(mars_model) %>%
  add_recipe(wildfire_rec)

tic("mars")
# Tune
mars_tune <- mars_workflow %>%
  tune_grid(resamples = wildfire_folds, grid = mars_grid)

toc(log = TRUE)

mars_runtime <- tic.log(format = TRUE)

save(mars_tune, mars_workflow,mars_runtime, file = ("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/mars_tune.rda"))

