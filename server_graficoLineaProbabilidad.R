library(xts)
library(dygraphs)

graficoLineaProbabilidad = function(datos){
  positivos <- xts(x = datos$probabilidad, order.by = datos$fecha)
  lineas <- cbind(positivos)
  
  graficoLineaAcumulada = renderDygraph({
    dygraph(lineas) %>%
      dyOptions( fillGraph=TRUE, stepPlot=TRUE ) %>%
      dyLegend(width = 400)
  })
}