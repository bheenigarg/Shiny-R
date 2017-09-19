#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(leaflet)
library(dplyr)
library(RColorBrewer)

con <- gzcon(url(paste("ftp://ftp.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/",
                                 "StormEvents_locations-ftp_v1.0_d2015_c20170718.csv.gz", sep="")))

txt <- readLines(con)
storm <- read.csv(textConnection(txt))
stormdata <- tbl_df(storm)

# Define UI for application that creates the storm map
ui <- fluidPage(
   
   # Application title
   titlePanel("2016 Storm Event Data"),
   
   # Sidebar with a slider input 
   sidebarLayout(
      sidebarPanel(
         sliderInput("stormRange", "Ranges", min(stormdata$RANGE), max(stormdata$RANGE), 
                     value = range(stormdata$RANGE), step = 0.1),
         actionButton("goButton", "Show in map!"),
         selectInput("month", "Month", choices = 1:12)
      ),
      
      # Show a plot of the generated map
      mainPanel(
         leafletOutput("stormMap")
         #tableOutput("viewData")
      )
   )
)

# Define server logic required to create map
server <- function(input, output, session) {
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- eventReactive(input$goButton, {
    stormdata %>% filter(RANGE >= input$stormRange[1] & RANGE <= input$stormRange[2])
  })
   
  # create the map
   output$stormMap <- renderLeaflet({
     leaflet(stormdata[1:20,]) %>% addTiles() %>%
       setView(lng = -97.40, lat = 34.68, zoom = 4) %>%
       addProviderTiles("Stamen.TonerLite",
                        options = providerTileOptions(noWrap = TRUE)
       ) %>%
       addMarkers(data = filteredData())
   })
   # 
   # # A reactive expression that returns the set of zips that are
   # # in bounds right now
   # rangeInBounds <- reactive({
   #   latRng <- range(stormdata$LATITUDE)
   #   lngRng <- range(stormdata$LONGITUDE)
   #   
   #   subset(filteredData,
   #          latitude >= latRng[1] & latitude <= latRng[2] &
   #            longitude >= lngRng[1] & longitude <= lngRng[2])
   # })
   # 
   # # This observer is responsible for maintaining the circles and legend,
   # # according to the variables the user has chosen to map to color and size.
   # observe({
   #   leafletProxy("stormMap", data = filteredData) %>%
   #     clearShapes() %>%
   #     addCircles(~longitude, ~latitude, radius=radius, 
   #                stroke=FALSE, fillOpacity=0.4)
   # })
   # 
}

# Run the application 
shinyApp(ui = ui, server = server)

