tabPanel(
  title = "Prediction of cell viability",
  icon = icon("upload"),
  sidebarPanel(
    includeMarkdown("inst/tab3_sidebar.md"),
    switchInput(inputId = "take_example_data", label = "Explore example data",
                onLabel = "Yes", offLabel = "No", value=TRUE) %>%
      helper(icon = "question",
             size= "m",
             colour = "black",
             type = "markdown",
             content = "example_data"),
    fileInput("user_input", label="Upload gene expression matrix") %>%
      helper(icon = "question",
             size= "m",
             colour = "black",
             type = "markdown",
             content = "file_upload"),
    actionButton("submit", label="Submit",
                 icon=icon("send")) ,
    hr(),
    hidden(
      p(id ="select_model_label", "Order predictions for ..."),
      radioGroupButtons(
        inputId = "select_model",
        choices = c("Achilles", "CTRP")) 
    ),
    hr(),
    downloadButton("download_pred_via", "Download predictions"),
    hr(),
    downloadButton("download_achilles_model", "Download Achilles-model"),
    downloadButton("download_ctrp_model", "Download CTRP-model")
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