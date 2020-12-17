###################
# sidebar.R
# 
# Create the sidebar menu options for the ui.
###################
sidebar <- dashboardSidebar(
  sidebarMenu(
    dateRangeInput("time_interval", "Seleccione un intervalo de fechas:", 
                   start = "2020-01-01",
                   end = "2020-12-31"),
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Datos", tabName = "datos", icon = icon("table"))
    
  )
)
