# check reactiveFileREader
# gex = reactive({
#   inFile = input$user_input
#   if (is.null(inFile)){
#     return(NULL)
#   }
#   withProgress(message="Read in expression matrix", value=10, {
#     df = read.csv(inFile$datapath, sep=";", row.names=1, check.names = F)
#     if (ncol(df) == 0) {
#       df = read.csv(inFile$datapath, sep=",", row.names=1, check.names = F)
#     }
#   })
#   return(df)
# })

output$gex_matrix = DT::renderDataTable({
  gex %>% 
    mutate_if(is.double, signif, 3) %>%
    DT::datatable(., escape = F, option = list(scrollX = TRUE, autoWidth=T), 
                  filter = "top", selection = list(target = "none"))
})

predictions = eventReactive(input$submit, {
  design = tribble(
    ~resource, ~model, ~gex,
    "Achilles", achilles_model, gex,
    "CTRP", ctrp_model, gex)
  
  predictions = design %>%
    transmute(resource, pred = pmap(., .f = function(gex, model, ...) {
      gex_mapped = semi_join(gex, model,by="gene") %>%
        arrange(gene) %>%
        column_to_rownames("gene") %>%
        as.matrix()
      
      model_mapped = semi_join(model, gex, by="gene") %>%
        arrange(gene) %>%
        column_to_rownames("gene") %>%
        as.matrix()
 
      stopifnot(rownames(gex_mapped) == rownames(model_mapped))
      t(gex_mapped) %*% model_mapped %>%
        data.frame(check.names = F, stringsAsFactors = F) %>%
        rownames_to_column("sample") %>%
        as_tibble() %>%
        rename(Viability = coefficient)
    })) %>%
    unnest(pred)
  
})

# switch from expression tab to prediction tab when button is pushed
observeEvent(input$submit, {
  updateTabsetPanel(session, "tab_panel",
                    selected = "tab_viability")
})

output$pred_matrix = DT::renderDataTable({
  predictions() %>% 
    spread(resource, Viability) %>%
    mutate_if(is.double, signif, 3) %>%
    DT::datatable(., escape = F, option = list(scrollX = TRUE, autoWidth=T), 
                  filter = "top", selection = list(target = "none"))
})

output$bar_plot = renderPlotly({
  p = predictions() %>%
    mutate(label = str_trunc(sample, 10)) %>%
    arrange(sample) %>%
    mutate(sample = as_factor(sample)) %>%
    ggplot(aes(x=label, y=Viability, label=sample)) +
    geom_col() +
    facet_wrap(~resource, scales="free_x") +
    coord_flip() +
    my_theme() +
    theme(axis.title.y = element_blank())
  
  ggplotly(p, tooltip = c("sample", "Viability"))
})

output$cor_plot = renderPlotly({
  predictions() %>%
    spread(resource, Viability) %>%
    ggplot(aes(x=Achilles, y=CTRP, label=sample)) +
    geom_point() +
    my_theme() +
    geom_smooth(method = "lm")
})

output$download_pred_via = downloadHandler(
  filename = function() {
    "viability_predictions.csv"
  },
  content = function(file) {
    predictions() %>%
      spread(resource, Viability) %>%
      write_csv(., file)
  })

