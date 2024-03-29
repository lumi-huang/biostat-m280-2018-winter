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
# LCEP <- read_rds("/home/luminghuang/biostat-m280-2018-winter/hw3/LCEP.rds")
LCEP <- read_rds("LCEP.rds")

LCEP$Base_Pay <- as.numeric(gsub('\\$', '', LCEP$`Base Pay`))
LCEP$Overtime_Pay <- as.numeric(gsub('\\$', '', LCEP$`Overtime Pay`))
LCEP$Other_Pay_Payroll_Explorer <- as.numeric(
  gsub('\\$', '', LCEP$`Other Pay (Payroll Explorer)`))
LCEP$Total_Payments <- as.numeric(
  gsub('\\$', '', LCEP$`Total Payments`))
LCEP$Q1_Payments <- as.numeric(gsub('\\$', '', LCEP$`Q1 Payments`))
LCEP$Q2_Payments <- as.numeric(gsub('\\$', '', LCEP$`Q2 Payments`))
LCEP$Q3_Payments <- as.numeric(gsub('\\$', '', LCEP$`Q3 Payments`))
LCEP$Q4_Payments <- as.numeric(gsub('\\$', '', LCEP$`Q4 Payments`))


# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("LA City Employee Payroll"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("pay",
                  label = "Choose a pay type",
                  choices = c("Total Pay", "Base Pay", 
                              "Overtime Pay", "Other Pay"),
                  selected = "Total Payments"),
      #top n highest pay
      sliderInput("n",
                  label = "Choose number of highest paid employees",
                  min = 1, max = 50,
                  value = 10),
      #select a year
      selectInput("year",
                  label = "Choose a year",
                  choices = c("2013", "2014", "2015", "2016", "2017"),
                  selected = "2017"),
      #select number of department
      sliderInput("ndep",
                  label = "Choose number of departments",
                  min = 1, max = 15,
                  value = 5),
      #select method
      radioButtons("method",
                   label = "Choose a method",
                   choices = c("Mean", "Median"),
                   selected = "Median"),
      #select employment type
      radioButtons("emptype",
                   label = "Choose an employment type",
                   choices = c("Full Time", "Part Time"),
                   selected = "Full Time")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Total payroll by LA City", textOutput("select1"), 
                 plotOutput("TPLC")),
        tabPanel("Who Earned Most?", textOutput("select2"), tableOutput("WEM")),
        tabPanel("Which Department Earned Most", textOutput("select3"), 
                 tableOutput("WDEM")),
        tabPanel("Which Departments Cost Most?", textOutput("select4"), 
                 tableOutput("WDCM")),
        tabPanel("Average Quarterly Payments", textOutput("select5"), 
                 tableOutput("AQP"))
      )
      )
  )
)


server <- function(input, output) {
  #Total payroll by LA City
  
  output$select1 <- renderText({
    paste("You have selected: Pay type = ", input$pay)
  })
  
  output$TPLC <- renderPlot({
    col_name <- switch(input$pay,
                       "Total Pay" = "Total_Payments",
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
  #Who earned most?
  output$select2 <- renderText({ 
    paste("You have selected: ",
          "Year = ", input$year, "   ", "n = ", input$n)
  })
  output$WEM <- renderTable({
    LCEP %>%
      select(`Row ID`, Year, `Department Title`, `Job Class Title`, 
             Total_Payments, Base_Pay, Overtime_Pay, 
             Other_Pay_Payroll_Explorer) %>%
      filter(Year == input$year) %>%
      arrange(desc(Total_Payments)) %>%
      top_n(input$n) %>%
      select(-Year)
  })
  
  #which department earn most
  output$select3 <- renderText({ 
    paste("You have selected: ",
          "Pay type = ", input$pay, "   ", "Method = ", input$method, "   ",
          "Year = ", input$year, "   ", "Number of Department: ", input$ndep)
  })


  output$WDEM <- renderTable({
    col_name <- switch(input$pay,
                       "Total Pay" = "Total_Payments",
                       "Base Pay" = "Base_Pay",
                       "Overtime Pay" = "Overtime_Pay",
                       "Other Pay" = "Other_Pay_Payroll_Explorer")
    method <- function(Pay){
      switch(input$method,
             "Mean" = mean(Pay, na.rm = TRUE),
             "Median" = median(Pay, na.rm = TRUE))
    }
    
    LCEP %>%
      select(Year, `Department Title`, Pay = col_name) %>%
      filter(Year == input$year) %>%
      group_by(`Department Title`) %>%
      summarise(AveragePay = method(Pay)) %>%
      arrange(desc(AveragePay)) %>%
      top_n(input$ndep)
  })

  #Which Department Cost Most?
  output$select4 <- renderText({ 
    paste("You have selected: ",
          "Year = ", input$year, "   Number of Department: ", input$ndep)
  })
  
  output$WDCM <- renderTable({
    LCEP %>%
      select(Year, `Department Title`, Total_Payments, Base_Pay, Overtime_Pay, 
             Other_Pay_Payroll_Explorer) %>%
      filter(Year == input$year) %>%
      group_by(`Department Title`) %>%
      summarise(Total_Payroll = sum(Total_Payments),
                Base = sum(Base_Pay),
                Overtime = sum(Overtime_Pay, na.rm = TRUE),
                Other = sum(Other_Pay_Payroll_Explorer)) %>%
      arrange(desc(Total_Payroll)) %>%
      top_n(input$ndep)
  })
  
  #Visualize any other information you are interested in: 
  #average quarterly payments changes by year (select employment type $emptype)
  output$select5 <- renderText({ 
    paste("You have selected: ",
          "Employment Type = ", input$emptype)
  })
  
  output$AQP <- renderTable({
    LCEP%>%
      select(Year, `Employment Type`, Q1_Payments, Q2_Payments, 
             Q3_Payments, Q4_Payments) %>%
      filter(`Employment Type` == input$emptype) %>%
      group_by(Year) %>%
      summarise(Q1 = mean(Q1_Payments, na.rm = TRUE),
                Q2 = mean(Q2_Payments, na.rm = TRUE),
                Q3 = mean(Q3_Payments, na.rm = TRUE),
                Q4 = mean(Q4_Payments, na.rm = TRUE))
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

