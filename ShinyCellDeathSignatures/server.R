# SERVER
server = function(input, output, session) {
  source("sub/02_server_explore_measured_data.R", local=T)
  source("sub/03_server_explore_predicted_data.R", local=T)
  source("sub/04_server_predict_viability.R", local=T)

  # hide the loading message
  hide("loading-content", TRUE, "fade")  
}
