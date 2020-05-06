library(leaflet)
library(jsonlite)
source("bd_covid19.R")


mapaWS = function(canton, segundos, medio){
  
  SetDatos=fx_corte_status_canton(canton)
  
  renderLeaflet({
    pWalk=paste0("./PIES.png")
    pBike=paste0("./bike.png")
    pCar=paste0("./car.png")
    pImagen = switch(medio, "walk" = list(iconUrl=pWalk,iconSize=c(15,15)), "bike" = list(iconUrl=pBike,iconSize=c(25,25)), "drive" = list(iconUrl=pCar,iconSize=c(15,15)))
    datosWS = switch(medio, "walk" = SetDatos$mapa_ws_walk, "bike" = SetDatos$mapa_ws_bike, "drive" = SetDatos$mapa_ws_drive)
    
    json_file.p <- fromJSON(datosWS, flatten=TRUE)
    
    a=names(json_file.p$response$data[1][1])
    b=as.numeric(sapply(strsplit(as.character(a), ","), unlist))
    
    pLat0=b[1]
    pLon0=b[2]
    
    nombreJSon=paste0("`",pLat0,",",pLon0,"`")
    
    jSonLat=eval(parse(text=paste0("json_file.p$response$data$",nombreJSon,"[,1]")))
    jSonLon=eval(parse(text=paste0("json_file.p$response$data$",nombreJSon,"[,2]")))
    jSonFil=eval(parse(text=paste0("json_file.p$response$data$",nombreJSon,"[,3]")))
    
    WalkScore=data.frame(jSonLat,jSonLon,jSonFil)
    WS=WalkScore[WalkScore$jSonFil<=segundos,]
    
    leaflet(data = WS) %>% 
      
      addTiles() %>%
      
      setView(pLon0,pLat0,14)  %>%
      
      # addPolygons(fillColor = topo.colors(5, alpha = NULL), stroke = FALSE) %>% 
      
      addMarkers(lng=WS$jSonLon, 
                 lat=WS$jSonLat, 
                 icon = pImagen) %>%
      
      addMarkers(lng=pLon0,
                 lat=pLat0,
                 icon = list(iconUrl=pImagen,iconSize=c(15,15)),
                 label = "Punto Inicial",
                 labelOptions = labelOptions(noHide = T))
      
  }) 
}