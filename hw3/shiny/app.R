#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/ 
#

library(shiny)
library(tidyverse)
setwd(.)
LCEP <- readRDS("/home/luminghuang/biostat-m280-2018-winter/hw3/LCEP.rds")
head(LCEP)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("LA City Employee Payroll"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        helpText("Total payroll by LA City"),
        #Visualize the total LA City payroll of each year, with breakdown into 
        #base pay, overtime pay, and other pay
        selectInput("var",)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({

   })
}

# Run the application 
shinyApp(ui = ui, server = server)

