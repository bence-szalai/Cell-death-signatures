tabPanel(
  title = "Tab2",
  icon = icon("database"),
  sidebarPanel(
    radioGroupButtons(inputId = "select_resource_measured",
                         label = "Select a resource:",
                         choices = c("Achilles" = "achilles",
                                     "CTRP" = "ctrp"),
                         justified = T,
                         direction = "vertical",
                         selected = "achilles"),
    downloadButton("download_achilles_measured", "Download Achilles"),
    downloadButton("download_ctrp_measured", "Download CTRP")
  ),
  mainPanel(
    DT::dataTableOutput("measured_df") %>% withSpinner(),
    plotlyOutput("histogram_measured"),
    plotlyOutput("pie_achilles_measured"),
    plotlyOutput("pie_ctrp_measured")
  )
)
