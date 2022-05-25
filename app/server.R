source("C:/Users/fcadet/Documents/kdlytical/dev_scripts/clean_data_test.R")

server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- divide_by_two(faithful[, 2])
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, col = 'darkgray', border = 'white')
  })
}
