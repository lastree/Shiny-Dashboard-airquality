###################
# global.R
# 
# Anything you want shared between your ui and server, define here.
###################


list.of.packages <- c("shiny","leaflet", "shinydashboard", "data.table", "plotly",
                      "viridis")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)){ 
  install.packages(new.packages)
}

lapply(list.of.packages,function(x){library(x, character.only=TRUE)}) 
