library(xts)
library(dygraphs)

source("bd_covid19.R")
estatus_pais_acumulado = fx_corte_status_pais_acumulado()

positivos <- xts(x = estatus_pais_acumulado$positivos, order.by = estatus_pais_acumulado$fecha)
recuperados <- xts(x = estatus_pais_acumulado$recuperados, order.by = estatus_pais_acumulado$fecha)
activos <- xts(x = estatus_pais_acumulado$positivos - (estatus_pais_acumulado$recuperados + estatus_pais_acumulado$fallecidos), order.by = estatus_pais_acumulado$fecha)
lineas <- cbind(positivos, recuperados, activos)

graficoLineaAcumulada = renderDygraph({
  dygraph(lineas) %>%
    dyOptions( fillGraph=TRUE ) %>%
    dyLegend(width = 400)
})