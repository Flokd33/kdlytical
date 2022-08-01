require(DT)
require(xlsx)
require(htmltools)
require(readr)
source("dev_scripts/fct_summary_positions.R")
source("dev_scripts/fct_summary_inventory.R")
source("dev_scripts/fct_marketdata.R")
source("dev_scripts/fct_enrich_positions.R")
source("dev_scripts/fct_enrich_inventory.R")
#at work version 3.6.1
#https://rstudio.github.io/DT/
#https://rstudio.github.io/DT/010-style.html
#https://htmlcolorcodes.com/fr/

#------------------------------------------------- DATA ------------------------------------------------------------
data_positions_raw <- read_csv("data_positions.csv", col_names = TRUE, show_col_types = FALSE) # for now it has market data but need to change this. Poistion only has Ticker Name Account CCY Quantity PRU and Strategies
data_trades_raw <- read_csv("data_trades.csv", col_names = TRUE, show_col_types = FALSE)
data_allocation_strategy <- read_csv("data_allocation_strategy.csv", col_names = TRUE, show_col_types = FALSE)
data_metals_inventory <- read_csv("data_metals_inventory.csv", col_names = TRUE, show_col_types = FALSE)

data_market <- fct_marketdata_positions_yahoo(data_positions_raw$Ticker)
data_prices <- fct_marketdata_price_history_yahoo(data_positions_raw$Ticker, "1997-12-31", "2022-06-30")
data_dividends <- fct_marketdata_dividend_history_yahoo(data_positions_raw$Ticker,"1997-12-31", "2022-06-30")

data_positions_enriched <- fct_enrich_positions(data_positions_raw,data_market,data_allocation_strategy)
data_inventory_enriched <- fct_enrich_inventory(data_metals_inventory)

headers <- colnames(data_positions_raw)
col_border <- c("PRU","PnL_perc","DIV_yield")
#------------------------------------------------- JS Headers Formating --------------------------------------------eq(x) is the header position to target----
headjs <- "function(thead) {
  $(thead).closest('thead').find('th').eq(0).css({'background-color': '#91C1D5', 'border-right': 'solid 1px'});
   $(thead).closest('thead').find('th').eq(1).css({'background-color': '#C0B1ED', 'border-right': 'solid 1px'});
   $(thead).closest('thead').find('th').eq(2).css({'background-color': '#F1BCF5', 'border-right': 'solid 1px'});
   
   $(thead).closest('thead').find('th').eq(8).css('border-right', 'solid 1px');
   $(thead).closest('thead').find('th').eq(13).css('border-right', 'solid 1px');
   $(thead).closest('thead').find('th').eq(22).css('border-right', 'solid 1px');

}"
#------------------------------------------------- Create Headers ---------------------------------------------------custom table container----
sketch = htmltools::withTags(table(
  class = 'display',
  thead(
    tr(
      th(colspan = 6, "Static"),
      th(colspan = 5, "Performance"),
      th(colspan = 9, "Market Data")
    ),
    tr(
        lapply(headers, th) #th(style = "border-right: solid 1px;", "PRU")
    )
  )
))
#print(sketch)
#------------------------------------------------- DT positions ---------------------------------------------------------------
datatable(data_positions_raw,
          options = list(pageLength = 50, headerCallback = JS(headjs), searching = TRUE, dom = "ltipr"), #dom = "ltipr in order to remove the search bar at the top but keep the search fucntionality
          rownames = FALSE, filter = "bottom", container = sketch) %>% 
formatStyle(match(col_border,headers), `border-right` = "solid 1px") %>%
formatStyle("PnL_perc", background = styleColorBar(data_positions_raw$PnL_perc, 'lightblue'),
                     backgroundSize = '98% 95%',
                     backgroundRepeat = 'no-repeat',
                     backgroundPosition = 'right') %>% 
formatCurrency("Value", "€", digits = 0) %>% 
formatRound(c("PRU","PnL"), digits = 1) %>% 
formatPercentage(c("Value_perc","PnL_perc","DIV_yield"), digits = 1)

#------------------------------------------------- DT summary---------------------------------------------------------------
datatable(fct_summary(data_positions_raw))
