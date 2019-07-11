# UI
source("sub/global.R")
ui = function(request) {
  fluidPage(
    tagList(
      useShinyjs(),
      tags$head(
        tags$link(href = "style.css", rel = "stylesheet")
      ),
      div(id = "loading-content", "Loading...",
          img(src = "ajax-loader-bar.gif")),
    tags$head(includeScript("google-analytics.js")),
    navbarPage(
      id = "menu", 
      title = div(img(src="logo_saezlab.png", width="25", height="25"),
                  "CEVIChE"),
      windowTitle = "CEVIChE",
      collapsible=T,
      source("sub/01_ui_welcome.R")$value,
      source("sub/02_ui_explore_measured_data.R")$value,
      source("sub/03_ui_explore_predicted_data.R")$value,
      source("sub/04_ui_predict_viability.R")$value,
      footer = column(12, align="center", "CEVIChE App 2019")
      ) # close navbarPage
    ) # close fluidPage
  )
}