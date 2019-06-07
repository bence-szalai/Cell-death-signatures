tabPanel(
  title = "Welcome",
  icon = icon("home"),
  sidebarPanel(
    includeMarkdown("inst/landingpage_sidebar.md")
  ),
  mainPanel(
    includeMarkdown("inst/landingpage_body.md")
  )
)