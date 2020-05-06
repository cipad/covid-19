library(leaflet)
source("bd_covid19.R")

# PARAMETROS ----
pFactorRadio=50

SetDatos=fx_corte_status_pais_mapa()

mapaContagiosPais = renderLeaflet({
  leaflet(SetDatos) %>%
    
    addTiles(group = "OSM (default)") %>%
    
    addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
    
    addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
    
    addCircles(
      lng=SetDatos$longitud,
      lat=SetDatos$latitud,
      radius=pFactorRadio*(SetDatos$positivos),
      stroke = F,
      color = "#333634",
      fillOpacity = 0.5,
      group = "SetDatos",
      label = paste0("POSITIVOS ",SetDatos$canton," : ",SetDatos$positivos),
      labelOptions = labelOptions(noHide = F)
    ) %>%
    
    addCircles(
      lng=SetDatos$longitud,
      lat=SetDatos$latitud,
      radius=pFactorRadio*(SetDatos$activos),
      stroke = F,
      color = "#2c2cb0",
      fillOpacity = 0.8,
      group = "SetDatos",
      label = paste0("ACTIVOS ",SetDatos$canton," : ",SetDatos$activos),
      labelOptions = labelOptions(noHide = F)
    ) %>%
    
    addCircles(
      lng=SetDatos$longitud,
      lat=SetDatos$latitud,
      radius=pFactorRadio*(SetDatos$recuperados),
      stroke = F,
      color = "#2cab27",
      fillOpacity = 0.6,
      group = "SetDatos",
      label = paste0("RECUPERADOS ",SetDatos$canton," : ",SetDatos$recuperados),
      labelOptions = labelOptions(noHide = F)
    ) %>%
    
    addCircles(
      lng=SetDatos$longitud,
      lat=SetDatos$latitud,
      radius=pFactorRadio*(SetDatos$fallecidos),
      stroke = F,
      color = "#9e0931",
      fillOpacity = 0.7,
      group = "SetDatos",
      label = paste0("FALLECIDOS ",SetDatos$canton," : ",SetDatos$fallecidos),
      labelOptions = labelOptions(noHide = F)
    ) %>%
    
    addLayersControl(
      baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
      options = layersControlOptions(collapsed = FALSE)
    )
})