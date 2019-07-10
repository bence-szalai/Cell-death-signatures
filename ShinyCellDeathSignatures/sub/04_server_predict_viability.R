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

# data
gex = reactive({
  if (input$take_example_data == F) {
    shinyjs::enable("user_input")
    inFile = input$user_input
    if (is.null(inFile)){
      return(NULL)
    }
    read_csv(inFile$datapath)
  } else {
    shinyjs::disable("user_input")
    example_data 
  }
})

selected_model = eventReactive(
  input$select_model, {
    input$select_model
  }
)

output$gex_matrix = DT::renderDataTable({
  if (!is.null(gex())) {
    gex() %>% 
      mutate_if(is.double, signif, 3) %>%
      DT::datatable(., escape = F, option = list(scrollX = TRUE, autoWidth=T), 
                    filter = "top", selection = list(target = "none")) 
  }
})

predictions = eventReactive(input$submit, {
  design = tribble(
    ~resource, ~model, ~gex,
    "Achilles", achilles_model, gex(),
    "CTRP", ctrp_model, gex())
  
  predictions = design %>%
    transmute(resource, pred = pmap(., .f = function(gex, model, ...) {

      # extract intersect of linear model
      b = model %>% filter(gene == "intercept") %>% pull(coefficient)
      
      # subset expression matrix to genes which are available in linear model
      gex_mapped = semi_join(gex, model,by="gene") %>%
        arrange(gene) %>%
        column_to_rownames("gene") %>%
        as.matrix()
      
      # subset linear model to genes which are available in expression matrix
      model_mapped = semi_join(model, gex, by="gene") %>%
        arrange(gene) %>%
        column_to_rownames("gene") %>%
        as.matrix()
 
      # check whether only common genes are in expression matrix and model and 
      # if they are in the same order
      stopifnot(rownames(gex_mapped) == rownames(model_mapped))
      
      # prediction of viabilities from gene expression
      t(gex_mapped) %*% model_mapped %>%
        data.frame(check.names = F, stringsAsFactors = F) %>%
        rownames_to_column("sample") %>%
        as_tibble() %>%
        rename(Viability = coefficient) %>%
        # add intercept of linear model
        mutate(Viability = Viability + b)
    })) %>%
    unnest(pred)
  
})

# switch from expression tab to prediction tab when button is pushed
observeEvent(input$submit, {
  updateTabsetPanel(session, "tab_panel",
                    selected = "tab_viability")
  show("select_model")
  show("select_model_label")
})

output$pred_matrix = DT::renderDataTable({
  predictions() %>% 
    spread(resource, Viability) %>%
    mutate_if(is.double, signif, 3) %>%
    DT::datatable(., escape = F, option = list(scrollX = TRUE, autoWidth=T), 
                  filter = "top", selection = list(target = "none"))
})

output$bar_plot = renderPlotly({
  if (selected_model() == "Achilles") {
    i = predictions() %>%
      mutate(label = str_trunc(sample, 5, ellipsis = "")) %>%
      arrange(resource, Viability) %>%
      mutate(label = as_factor(label))
  } else if (selected_model() == "CTRP") {
    i = predictions() %>%
      mutate(label = str_trunc(sample, 5, ellipsis = "")) %>%
      arrange(desc(resource), Viability) %>%
      mutate(label = as_factor(label))
  }
  p = i %>%
    ggplot(aes(x=label,y=Viability, label=sample)) +
    # geom_segment(aes(x=fct_reorder(label, Viability), xend=fct_reorder(label, Viability), y=0, yend=Viability), color="grey") +
    geom_segment(aes(x=label, xend=label, y=0, yend=Viability), color="grey") +
    geom_point(size=1) +
    facet_wrap(~resource, scales="free_x") +
    coord_flip() +
    my_theme() +
    theme(panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank()) +
    theme(axis.title.y = element_blank())
  
  ggplotly(p, tooltip = c("sample", "Viability"))
})

output$cor_plot = renderPlotly({
  df = predictions() %>%
    spread(resource, Viability)
  
  r = cor.test(df$Achilles, df$CTRP) %>%
    tidy() %>%
    transmute(label = str_c("r = ", signif(estimate,3), 
                            " (p = ",signif(p.value, 3), ")")) %>%
    mutate(Achilles = mean(df$Achilles), CTRP = max(df$CTRP))
  
  df %>%
    ggplot(aes(x=Achilles, y=CTRP, label=sample)) +
    geom_point() +
    my_theme() +
    geom_smooth(method = "lm") +
    # geom_text(data = r, aes(label = label), 
    #           vjust = "inward", hjust = "inward") +
    labs(x="Viability predictions by Achilles-model",
         y="Viability predictions by CTRP-model",
         subtitle = r$label,
         title = r$label,
         caption = "Correlation of predicted viability scores")

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

output$download_achilles_model = downloadHandler(
  filename = function() {
    "achilles_model.csv"
  },
  content = function(file) {
    achilles_model %>%
      write_csv(., file)
  })

output$download_ctrp_model = downloadHandler(
  filename = function() {
    "ctrp_model.csv"
  },
  content = function(file) {
    ctrp_model %>%
      write_csv(., file)
  })

