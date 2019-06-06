tabPanel(
  title = "Tab3",
  icon = icon("database"),
  sidebarPanel(
    includeMarkdown("inst/tab2_sidebar.md"),
    downloadButton("download_predicted_achilles_ctrp", "Download predictions")
  ),
  mainPanel(
    includeMarkdown("inst/tab2_body.md"),
    DT::dataTableOutput("predicted_df") %>% withSpinner(),
    plotlyOutput("histogram_predicted")
  )
)
