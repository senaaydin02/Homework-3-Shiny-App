library(shiny)
library(datasets)

mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))
mpgData$cyl <- factor(mpgData$cyl, levels = c("4", "6", "8"),
                      labels = c("4 Cylinders", "6 Cylinders", "8 Cylinders"))


ui <- fluidPage(
  
  titlePanel("Miles Per Gallon"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput("variable", "Variable:",
                  c("Cylinders" = "cyl",
                    "Transmission" = "am",
                    "Gears" = "gear")),
      
      
    ),
    
    mainPanel(
      
      h3(textOutput("caption")),
      
      plotOutput("mpgPlot")
      
    )
  )
)

server <- function(input, output) {
  
  formulaText <- reactive({
    paste("mpg ~", input$variable)
  })
  
  output$caption <- renderText({
    formulaText()
  })
  
  output$mpgPlot <- renderPlot({
    ggplot(data = mpgData, aes(x = mpg)) +
      geom_histogram(binwidth = 5 , color = "gray", fill = "dodgerblue4") +
      facet_wrap(~mpgData[[input$variable]], ncol = 1)
  })
  
}

shinyApp(ui, server)