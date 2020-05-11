library(mapdeck)
library(geojsonio)
library(leaftime)
source("bd_covid19.R")



mapaTimeline = renderLeaflet({
  
  ds_contagiocanton = fx_corte_status_pais_mapa(pnAcumula = 1)
  
  pZoom=7
  pLat0=ave(na.omit(ds_contagiocanton$latitud))[1]
  pLon0=ave(na.omit(ds_contagiocanton$longitud))[1]
  
  ds_contagiocanton$id=8*log(1+(ds_contagiocanton$positivos - (ds_contagiocanton$recuperados + ds_contagiocanton$fallecidos) ))  
  
  start = min(ds_contagiocanton$fecha)
  end = max(ds_contagiocanton$fecha)
  steps = as.numeric(end - start)
  
  names(ds_contagiocanton)[names(ds_contagiocanton) == "fecha"] <- "start"
  ds_contagiocanton$end=ds_contagiocanton$start
  
  power_geo <- geojsonio::geojson_json(ds_contagiocanton,lat="latitud",lon="longitud")
  
  leaflet(power_geo) %>%  
    
    addTiles(group = "OSM (default)") %>%
    addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
    addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
    
    addLayersControl(
      baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
      options = layersControlOptions(collapsed = FALSE))%>%
    
    setView(pLon0,pLat0,pZoom) %>%
    addTimeline(
      sliderOpts = sliderOptions(
        formatOutput = htmlwidgets::JS("function(date) {return new Date(date).toDateString()}"),
        position = "bottomright",
        step = steps,
        duration = 10000,
        showTicks = FALSE
      ),
      timelineOpts = timelineOptions(
        pointToLayer = htmlwidgets::JS(
          "function(data, latlng) {
                      var marker = new L.circleMarker(latlng, {
                        radius: parseInt(data.properties.id),
                        color: '',
                        fillColor: 'red',
                        fillOpacity: 0.25
                      })
                      //console.log(marker)
                      marker.options.radius = parseInt(data.properties.id)
                      return marker.bindTooltip(
                        data.properties.canton +': ' + data.properties.positivos + '<br/>Dia: ' + data.properties.start,
                        {permanent: false}
                      ).openTooltip()
                    }"
          
        ),
        styleOptions=function(
          radius = NULL,
          color = NULL,
          stroke = TRUE,
          fill = TRUE,
          fillColor = NULL,
          fillOpacity = NULL)
        {
          Filter(Negate(is.null), 
                 list(radius = radius,
                      color = color,
                      stroke = stroke,
                      fill = fill,
                      fillColor = fillColor,
                      fillOpacity = fillOpacity))
        }()))
})