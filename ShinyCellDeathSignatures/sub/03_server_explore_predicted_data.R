selected_pert_predicted = eventReactive(
  input$select_pert_predicted, {
    switch(
      input$select_pert_predicted,
      "cl" = {
        # rm(cl_df, crispr_df, oe_df, shrna_df, ctrl_df)
        cl_df = read_csv("data/predictions/compound_ligand_pred.csv",)
        },
      "crispr" = {
        # rm(cl_df, crispr_df, oe_df, shrna_df, ctrl_df)
        crispr_df = read_csv("data/predictions/crispr_pred.csv")
        }, 
      "oe" = {
        # rm(cl_df, crispr_df, oe_df, shrna_df, ctrl_df)
        oe_df = read_csv("data/predictions/over_expression_pred.csv")
        },
      "shrna" = {
        # rm(cl_df, crispr_df, oe_df, shrna_df, ctrl_df)
        shrna_df = read_csv("data/predictions/shRNA_pred.csv")
        },
      "ctrl" = {
        # rm(cl_df, crispr_df, oe_df, shrna_df, ctrl_df)
        ctrl_df = read_csv("data/predictions/control_pred.csv")
      }
      )
  }
)

output$predicted_df = DT::renderDataTable({
  selected_pert_predicted() %>%
    mutate_if(is.character, as.factor) %>%
    mutate(pert_itime = ordered(pert_itime,
                                levels = c("1 h","2 h", "3 h", "4 h", "6 h",
                                           "24 h", "48 h", "72 h", "96 h",
                                           "120 h", "144 h", "168 h"))) %>%
    mutate_if(is.double, signif, 3) %>%
    DT::datatable(., escape = F, option = list(scrollX = TRUE, autoWidth=T), 
                  filter = "top", selection = list(target = "none"))
})

output$download_select_pert = downloadHandler(
  filename = function() {
    "selected_viabilities_achilles_ctrp.csv"
  },
  content = function(file) {
    selected_pert_predicted() %>%
      write_csv(., file)
  })

output$histogram_predicted = renderPlotly({
  selected_pert_predicted() %>%
    gather(resource, viability, Achilles_prediction, CTRP_prediction) %>%
    mutate(resource = str_remove(string = resource,pattern = "_prediction")) %>%
    ggplot(aes(x=viability)) +
    geom_histogram(color="white") +
    my_theme() +
    facet_wrap(~resource, scales="free") +
    theme(legend.position = "none") +
    labs(x="Viability", y="Count")
})

