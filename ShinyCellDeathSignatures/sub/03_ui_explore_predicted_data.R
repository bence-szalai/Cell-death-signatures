tabPanel(
  title = "Tab3",
  icon = icon("database"),
  sidebarPanel(
    downloadButton("download_predicted_achilles_ctrp", "Download predictions")
  ),
  mainPanel(
    DT::dataTableOutput("predicted_df") %>% withSpinner(),
    plotlyOutput("histogram_predicted")
  )
)
