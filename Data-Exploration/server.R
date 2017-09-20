#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
# use the below options code if you wish to increase the file input limit, in this example file input limit is increased from 5MB to 9MB
options(shiny.maxRequestSize = 12*1024^2)

# Define server logic to import csv file
shinyServer(function(input, output) {
  
  # This reactive function will take the inputs from UI.R and use them for read.csv() to read the data from the file. It returns the dataset in the form of a dataframe.
  # file$datapath -> gives the path of the file
  
  data <- reactive({
    file1 <- input$file
    if(is.null(file1)){return()}
    read.csv(file = file1$datapath, header = input$header, stringsAsFactors = input$stringsAsFactors)
    
  })
  
  # this reactive output contains the summary of the dataset and display the summary in table format
  output$filedf <- renderTable({
    if(is.null(data())){return ()}
    input$file
  })
  
  
  # This reactive output contains the dataset and display the dataset in table format
  output$table <- renderTable({
    if(is.null(data())){return ()}
    head(data(), n= 15)
  })
  
  # this reactive output contains the summary of the dataset and display the summary in table format
  output$sum <- renderDataTable({
    if(is.null(data())){return ()}
    summary(data())
    
  })
  
  # This reactive output contains the dataset and display the structure in table format
  output$struct <- renderPrint({
    if(is.null(data())){return ()}
    str(data())
  })
  
  # the following renderUI is used to dynamically generate the tabsets when the file is loaded. Until the file is loaded, app will not show the tabset.
  output$contents <- renderUI({
    if(is.null(data()))
      h5("Powered by", tags$img(src='RStudio-Ball.png', heigth=200, width=200))
    else
      tabsetPanel(tabPanel("File Description", tableOutput("filedf")),tabPanel("Data", tableOutput("table")),tabPanel("Summary", dataTableOutput("sum")), tabPanel("Structure", verbatimTextOutput("struct")))
  })
})



