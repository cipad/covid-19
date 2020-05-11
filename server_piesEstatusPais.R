library(ggplot2)

source("bd_covid19.R")
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
    group = c(paste(i18n$t("Masculino:"),estatus_pais$positivos_masculino), paste(i18n$t("Femenino:"),estatus_pais$positivos_femenino)),
    value = c(estatus_pais$positivos_masculino, estatus_pais$positivos_femenino)
  )
  
  bp <- ggplot(dfPositivosGenero, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  pie <- bp + coord_polar("y", start=0)
  pieGenero = pie + scale_fill_brewer(i18n$t("Género")) + blank_theme +
    theme(axis.text.x=element_blank())
  pieGenero
})

pie_positivos_edad <- renderPlot({
  
  dfPositivosEdad <- data.frame(
    group = c(paste(i18n$t("Adultos Mayores:"),estatus_pais$positivos_adultos), paste(i18n$t("Adultos:"),estatus_pais$positivos_adulto_mayor), paste(i18n$t("Menores de Edad:"),estatus_pais$positivos_menor)),
    value = c(estatus_pais$positivos_adultos, estatus_pais$positivos_adulto_mayor, estatus_pais$positivos_menor)
  )
  
  bp <- ggplot(dfPositivosEdad, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  bp
  pie <- bp + coord_polar("y", start=0)
  pieEdad = pie + scale_fill_brewer(i18n$t("Grupo de Edad")) + blank_theme +
    theme(axis.text.x=element_blank())
  pieEdad
})

pie_positivos_nacionalidad <- renderPlot({
  
  dfPositivosNacionalidad <- data.frame(
    group = c(paste(i18n$t("Local:"),estatus_pais$positivos_local), paste(i18n$t("Extranjero:"),estatus_pais$positivos_extranjero), paste(i18n$t("En Investigación:"),estatus_pais$positivos_investigacion)),
    value = c(estatus_pais$positivos_local, estatus_pais$positivos_extranjero, estatus_pais$positivos_investigacion)
  )
  
  bp <- ggplot(dfPositivosNacionalidad, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  bp
  pie <- bp + coord_polar("y", start=0)
  pieNacionalidad = pie + scale_fill_brewer(i18n$t("Nacionalidad")) + blank_theme +
    theme(axis.text.x=element_blank())
  pieNacionalidad
})

pie_recuperados_genero <- renderPlot({
  
  dfRecuperadosGenero <- data.frame(
    group = c(paste(i18n$t("Masculino:"),estatus_pais$recuperados_masculino), paste(i18n$t("Femenino:"),estatus_pais$recuperados_femenino)),
    value = c(estatus_pais$recuperados_masculino, estatus_pais$recuperados_femenino)
  )
  
  bp <- ggplot(dfRecuperadosGenero, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  pie <- bp + coord_polar("y", start=0)
  pieGenero = pie + scale_fill_brewer(i18n$t("Género")) + blank_theme +
    theme(axis.text.x=element_blank())
  pieGenero
})

pie_recuperados_edad <- renderPlot({
  
  dfRecuperadosEdad <- data.frame(
    group = c(paste(i18n$t("Adultos Mayores:"),estatus_pais$recuperados_adulto_mayor), paste(i18n$t("Adultos:"),estatus_pais$recuperados_adulto), paste(i18n$t("Menores de Edad:"),estatus_pais$recuperados_menor)),
    value = c(estatus_pais$recuperados_adulto_mayor, estatus_pais$recuperados_adulto, estatus_pais$recuperados_menor)
  )
  
  bp <- ggplot(dfRecuperadosEdad, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  bp
  pie <- bp + coord_polar("y", start=0)
  pieEdad = pie + scale_fill_brewer(i18n$t("Grupo de Edad")) + blank_theme +
    theme(axis.text.x=element_blank())
  pieEdad
})

pie_activos_genero <- renderPlot({
  
  dfActivosGenero <- data.frame(
    group = c(paste(i18n$t("Masculino:"),estatus_pais$recuperados_masculino), paste(i18n$t("Femenino:"),estatus_pais$recuperados_femenino)),
    value = c(estatus_pais$positivos_masculino - (estatus_pais$recuperados_masculino + estatus_pais$fallecidos_masculino), estatus_pais$positivos_femenino - (estatus_pais$recuperados_femenino + estatus_pais$fallecidos_femenino))
  )
  
  bp <- ggplot(dfActivosGenero, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  pie <- bp + coord_polar("y", start=0)
  pieActivosGenero = pie + scale_fill_brewer(i18n$t("Género")) + blank_theme +
    theme(axis.text.x=element_blank())
  pieActivosGenero
})

pie_hospitalizados_nivel <- renderPlot({
  
  dfHospitazalidosNivel <- data.frame(
    group = c(paste(i18n$t("Salón:"),estatus_pais$salon), paste(i18n$t("UCI:"),estatus_pais$uci)),
    value = c(estatus_pais$salon, estatus_pais$uci)
  )
  
  bp <- ggplot(dfHospitazalidosNivel, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  bp
  pie <- bp + coord_polar("y", start=0)
  pieNivel = pie + scale_fill_brewer(i18n$t("Sección")) + blank_theme +
    theme(axis.text.x=element_blank())
  pieNivel
})

pie_fallecidos_genero <- renderPlot({
  
  dfFallecidosGenero <- data.frame(
    group = c(paste(i18n$t("Masculino:"),estatus_pais$fallecidos_masculino), paste(i18n$t("Femenino:"),estatus_pais$fallecidos_femenino)),
    value = c(estatus_pais$fallecidos_masculino, estatus_pais$fallecidos_femenino)
  )
  
  bp <- ggplot(dfFallecidosGenero, aes(x="", y=value, fill=group))+
    geom_bar(width = 1, stat = "identity")
  bp
  pie <- bp + coord_polar("y", start=0)
  pieGenero = pie + scale_fill_brewer(i18n$t("Género")) + blank_theme +
    theme(axis.text.x=element_blank())
  pieGenero
}) 