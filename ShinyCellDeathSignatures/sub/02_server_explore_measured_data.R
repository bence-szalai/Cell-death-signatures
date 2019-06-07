selected_resource_measured = eventReactive(
  input$select_resource_measured, {
    input$select_resource_measured
  }
)

output$measured_df = DT::renderDataTable({
  if (selected_resource_measured() == "achilles") {
    achilles_measured %>%
      mutate_if(is.double, signif, 3) %>%
      DT::datatable(., escape = F, option = list(scrollX = TRUE, autoWidth=T,
                                                 stateSave = TRUE), 
                    filter = "top", selection = list(target = "none",
                                                     stateSave = TRUE))
  } else if (selected_resource_measured() == "ctrp") {
    ctrp_measured %>%
      mutate_if(is.double, signif, 3) %>%
      DT::datatable(., escape = F, option = list(scrollX = TRUE, autoWidth=T,
                                                 stateSave = TRUE), 
                    filter = "top", selection = list(target = "none"))
  }
})

measured_df_filtered = observeEvent(input$measured_df_state, {
  input$measured_df_search_columns
})

output$download_achilles_measured = downloadHandler(
  filename = function() {
    "achilles_measured.csv"
  },
  content = function(file) {
    achilles_measured %>%
      write_csv(., file)
  })

output$download_ctrp_measured = downloadHandler(
  filename = function() {
    "ctrp_measured.csv"
  },
  content = function(file) {
    ctrp_measured %>%
      write_csv(., file)
  })

# histogram showing the measured cell viabilities for either achilles or ctrp
output$histogram_measured = renderPlotly({
  if (selected_resource_measured() == "achilles") {
    p = achilles_measured %>%
      ggplot(aes(x=shRNA_abundance)) +
      geom_histogram(color="white") +
      my_theme() +
      labs(x="shRNA abundance", y="Count")
  } else if (selected_resource_measured() == "ctrp") {
    p = ctrp_measured %>% 
      ggplot(aes(x=cell_viability)) +
      geom_histogram(color = "white", boundary = 0) +
      my_theme() +
      labs(x="shRNA abundance", y="Count")
  }
})

# pie chart displaying cell lines 
output$pie_measured_cellline = renderPlotly({
  if (selected_resource_measured() == "achilles") {
    achilles_measured %>%
      transmute(cell_id = fct_lump(cell_id)) %>%
      count(cell_id) %>%
      plot_ly(labels = ~cell_id, values = ~n, type="pie",
              textposition = 'inside',
              textinfo = 'label+percent',
              insidetextfont = list(color = '#FFFFFF'),
              hoverinfo = 'text',
              text = ~paste(n, " experiments"),
              showlegend = FALSE) %>%
      layout(title = 'Cell lines',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  } else if (selected_resource_measured() == "ctrp") {
    ctrp_measured %>%
      transmute(cell_id = fct_lump(cell_id, 10)) %>%
      count(cell_id) %>%
      plot_ly(labels = ~cell_id, values = ~n, type="pie",
              textposition = 'inside',
              textinfo = 'label+percent',
              insidetextfont = list(color = '#FFFFFF'),
              hoverinfo = 'text',
              text = ~paste(n, " experiments"),
              showlegend = FALSE) %>%
      layout(title = 'Cell lines',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  }

})

# pie chart displaying time after perturbation 
output$pie_measured_perttime = renderPlotly({
  if (selected_resource_measured() == "achilles") {
    achilles_measured %>%
      transmute(pert_itime = fct_lump(pert_itime, 3)) %>%
      count(pert_itime) %>%
      plot_ly(labels = ~pert_itime, values = ~n, type="pie",
              textposition = 'inside',
              textinfo = 'label+percent',
              insidetextfont = list(color = '#FFFFFF'),
              hoverinfo = 'text',
              text = ~paste(n, " experiments"),
              showlegend = FALSE) %>%
      layout(title = 'Hours after perturbation',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  } else if (selected_resource_measured() == "ctrp") {
    ctrp_measured %>%
      transmute(pert_itime = fct_lump(pert_itime,2)) %>%
      count(pert_itime) %>%
      plot_ly(labels = ~pert_itime, values = ~n, type="pie",
              textposition = 'inside',
              textinfo = 'label+percent',
              insidetextfont = list(color = '#FFFFFF'),
              hoverinfo = 'text',
              text = ~paste(n, " experiments"),
              showlegend = FALSE) %>%
      layout(title = 'Hours after perturbation',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  }
  

})
