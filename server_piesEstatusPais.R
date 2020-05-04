estatus_pais = fx_corte_status_pais()

blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

pie_positivos_genero <- renderPlot({
  
  dfPositivosGenero <- data.frame(
    group = c(paste("Masculino:",estatus_pais$positivos_masculino), paste("Femenino:",estatus_pais$positivos_femenino)),
    value = c(estatus_pais$positivos_masculino, estatus_pais$positivos_femenino)
  )
  
  bp <- ggplot(dfPositivosGenero, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  pie <- bp + coord_polar("y", start=0)
  pieGenero = pie + scale_fill_brewer("Género") + blank_theme +
    theme(axis.text.x=element_blank())
  pieGenero
})

pie_positivos_edad <- renderPlot({
  
  dfPositivosEdad <- data.frame(
    group = c(paste("Adultos Mayores:",estatus_pais$positivos_adultos), paste("Adultos:",estatus_pais$positivos_adulto_mayor), paste("Menores de Edad:",estatus_pais$positivos_menor)),
    value = c(estatus_pais$positivos_adultos, estatus_pais$positivos_adulto_mayor, estatus_pais$positivos_menor)
  )
  
  bp <- ggplot(dfPositivosEdad, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  bp
  pie <- bp + coord_polar("y", start=0)
  pieEdad = pie + scale_fill_brewer("Grupo de Edad") + blank_theme +
    theme(axis.text.x=element_blank())
  pieEdad
})

pie_positivos_nacionalidad <- renderPlot({
  
  dfPositivosNacionalidad <- data.frame(
    group = c(paste("Local:",estatus_pais$positivos_local), paste("Extranjero:",estatus_pais$positivos_extranjero), paste("En Investigación:",estatus_pais$positivos_investigacion)),
    value = c(estatus_pais$positivos_local, estatus_pais$positivos_extranjero, estatus_pais$positivos_investigacion)
  )
  
  bp <- ggplot(dfPositivosNacionalidad, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  bp
  pie <- bp + coord_polar("y", start=0)
  pieNacionalidad = pie + scale_fill_brewer("Grupo de Edad") + blank_theme +
    theme(axis.text.x=element_blank())
  pieNacionalidad
})

pie_recuperados_genero <- renderPlot({
  
  dfRecuperadosGenero <- data.frame(
    group = c(paste("Masculino:",estatus_pais$recuperados_masculino), paste("Femenino:",estatus_pais$recuperados_femenino)),
    value = c(estatus_pais$recuperados_masculino, estatus_pais$recuperados_femenino)
  )
  
  bp <- ggplot(dfRecuperadosGenero, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  pie <- bp + coord_polar("y", start=0)
  pieGenero = pie + scale_fill_brewer("Género") + blank_theme +
    theme(axis.text.x=element_blank())
  pieGenero
})

pie_recuperados_edad <- renderPlot({
  
  dfRecuperadosEdad <- data.frame(
    group = c(paste("Adultos Mayores:",estatus_pais$recuperados_adulto_mayor), paste("Adultos:",estatus_pais$recuperados_adulto), paste("Menores de Edad:",estatus_pais$recuperados_menor)),
    value = c(estatus_pais$recuperados_adulto_mayor, estatus_pais$recuperados_adulto, estatus_pais$recuperados_menor)
  )
  
  bp <- ggplot(dfRecuperadosEdad, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  bp
  pie <- bp + coord_polar("y", start=0)
  pieEdad = pie + scale_fill_brewer("Grupo de Edad") + blank_theme +
    theme(axis.text.x=element_blank())
  pieEdad
})

pie_hospitalizados_nivel <- renderPlot({
  
  dfHospitazalidosNivel <- data.frame(
    group = c(paste("Salón:",estatus_pais$salon), paste("UCI:",estatus_pais$uci)),
    value = c(estatus_pais$salon, estatus_pais$uci)
  )
  
  bp <- ggplot(dfHospitazalidosNivel, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  bp
  pie <- bp + coord_polar("y", start=0)
  pieNivel = pie + scale_fill_brewer("Sección") + blank_theme +
    theme(axis.text.x=element_blank())
  pieNivel
})

pie_fallecidos_genero <- renderPlot({
  
  dfFallecidosGenero <- data.frame(
    group = c(paste("Masculino:",estatus_pais$fallecidos_masculino), paste("Femenino:",estatus_pais$fallecidos_femenino)),
    value = c(estatus_pais$fallecidos_masculino, estatus_pais$fallecidos_femenino)
  )
  
  bp <- ggplot(dfFallecidosGenero, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  bp
  pie <- bp + coord_polar("y", start=0)
  pieGenero = pie + scale_fill_brewer("Sección") + blank_theme +
    theme(axis.text.x=element_blank())
  pieGenero
}) 