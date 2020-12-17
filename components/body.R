###################
# body.R
# 
# Create the body for the ui. 
# If you had multiple tabs, you could split those into their own
# components as well.
###################
body <- dashboardBody(
  tabItems(
    
    ########################
    # First tab content
    ########################
    tabItem(
      tabName = "dashboard",
      
      # INFO BOXES
      fluidRow(
        infoBoxOutput(width = 3, "infobox1"),
        infoBoxOutput(width = 3, "infobox2"),
        infoBoxOutput(width = 3, "infobox3"),
        infoBoxOutput(width = 3, "infobox4"),
      ),
      
      # TIME SERIES
      fluidRow(
        tabBox(width = 12, id = "ts",
               tabPanel("PM10", plotlyOutput("pm10_ts")),
               tabPanel("PM2.5", plotlyOutput("pm25_ts")),
               tabPanel("NO2", plotlyOutput("no2_ts")),
               tabPanel("CO", plotlyOutput("co_ts")),
               tabPanel("Viento", plotlyOutput("wind_ts")),
               tabPanel("Temperatura", plotlyOutput("temperature_ts")))
      ),
      
      # HEATMAP
      fluidRow(
        box(width = 8, title = "Promedio de emisiones según la hora del día",
            status = "primary",
            box(width = 10, solidHeader = TRUE,
                plotlyOutput("daily_pattern")),
            box(width = 2, solidHeader = TRUE, 
                radioButtons("substance", 
                             label = "Selecciona una sustancia:",
                             choices = list("PM10", "PM25", "NO2", "CO")))),
        box(width = 4, solidHeader = TRUE, 
            title = "Localización de las estaciones",
            status = "primary",
            leafletOutput("mapa"))
      )
    ),
    
    ########################
    # Second tab content
    ########################
    tabItem(
      tabName = "datos",
      h2("Serie validada 2020"),
      fluidRow(
        box(width = 12,
            dataTableOutput("datatable")          
        )
      )
    )
  )
)