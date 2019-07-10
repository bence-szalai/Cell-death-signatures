library(shiny)
library(shinyWidgets)
library(shinyjs)
library(shinycssloaders)
library(tidyverse)
library(cowplot)
library(plotly)
library(broom)

source("sub/my_ggplot_themes.R")
theme_set(theme_cowplot())

options(shiny.maxRequestSize=30*1024^2)

#### Load measured data ####
achilles_measured = read_csv("data/matched/achilles_matched.csv") %>%
  mutate_if(is.character, as.factor) %>%
  mutate(pert_itime = ordered(pert_itime,
                              levels = c("6 h", "24 h", "48 h", "72 h", "96 h",
                                         "120 h", "144 h", "168 h")))
ctrp_measured = read_csv("data/matched/ctrp_matched.csv") %>%
  mutate_if(is.character, as.factor) %>%
  mutate(pert_itime = ordered(pert_itime,
                              levels = c("3 h", "6 h", "24 h", "48 h")))

#### Load predicted data ####
pred = read_csv("data/predictions/merged_pred.csv") %>%
  mutate_if(is.character, as.factor) %>%
  mutate(pert_itime = ordered(pert_itime,
                              levels = c("1 h","2 h", "3 h", "4 h", "6 h",
                                         "24 h", "48 h", "72 h", "96 h",
                                         "120 h", "144 h", "168 h")))
 
#### Load viability ~ expression models #### 
achilles_model = read_csv("data/models/achilles_model.csv") %>%
  mutate(pr_gene_symbol = case_when(pr_gene_id == "INTERCEPT" ~ "intercept",
                                    TRUE ~ pr_gene_symbol)) %>%
  select(gene = pr_gene_symbol, coefficient)
ctrp_model = read_csv("data/models/ctrp_model.csv") %>%
  mutate(pr_gene_symbol = case_when(pr_gene_id == "INTERCEPT" ~ "intercept",
                                    TRUE ~ pr_gene_symbol)) %>%
  select(gene = pr_gene_symbol, coefficient)

# load example data
example_data = read_csv("data/misc/example_data.csv")

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

parse_column_filtering = function(x) {
  scan(text = gsub('[][]', '', gsub(" ... ", ",", x, fixed = TRUE)), 
       sep = ",", what = "", quiet = TRUE)
}
