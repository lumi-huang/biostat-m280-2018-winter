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
setwd(".")
LCEP <- readRDS("/home/luminghuang/biostat-m280-2018-winter/hw3/LCEP.rds")
head(LCEP)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("LA City Employee Payroll"),
   
   # Sidebar with a slider input for year and pay types
   sidebarLayout(
      sidebarPanel(
        helpText("Total payroll by LA City"),
        #Visualize the total LA City payroll of each year, with breakdown into 
        #base pay, overtime pay, and other pay
        selectInput("pay",
                    label = "Choose a pay type",
                    choices = c("Base Pay", "Overtime Pay", "Other Pay"),
                    selected = "Base Pay")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("TPLC")
      )
   )
)


server <- function(input, output) {
     pay_type <- reactive({
       switch(LCEP$pay,
              "Base Pay" = LCEP$`Base Pay`,
              "Overtime Pay" = LCEP$`Overtime Pay`,
              "Other Pay" = LCEP$`Other Pay (Payroll Explorer)`)
     })
     year <- LCEP$Year
     
     output$plot <- renderPlot()


}

# Run the application 
shinyApp(ui = ui, server = server)

