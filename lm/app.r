#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(ggpubr)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Linear Modeling Shiny App"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(

            
            # Input: Select a file ----
            fileInput("file1", "Choose CSV File",
                      multiple = FALSE,
                      accept = c("text/csv",
                                 "text/comma-separated-values,text/plain",
                                 ".csv")),
            
            # Horizontal line ----
            tags$hr(),
            
            # Input: Checkbox if file has header ----
            checkboxInput("header", "Header", TRUE),
            
            # Input: Select separator ----
            radioButtons("sep", "Separator",
                         choices = c(Comma = ",",
                                     Semicolon = ";",
                                     Tab = "\t"),
                         selected = ","),
            
            # Input: Select quotes ----
            radioButtons("quote", "Quote",
                         choices = c(None = "",
                                     "Double Quote" = '"',
                                     "Single Quote" = "'"),
                         selected = '"'),
            
            # Horizontal line ----
            tags$hr(),
            
            # Input: Select number of rows to display ----
            radioButtons("disp", "Display",
                         choices = c(Head = "head",
                                     All = "all"),
                         selected = "head"),
            
            # Input: Select Linear Modeling ----
            radioButtons("Nonregression", "Regression",
                         choices = c(Nonregression = "Nonrergession",
                                     Regression = "Regression"),
                         selected = "Nonregression")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("Plot"),
           tableOutput("contents")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    dataInput <- reactive({
        req(input$file1)
        
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep,
                       quote = input$quote)
        return(df)
    })
    
    output$Plot <- renderPlot({
       if(input$regression == "Nonregression") {
        return(ggplot(data = dataInput(), aes(dataInput()$x, dataInput()$y) +
               geom_point() +
               geom_smooth(method = "lm", se = FALSE)
    }
    else {
        return(ggplot(data = dataInput(), aes(dataInput()$x,dataInput()$y)) +
               geom_point() +
               geom_smooth(method = "lm", se = FALSE) +
               stat_regline_equation(label.y = 15, aes(label = ..eq.label..)) +
               stat_regline_equation(label.y = 13, aes(label = ..rr.label..)))
        }
     })
    
# Run the application 
shinyApp(ui = ui, server = server)
