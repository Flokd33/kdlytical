fct_summary <- function(data) {
  
  df <- data.frame(
    nb_positions = length(data$Ticker) - length(data$Value_perc[data$Ticker == "CASH"]),
    total_value_eur = sum(data$Value)  ,
    total_pnl_eur = sum(data$PnL),
    total_pnl_perc_eur = sum(data$PnL_perc),
    weighted_avg_div_yield = sum(data$Value_perc * data$DIV_yield) ,
    cash_value = sum(data$Value[data$Ticker == "CASH"]),
    cash_perc = sum(data$Value_perc[data$Ticker == "CASH"]),
    max_position = max(data$Value_perc),
    top_five_perc = sum(data$Value_perc[order(data$Value_perc, decreasing = TRUE)] [1:5]),
    row.names = "Value"
    )
  
  metrics <- c("# positions","Value EUR","PnL EUR","PNL EUR %","Port Div %","Cash EUR","Cash EUR %","Top 1 %","Top 5 %")
  data_final <- data.frame(t(df))
  data_final$Metric <- metrics
  data_final <- data_final[,c("Metric","Value")]
  rownames(data_final) <- NULL
  
  return(data_final)
}