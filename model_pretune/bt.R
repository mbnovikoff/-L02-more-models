# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(tictoc)

set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")



# Model
bt_model <- boost_tree(mode = "classification", 
                       mtry = tune(), 
                       min_n = tune(), 
                       learn_rate = tune()
) %>%
  set_engine("xgboost")


# Workflow
bt_workflow <- workflow() %>% 
  add_model(bt_model) %>% 
  add_recipe(wildfire_rec)

# Parameters
bt_params <- parameters(bt_model) %>%
  update(mtry = mtry(range = c(1, 8)),
         learn_rate = learn_rate(range = c(0.01, 0.5),trans = scales::identity_trans()))

# Grid
bt_grid <- grid_regular(bt_params, levels = 4)

tic("bt")

# Tune
bt_tune <- bt_workflow %>%
  tune_grid(
    resamples = wildfire_folds,
    grid = bt_grid)

toc(log = TRUE)

bt_runtime <- tic.log(format = TRUE)

save(bt_tune, bt_workflow, bt_runtime, file = "~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/bt_tune.rda")