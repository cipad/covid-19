
#prueba
options(shiny.jquery.version=1)
library(shiny)
library(gentelellaShiny)
library(shinyWidgets)
library(dygraphs)
library(leaflet)
library(xts)
library(bsplus)
library(ggplot2)

# Incluye todos los archivos con el prefijo server para que esten disponibles al renderizar el app
file.sources = list.files(pattern = "server_.+\\.R")
sapply(file.sources, source)

source("bd_covid19.R")

# LECTURA DATOS ---- 
estatus_pais = fx_corte_status_pais()

covidServer = function(input, output, session) {

  output$profile <- renderUI({
    tagList(
      tags$div(
        class = "profile clearfix",
        tags$div(
          class = "profile_info",
          style = "padding-left: 23px",
          tags$span("Bienvenido al"),
          tags$h2("CIPAD")
        )
      ),
      br()
    )
  })
  
  output$graficoLineaAcumulada <- graficoLineaAcumulada
  
  output$mapaContagiosPais <- mapaContagiosPais
  
  output$positivos_genero <- pie_positivos_genero

  output$positivos_edad <- pie_positivos_edad
  
  output$positivos_nacionalidad <- pie_positivos_nacionalidad
  
  output$recuperados_genero <- pie_recuperados_genero
  
  output$recuperados_edad <- pie_recuperados_edad
  
  output$hospitalizados_nivel <- pie_hospitalizados_nivel
  
  output$fallecidos_genero <- pie_fallecidos_genero
  
  output$positivos_nuevos_serie <- positivos_nuevos_serie
  
  output$recuperados_nuevos_serie <- recuperados_nuevos_serie
  
  output$hospitalizados_nuevos_serie <- hospitalizados_nuevos_serie
  
  output$fallecidos_nuevos_serie <- fallecidos_nuevos_serie
  
  observeEvent(input$fechaCorteCanton, {
    
    if (length(input$fechaCorteCanton) > 0){
      updateSelectizeInput(
        session, "seleccionCanton",
        'Cantón:',
        choices = fx_cantones_covid(format(input$fechaCorteCanton, "%Y-%m-%d"))
      )
    }
  })
}