
#prueba
options(shiny.jquery.version=1)
library(shiny)
library(gentelellaShiny)
library(shinyWidgets)
library(bsplus)
library(mapdeck)

# Incluye todos los archivos con el prefijo server para que esten disponibles al renderizar el app
file.sources = list.files(pattern = "server_.+\\.R")
sapply(file.sources, source)

source("bd_covid19.R")

# LECTURA DATOS ---- 
estatus_pais = fx_corte_status_pais()

server = shinyServer(function(input, output, session) {
  
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
  
  estatus_canton_positivos <- reactiveVal("-") 
  estatus_canton_recuperados <- reactiveVal("-")
  estatus_canton_fallecidos <- reactiveVal("-") 
  
  observeEvent(input$fechaCorteCanton, {
    
    if (length(input$fechaCorteCanton) > 0){
      cantones = fx_cantones_covid(format(input$fechaCorteCanton, "%Y-%m-%d"))
      updateSelectizeInput(
        session, "seleccionCanton",
        'Cantón:',
        choices = cantones
      )
      if (length(cantones) > 0){
        estado_canton = fx_corte_status_canton(cantones[1], format(input$fechaCorteCanton, "%Y-%m-%d"))
        estatus_canton_positivos(estado_canton$positivos)
        estatus_canton_recuperados(estado_canton$recuperados)
        estatus_canton_fallecidos(estado_canton$fallecidos)
        
        SetDatos = fx_movilidad_canton_mapa(cantones[1], format(input$fechaCorteCanton, "%Y-%m-%d"))
        if (nrow(SetDatos) > 0){
          
          SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
          
          mapaMovilidadCantonReduccion = mapdeck( style = mapdeck_style("dark"), pitch = 45 ) %>%
            add_arc(
              data = SetDatos
              , layer_id = "arc_layer"
              , origin =  c("longitud_origen", "latitud_origen")
              , destination =  c("longitud_destino", "latitud_destino")
              , stroke_from = "canton_origen"
              , stroke_to =   "canton_destino"
              , stroke_width = "z_score_baja"
              , tooltip = "Info"
              , palette = "magma"
              , auto_highlight = TRUE
              , highlight_colour = "#AAFFFFFF")
          
          output$mapaMovilidadCantonReduccion = renderMapdeck({
            mapaMovilidadCantonReduccion
          })
          
          SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
          
          mapaMovilidadCantonIncremento = mapdeck( style = mapdeck_style("dark"), pitch = 45 ) %>%
            add_arc(
              data = SetDatos
              , layer_id = "arc_layer"
              , origin =  c("longitud_origen", "latitud_origen")
              , destination =  c("longitud_destino", "latitud_destino")
              , stroke_from = "canton_origen"
              , stroke_to =   "canton_destino"
              , stroke_width = "z_score_sube"
              , tooltip = "Info"
              , palette = "magma"
              , auto_highlight = TRUE
              , highlight_colour = "#AAFFFFFF")
          
          output$mapaMovilidadCantonIncremento = renderMapdeck({
            mapaMovilidadCantonIncremento
          }) 
        }
      }
      else {
        estatus_canton_positivos("-")
        estatus_canton_recuperados("-")
        estatus_canton_fallecidos("-")
      }
    }
    else {
      estatus_canton_positivos("-")
      estatus_canton_recuperados("-")
      estatus_canton_fallecidos("-")
    }
    
    output$estatus_canton_positivos = renderText({ estatus_canton_positivos() })
    output$estatus_canton_recuperados = renderText({ estatus_canton_recuperados() })
    output$estatus_canton_fallecidos = renderText({ estatus_canton_fallecidos() })
    
  })
  
  key="pk.eyJ1IjoibWlub3Jib25pbGxhZ29tZXoiLCJhIjoiY2s5cGF4dzN4MDk2MjNkb2RxbjNrcDZ2aiJ9.fSjAKiPHJyCbtkD6u7hRvA"
  set_token(key)
  
  observeEvent(input$seleccionCanton, {
    if (nchar(input$seleccionCanton) > 0){
      estado_canton = fx_corte_status_canton(input$seleccionCanton, format(input$fechaCorteCanton, "%Y-%m-%d"))
      estatus_canton_positivos(estado_canton$positivos)
      estatus_canton_recuperados(estado_canton$recuperados)
      estatus_canton_fallecidos(estado_canton$fallecidos)
      
      output$estatus_canton_positivos = renderText({ estatus_canton_positivos() })
      output$estatus_canton_recuperados = renderText({ estatus_canton_recuperados() })
      output$estatus_canton_fallecidos = renderText({ estatus_canton_fallecidos() })
      
      SetDatos = fx_movilidad_canton_mapa(input$seleccionCanton, format(input$fechaCorteCanton, "%Y-%m-%d"))
      
      if (nrow(SetDatos) > 0){
        SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
        
        mapaMovilidadCantonReduccion = mapdeck( style = mapdeck_style("dark"), pitch = 45 ) %>%
          add_arc(
            data = SetDatos
            , layer_id = "arc_layer"
            , origin =  c("longitud_origen", "latitud_origen")
            , destination =  c("longitud_destino", "latitud_destino")
            , stroke_from = "canton_origen"
            , stroke_to =   "canton_destino"
            , stroke_width = "z_score_baja"
            , tooltip = "Info"
            , palette = "magma"
            , auto_highlight = TRUE
            , highlight_colour = "#AAFFFFFF")
        
        output$mapaMovilidadCantonReduccion = renderMapdeck({
          mapaMovilidadCantonReduccion
        }) 
        
        SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
        
        mapaMovilidadCantonIncremento = mapdeck( style = mapdeck_style("dark"), pitch = 45 ) %>%
          add_arc(
            data = SetDatos
            , layer_id = "arc_layer"
            , origin =  c("longitud_origen", "latitud_origen")
            , destination =  c("longitud_destino", "latitud_destino")
            , stroke_from = "canton_origen"
            , stroke_to =   "canton_destino"
            , stroke_width = "z_score_sube"
            , tooltip = "Info"
            , palette = "magma"
            , auto_highlight = TRUE
            , highlight_colour = "#AAFFFFFF")
        
        output$mapaMovilidadCantonIncremento = renderMapdeck({
          mapaMovilidadCantonIncremento
        }) 
      }
    }
  })
})