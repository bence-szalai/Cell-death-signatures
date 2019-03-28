library(shiny)
library(shinyWidgets)
library(tidyverse)
library(cowplot)
library(plotly)

#### Load measured data ####
measured_achilles = read_csv("data/matched/achilles_matched.csv")
measured_ctrp = read_csv("data/matched/ctrp_matched.csv")

#### Load predicted data ####
pred = read_csv("data/predictions/merged_pred.csv")

#### Load viability ~ expression models #### 
achilles_model = read_csv("data/models/achilles_model.csv")
ctrp_model = read_csv("data/models/ctrp_model.csv")

#### Load color palette ####
rwth_colors_df = get(load("data/misc/rwth_colors.rda"))

#### Functions ####
rwth_color = function(colors) {
  if (!all(colors %in% rwth_colors_df$query)) {
    wrong_queries = tibble(query = colors) %>%
      anti_join(rwth_colors_df, by="query") %>%
      pull(query)
    warning(paste("The following queries are not available:",
                  paste(wrong_queries, collapse = ", ")))
  }
  tibble(query = colors) %>%
    inner_join(rwth_colors_df, by="query") %>%
    pull(hex)
}

