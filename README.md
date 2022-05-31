# kdlytical <br /><b> 

Multi task app covering:                                                       </b><br />
- Portfolio Analytics (positions, allocation, optimisation, trades, PnL ...)   <br />
- Market data                                                                  <br />
- Wealth Monitoring (aggregated wealth..)                                      <br />
- Technical Analysis & Regressions                                             <br />
- Gold screening (web scrapping)                                               <br />

Run App with =>  shiny::runGitHub( "Flokd33/kdlytical", username = "Flokd33", subdir = "app") => in the App folder, app.R or ui.R + server.R requeried




data_positions + data_market (of positions) = data_positions_market (make fct )
data_price (of postions) =>  time serie


ui -> textOutput("clicked")
server -> 
  output$clicked <- renderPrint(
    input$table_cell_clicked
  )
  table is the name of the output