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
  print(input$measured_df_search_columns)
  print(input)
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

output$histogram_measured = renderPlotly({
  if (selected_resource_measured() == "achilles") {
    p = achilles_measured %>%
      ggplot(aes(x=shRNA_abundance)) +
      geom_histogram(color="white") +
      my_theme() +
      geom_rug(data = achilles_measured %>% slice(1:50))
  } else if (selected_resource_measured() == "ctrp") {
    p = ctrp_measured %>% 
      ggplot(aes(x=cell_viability)) +
      geom_histogram(color = "white", boundary = 0) +
      my_theme()
  }
})

output$pie_achilles_measured = renderPlotly({
  p = achilles_measured %>%
    transmute(cell_id = fct_lump(cell_id)) %>%
    count(cell_id) %>%
    plot_ly(labels = ~cell_id, values = ~n, type="pie",
            textposition = 'inside',
            textinfo = 'label+percent',
            insidetextfont = list(color = '#FFFFFF'),
            hoverinfo = 'text',
            text = ~paste(n, " experiments"),
            showlegend = FALSE) %>%
    layout(title = 'Cell lines available in Achilles dataset',
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  
  t = achilles_measured %>%
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
  
  return(p)
})

output$pie_ctrp_measured = renderPlotly({
  p = ctrp_measured %>%
    transmute(cell_id = fct_lump(cell_id, 10)) %>%
    count(cell_id) %>%
    plot_ly(labels = ~cell_id, values = ~n, type="pie",
            textposition = 'inside',
            textinfo = 'label+percent',
            insidetextfont = list(color = '#FFFFFF'),
            hoverinfo = 'text',
            text = ~paste(n, " experiments"),
            showlegend = FALSE) %>%
    layout(title = 'Cell lines available in Achilles dataset',
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  
  t = ctrp_measured %>%
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
  
  return(p)
})