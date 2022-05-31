require(DT)
require(xlsx)
require(htmltools)
require(readr)
source("dev_scripts/fct_summary.R")
#at work version 3.6.1
#https://rstudio.github.io/DT/
#https://rstudio.github.io/DT/010-style.html
#https://htmlcolorcodes.com/fr/
#data represent postions + market data 

#------------------------------------------------- DATA ------------------------------------------------------------
data <- read_csv("data_portfolio.csv", col_names = TRUE,show_col_types = FALSE) # data <- read.xlsx("C:/Users/fcadet/Documents/Florian/R/portfolio_screenshot.xlsx", sheetIndex = 1) #"Ticker"     "Name"       "Account"    "CCY"        "Quantity"   "PRU"        "Price"      "Value"      "Value_perc" "PnL."       "PnL_perc"   "Strategy1" "Strategy2"  "Factor"     "PE"         "PB"         "FPE"        "DIV_yield" 
headers <- colnames(data)
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
      th(colspan = 9, "Additional")
    ),
    tr(
        lapply(headers, th) #th(style = "border-right: solid 1px;", "PRU")
    )
  )
))
#print(sketch)sdf
#------------------------------------------------- DT positions ---------------------------------------------------------------
datatable(data,
          options = list(pageLength = 50, headerCallback = JS(headjs), searching = TRUE, dom = "ltipr"), #dom = "ltipr in order to remove the search bar at the top but keep the search fucntionality
          rownames = FALSE, filter = "bottom", container = sketch) %>% 
formatStyle(match(col_border,headers), `border-right` = "solid 1px") %>%
formatStyle("PnL_perc", background = styleColorBar(data$PnL_perc, 'lightblue'),
                     backgroundSize = '98% 95%',
                     backgroundRepeat = 'no-repeat',
                     backgroundPosition = 'right') %>% 
formatCurrency("Value", "€", digits = 0) %>% 
formatRound(c("PRU","PnL"), digits = 1) %>% 
formatPercentage(c("Value_perc","PnL_perc","DIV_yield"), digits = 1)

#------------------------------------------------- DT summary---------------------------------------------------------------
datatable(fct_summary(data))


