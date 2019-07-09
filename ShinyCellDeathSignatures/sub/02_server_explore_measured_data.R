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

measured_df_filtered = eventReactive(input$measured_df_state, {
  s = input$measured_df_search_columns %>% 
    na_if("") %>%
    parse_column_filtering()
  return(s)
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
    print(measured_df_filtered())
    data_rug = achilles_measured %>%
      filter(if (is.na(measured_df_filtered()[1])) TRUE else sig_id %in% measured_df_filtered()[1]) %>%
      filter(if (is.na(measured_df_filtered()[2])) TRUE else pert_id %in% measured_df_filtered()[2]) %>%
      filter(if (is.na(measured_df_filtered()[3])) TRUE else pert_iname %in% measured_df_filtered()[3]) %>%
      filter(if (is.na(measured_df_filtered()[4])) TRUE else cell_id %in% measured_df_filtered()[4]) %>%
      filter(if (is.na(measured_df_filtered()[5])) TRUE else pert_itime %in% measured_df_filtered()[5]) %>%
      filter(if (is.na(measured_df_filtered()[6])) TRUE else between(shRNA_abundance, as.numeric(measured_df_filtered()[6]), as.numeric(measured_df_filtered()[7])))
    

    if (nrow(data_rug) <= 200) {
      print("hi")
      p = achilles_measured %>%
        ggplot(aes(x=shRNA_abundance)) +
        geom_histogram(color="white") +
        my_theme() +
        labs(x="shRNA abundance", y="Count") +
        geom_rug(data = data_rug, color="red")
        
    } else {
      p = achilles_measured %>%
        ggplot(aes(x=shRNA_abundance)) +
        geom_histogram(color="white") +
        my_theme() +
        labs(x="shRNA abundance", y="Count")
    }
  } else if (selected_resource_measured() == "ctrp") {
    print(measured_df_filtered())
    data_rug = ctrp_measured %>%
      filter(if (is.na(measured_df_filtered()[1])) TRUE else sig_id %in% measured_df_filtered()[1]) %>%
      filter(if (is.na(measured_df_filtered()[2])) TRUE else pert_id %in% measured_df_filtered()[2]) %>%
      filter(if (is.na(measured_df_filtered()[3])) TRUE else pert_iname %in% measured_df_filtered()[3]) %>%
      filter(if (is.na(measured_df_filtered()[4])) TRUE else cell_id %in% measured_df_filtered()[4]) %>%
      filter(if (is.na(measured_df_filtered()[5])) TRUE else pert_itime %in% measured_df_filtered()[5]) %>%
      filter(if (is.na(measured_df_filtered()[6])) TRUE else between(log10_conc_uM_LINCS, as.numeric(measured_df_filtered()[6]), as.numeric(measured_df_filtered()[7]))) %>%
      filter(if (is.na(measured_df_filtered()[8])) TRUE else between(log10_conc_uM_CTRP, as.numeric(measured_df_filtered()[8]), as.numeric(measured_df_filtered()[9]))) %>%
      filter(if (is.na(measured_df_filtered()[10])) TRUE else between(cell_viability, as.numeric(measured_df_filtered()[10]), as.numeric(measured_df_filtered()[11])))
    
    if (nrow(data_rug) <= 200) {
      print("hi2")
      p = ctrp_measured %>%
        ggplot(aes(x=cell_viability)) +
        geom_histogram(color="white") +
        my_theme() +
        labs(x="Cell Viability", y="Count") +
        geom_rug(data = data_rug, color="red")
      
    } else {
      p = ctrp_measured %>%
        ggplot(aes(x=cell_viability)) +
        geom_histogram(color="white") +
        my_theme() +
        labs(x="Cell Viability", y="Count")
    }
  }
  # return(p)
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