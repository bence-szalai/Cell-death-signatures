tabPanel(
  title = "Predicted cell viability",
  icon = icon("cogs"),
  sidebarPanel(
    includeMarkdown("inst/tab2_sidebar.md"),
    downloadButton("download_predicted_achilles_ctrp", "Download predictions")
  ),
  mainPanel(
    includeMarkdown("inst/tab2_body.md"),
    DT::dataTableOutput("predicted_df") %>% withSpinner(),
    br(),
    plotlyOutput("histogram_predicted")
  )
)
