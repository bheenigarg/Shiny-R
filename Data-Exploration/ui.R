#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Importing a CSV File"),
  
  # Sidebar with file input 
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose CSV file",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      tags$hr(),
      checkboxInput("header", "Header", FALSE),
      checkboxInput("stringsAsFactors", "stringsAsFactors", FALSE)
    ), # close sidebarPanel
    
    # Show a panel with desired outputs
    mainPanel(
      uiOutput("contents")
    )
  )
))
