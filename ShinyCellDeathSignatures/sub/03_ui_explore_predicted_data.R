tabPanel(
  title = "Predicted cell viability",
  icon = icon("cogs"),
  sidebarPanel(
    includeMarkdown("inst/tab2_sidebar.md"),
    radioGroupButtons(inputId = "select_pert_predicted",
                      label = "Select a perturbation:",
                      choices = c("Compound-Ligand" = "cl",
                                  "CRISPR" = "crispr",
                                  "Over-expression" = "oe",
                                  "shRNA" = "shrna",
                                  "Control" = "ctrl"),
                      justified = T,
                      direction = "vertical",
                      selected = "cl"),
    downloadButton("download_select_pert", "Download selected data")
  ),
  mainPanel(
    includeMarkdown("inst/tab2_body.md"),
    DT::dataTableOutput("predicted_df") %>% withSpinner(),
    br(),
    plotlyOutput("histogram_predicted")
  )
)
