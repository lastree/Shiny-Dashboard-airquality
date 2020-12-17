###################
# server.R
# 
# For all your server needs 
###################

data <- fread("data/data.csv")
data$Fecha <- as.Date(data$Fecha)
data$fh <- as.POSIXct(paste0(data$Fecha, " ", data$Periodo, ":00"))

server <- function(input, output) {
    
  # Date range filter output
  filtered_data <- reactive({
    start <- input$time_interval[1]
    end <- input$time_interval[2]
    data[data$Fecha >= start & data$Fecha <= end, ]
  })
  
  # DataTable output
  output$datatable <- renderDataTable({
    filtered_data()
  })
  
  # Interim filter to calculate infoboxes content
  diurno <- reactive({
    filtered_data()[filtered_data()$Periodo >= 8 & filtered_data()$Periodo <= 20,]
  })
  
  # Infoboxes output
  output$infobox1 <- renderInfoBox({
    valueBox(median(diurno()$PM10, na.rm = TRUE), "Promedio diurno PM10", 
             icon = icon("lungs"), color = "blue")
  })
  output$infobox2 <- renderInfoBox({
    valueBox(median(diurno()$NO2, na.rm = TRUE), "Promedio diurno NO2", 
             icon = icon("industry"), color = "blue")
  })
  output$infobox3 <- renderInfoBox({
    infoBox("Temperatura media", 
            paste(round(mean(filtered_data()$TMP, na.rm = TRUE), 2), "°C"),
            icon = icon("thermometer-half"),
            color = "red", fill = TRUE)
  })
  output$infobox4 <- renderInfoBox({
    infoBox("Velocidad media viento", 
            paste(round(mean(filtered_data()$vv, na.rm = TRUE), 2), "m/s"),
            icon = icon("wind"), color = "olive")
  })
  
 # Time series outputs
 output$pm10_ts <- renderPlotly({
   plot_ly(filtered_data(), x = ~fh, y = ~PM10, color = ~Nombre,
           type = 'scatter', mode = 'lines') %>%
     layout(xaxis = list(title = "Fecha"))
   
 })
 
 output$pm10_ts <- renderPlotly({
   plot_ly(filtered_data(), x = ~fh, y = ~PM10, color = ~Nombre,
           type = 'scatter', mode = 'lines') %>%
     layout(xaxis = list(title = "Fecha"))
 })
 
 output$pm25_ts <- renderPlotly({
   plot_ly(filtered_data(), x = ~fh, y = ~PM25, color = ~Nombre,
           type = 'scatter', mode = 'lines') %>%
     layout(xaxis = list(title = "Fecha"))
 })
 
 output$no2_ts <- renderPlotly({
   plot_ly(filtered_data(), x = ~fh, y = ~NO2, color = ~Nombre,
           type = 'scatter', mode = 'lines') %>%
     layout(xaxis = list(title = "Fecha"))
 })
 
 output$co_ts <- renderPlotly({
   plot_ly(filtered_data(), x = ~fh, y = ~CO, color = ~Nombre,
           type = 'scatter', mode = 'lines') %>%
     layout(xaxis = list(title = "Fecha"))
 })
 
 output$wind_ts <- renderPlotly({
   plot_ly(filtered_data(), x = ~fh, y = ~vv, color = ~Nombre,
           type = 'scatter', mode = 'lines') %>%
     layout(xaxis = list(title = "Fecha"), yaxis = list(title = "Vel. viento"))
 })
 
 output$temperature_ts <- renderPlotly({
   plot_ly(filtered_data(), x = ~fh, y = ~TMP, color = ~Nombre,
           type = 'scatter', mode = 'lines') %>%
     layout(xaxis = list(title = "Fecha"), yaxis = list(title = "Temperatura"))
 })
 
 # Daily pattern
 output$daily_pattern <- renderPlotly({
   
    cols <- c("Nombre", "Periodo", input$substance)
    df <- filtered_data()[, ..cols]
    names(df)[3] <- "Sustancia"
   
    # Calculate average per hour and station
    datos_hora <- df[, list(median(Sustancia, na.rm = TRUE)), 
                       by = c("Periodo", "Nombre")]
    datos_hora$Periodo <- sprintf("%02d", datos_hora$Periodo)
    
    ggplot(datos_hora) + geom_tile(aes(x = Periodo, y = Nombre, fill = V1)) +
      scale_fill_viridis("Sustancia", option = "inferno") + 
      scale_x_discrete("Hora") + theme_minimal()
  })
  
 output$mapa <- renderLeaflet({
    cols <- c("Nombre", "latitud", "longitud")
    estaciones <- unique(filtered_data()[, ..cols])
    leaflet(data = estaciones) %>% addTiles() %>%
      addMarkers(~longitud, ~latitud, popup = ~Nombre, label = ~Nombre)
  })
}

