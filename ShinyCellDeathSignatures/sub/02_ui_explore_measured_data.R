tabPanel(
  title = "Measured cell viability",
  icon = icon("microscope"),
  sidebarPanel(
    includeMarkdown("inst/tab1_sidebar.md"),
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
    includeMarkdown("inst/tab1_body.md"),
    DT::dataTableOutput("measured_df") %>% withSpinner(),
    br(),
    plotlyOutput("histogram_measured"),
    br(),
    fluidRow(
      column(
        6, plotlyOutput("pie_measured_cellline")
      ),
      column(
        6, plotlyOutput("pie_measured_perttime")
      )
    )
  )
)
