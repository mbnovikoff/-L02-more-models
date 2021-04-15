# Loading in initial setup
library(tidymodels)
library(tidyverse)
library(tictoc)

# Set seed and load in initial setup components
set.seed(3013)
load("~/Desktop/Stat_301-3/Novikoff_Morgan_L02/data/initial_setup.rda")



# Boosted Tree Model
bt_model <- boost_tree(mode = "classification", 
                       mtry = tune(), 
                       min_n = tune(), 
                       learn_rate = tune()) %>%
                       set_engine("xgboost")


# Boosted Tree Workflow
            bt_workflow <- workflow() %>% 
                          add_model(bt_model) %>% 
                          add_recipe(wildfire_rec)

# Boosted Tree Parameters
            bt_params <- parameters(bt_model) %>%
                         update(mtry = mtry(range = c(1, 8)),
                         learn_rate = learn_rate(range = c(0.01, 0.5),
                                                 trans = scales::identity_trans()))

# Boosted Tree Grid
            bt_grid <- grid_regular(bt_params, levels = 4)

# Starts the timer before tuning
tic("bt")

# Boosted Tree Tune
bt_tune <- bt_workflow %>%
  tune_grid(
    resamples = wildfire_folds,
    grid = bt_grid)

# Computes elapsed time 
toc(log = TRUE)

# Store runtime
bt_runtime <- tic.log(format = TRUE)

# Save objects into RDA file
save(bt_tune, bt_workflow, bt_runtime, file = "~/Desktop/Stat_301-3/Novikoff_Morgan_L02/model_info/bt_tune.rda")