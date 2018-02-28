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
LCEP <- read_rds("/home/luminghuang/biostat-m280-2018-winter/hw3/LCEP.rds")

LCEP$Base_Pay <- as.numeric(gsub('\\$', '', LCEP$`Base Pay`))
LCEP$Overtime_Pay <- as.numeric(gsub('\\$', '', LCEP$`Overtime Pay`))
LCEP$Other_Pay_Payroll_Explorer <- as.numeric(
  gsub('\\$', '', LCEP$`Other Pay (Payroll Explorer)`))


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("LA City Employee Payroll"),
   
   # Sidebar with a slider input for year and pay types
   sidebarLayout(
      sidebarPanel(
        helpText("Total payroll by LA City"),
        
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
  output$TPLC <- renderPlot({
    col_name <- switch(input$pay,
             "Base Pay" = "Base_Pay",
             "Overtime Pay" = "Overtime_Pay",
             "Other Pay" = "Other_Pay_Payroll_Explorer")
    
    LCEP %>% 
      select(Year, Pay = col_name) %>%
      group_by(Year) %>%
      summarise(TotalPay = sum(Pay, na.rm = TRUE)) %>%
      ggplot(mapping = aes(x = Year, y = TotalPay)) +
      geom_col()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

