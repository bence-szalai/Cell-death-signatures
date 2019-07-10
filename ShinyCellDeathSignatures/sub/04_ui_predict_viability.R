tabPanel(
  title = "Prediction of cell viability",
  icon = icon("upload"),
  sidebarPanel(
    includeMarkdown("inst/tab3_sidebar.md"),
    switchInput(inputId = "take_example_data", label = "Explore example data",
                onLabel = "Yes", offLabel = "No", value=TRUE),
    fileInput("user_input", label=NULL),
    actionButton("submit", label="Submit",
                 icon=icon("send")),
    downloadButton("download_pred_via", "Download")
  ),
  mainPanel(
    includeMarkdown("inst/tab3_body.md"),
    tabsetPanel(
      id = "tab_panel",
      tabPanel(
        title = "Gene Expression", value = "tab_expression",
        DT::dataTableOutput("gex_matrix")
      ),
      tabPanel(
        title = "Cell Viability", value = "tab_viability",
        DT::dataTableOutput("pred_matrix") %>% withSpinner()
      )
    ),
    br(),
    plotlyOutput("bar_plot"),
    br(),
    plotlyOutput("cor_plot")
  )
)