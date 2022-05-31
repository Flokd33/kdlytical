require(quantmod)

fct_marketdata_positions_yahoo <- function(list_tickers) {
  getSymbols(list_tickers, from="1997-12-31", src='yahoo')
  
  return(df)
}

fct_marketdata_price_history_yahoo <- function(list_tickers, start, end) {

  getSymbols(list_tickers, from = start, to = end, src='yahoo')
  return(df)
  
}

fct_marketdata_dividend_history_yahoo <- function(list_tickers, start, end) {
  
  getSymbols(list_tickers, from = start, to = end, src='yahoo')
  return(df)
  
}