library(mapdeck)
source("bd_covid19.R")

mapaCasosCanton = renderMapdeck({
  
  DS                = fx_corte_status_pais_mapa()
  DS$Leyenda        = paste(DS$canton, " : ", DS$positivos)
  DS$Elevacion      = 1000 * DS$positivos
  
  mapa = mapdeck( 
    style = mapdeck_style("light"),
    pitch = 60,
    location = c(-84.3, 9.5),
    zoom=10
  ) 
  
  mapa%>% 
    add_column(data = DS
     , lat = "latitud"
     , lon = "longitud"
     , elevation = "Elevacion"
     , disk_resolution = 20
     , radius = 1000
     , tooltip = "Leyenda"
     , highlight_colour = "#AAFFFFFF"
     , palette = "inferno"
     #, fill_opacity = 0.6
     , auto_highlight = TRUE
   )
})