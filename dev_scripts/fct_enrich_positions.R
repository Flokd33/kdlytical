fct_enrich_positions <- function(data_positions, data_market, data_allocation) {

#data_final <- data_positions + data_market + allocation
  
strategies <- data_allocation$Strategy
total_value <- sum(data_positions$Value)
data_allocation$count <- NA

for (i in 1:length(strategies)) {data_allocation$count[i] <- length(data_positions$Ticker[data_positions$Strategy1 == strategies[i]]) +
  length(data_positions$Ticker[data_positions$Strategy2 == strategies[i] & is.na(data_positions$Strategy2) == FALSE])
  }

data_positions$allocation_strat1 <- data_allocation$Target[match(data_positions$Strategy1,data_allocation$Strategy)] * total_value / data_allocation$count[match(data_positions$Strategy1,data_allocation$Strategy)]
data_positions$allocation_strat2 <-  data_allocation$Target[match(data_positions$Strategy2,data_allocation$Strategy)] * total_value / data_allocation$count[match(data_positions$Strategy2,data_allocation$Strategy)]

data_positions$allocation_strat1[is.na(data_positions$allocation_strat1)] <- 0
data_positions$allocation_strat2[is.na(data_positions$allocation_strat2)] <- 0

data_positions$allocation_total <-  data_positions$allocation_strat1 + data_positions$allocation_strat2
data_positions$allocation_delta <-  data_positions$allocation_total - data_positions$Value
                                  
  return(data_final)
}