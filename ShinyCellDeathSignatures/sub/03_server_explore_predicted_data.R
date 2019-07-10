# selected_resource_predicted = eventReactive(
#   input$select_resource_predicted, {
#     input$select_resource_predicted
#   }
# )

output$predicted_df = DT::renderDataTable({
  pred %>%
    mutate_if(is.double, signif, 3) %>%
    DT::datatable(., escape = F, option = list(scrollX = TRUE, autoWidth=T), 
                  filter = "top", selection = list(target = "none"))
})

output$download_predicted_achilles_ctrp = downloadHandler(
  filename = function() {
    "predicted_achilles_ctrp.csv"
  },
  content = function(file) {
    pred %>%
      write_csv(., file)
  })

output$histogram_predicted = renderPlotly({
  pred %>%
    gather(resource, viability, Achilles_prediction, CTRP_prediction) %>%
    mutate(resource = str_remove(string = resource,pattern = "_prediction")) %>%
    ggplot(aes(x=viability)) +
    geom_histogram(color="white") +
    my_theme() +
    facet_wrap(~resource, scales="free") +
    theme(legend.position = "none") +
    labs(x="Viability", y="Count")
})