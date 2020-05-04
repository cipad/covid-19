source("bd_covid19.R")

positivos_nuevos_serie <- renderDygraph({
  dataPositivos = fx_historico_variable_pais("positivos_nuevos")
  
  dataPositivos <- xts(x = dataPositivos$positivos_nuevos, order.by = dataPositivos$fecha)
  dyOptions(dygraph(dataPositivos), stepPlot=TRUE, fillGraph=TRUE)
})

recuperados_nuevos_serie <- renderDygraph({
  dataRecuperados = fx_historico_variable_pais("recuperados_nuevos")
  
  dataRecuperados <- xts(x = dataRecuperados$recuperados_nuevos, order.by = dataRecuperados$fecha)
  dyOptions(dygraph(dataRecuperados), stepPlot=TRUE, fillGraph=TRUE)
})

hospitalizados_nuevos_serie <- renderDygraph({
  
  dataHospitalizados = fx_historico_variable_pais("hospitalizados_nuevos")
  
  dataHospitalizados <- xts(x = dataHospitalizados$hospitalizados_nuevos, order.by = dataHospitalizados$fecha)
  dyOptions(dygraph(dataHospitalizados), stepPlot=TRUE, fillGraph=TRUE)
})

fallecidos_nuevos_serie <- renderDygraph({
  
  dataFallecidos = fx_historico_variable_pais("fallecidos_nuevos")
  
  dataFallecidos <- xts(x = dataFallecidos$fallecidos_nuevos, order.by = dataFallecidos$fecha)
  dyOptions(dygraph(dataFallecidos), stepPlot=TRUE, fillGraph=TRUE)
})