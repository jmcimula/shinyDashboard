library(shinydashboard)
library(dplyr)
library(bubbles)
source("global.R")


ui <- dashboardPage(
  dashboardHeader(title = "World Internet Report"),
  dashboardSidebar(

   # sliderInput("mgtThresh", "Threshold Manager",
   #              min = 0, max = 50, value = 3, step = 0.1
   # ),
    
    h4("Dashboard and Data"),
    #sidebarSearchForm(textId = "searchText", buttonId = "searchButton",label = "Search..."),
    sidebarMenu( 
           menuItem("Dashboard", tabName = "dashboard",icon = icon("dashboard")), 
           menuItem("Data Source", icon = icon("th"), tabName = "rawdata",badgeLabel = "new", badgeColor = "green") 
    ) 
    
),
  dashboardBody(
    tabItems( 
      tabItem("dashboard", 
              fluidRow( 
                valueBoxOutput("rate"), 
                valueBoxOutput("count"), 
                valueBoxOutput("users") 
              ), 
              fluidRow( 
                box( 
                  width = 8, status = "info", solidHeader = TRUE, 
                  title = "Overview internet Penetration of 50 first Countries", 
                  bubblesOutput("packagePlot", width = "100%", height = 600) 
                ), 
                box( 
                  width = 4, status = "info", 
                  title = "Perc. (%) internet users/ Country", 
                  tableOutput("packageTable") 
                ) 
              ) 
      ), 
              tabItem("rawdata", 
              numericInput("maxrows", "Rows to show", 30), 
              verbatimTextOutput("rawtable"), 
              downloadButton("downloadCsv", "Download as CSV") 
      ) 
    )

  )
)

server <- function(input, output) {

  output$rawtable <- renderPrint({
    
    orig <- options(width = 1000)
    print(tail(pkgData(1), input$maxrows))
    options(orig)
    
  })
  
output$packageTable <- renderTable({ 
    print(head(select(pkgData(1),"Country" = Country,"Users" = Internet, "Penetration" = Penetration),20)) 
  }, digits = 1)

output$packagePlot <- renderBubbles({ 
  if (nrow(pkgData(1)) == 0) 
    return()  
  
  order <- unique(pkgData(1)$Country) 
  df <- head(select(pkgData(1),Country,Penetration),n = 50)
 ## head(60) 
  bubbles(df$Penetration, df$Country, key = df$Country) 
}) 

  
}

shinyApp(ui, server)