
#prueba
options(shiny.jquery.version=1)
library(shiny)
library(gentelellaShiny)
library(shinyWidgets)
library(bsplus)
library(mapdeck)
library(dplyr)
library(shiny.i18n)

i18n <- Translator$new(translation_json_path = "./www/translations.json")
i18n$set_translation_language("es")

# Incluye todos los archivos con el prefijo server para que esten disponibles al renderizar el app
file.sources = list.files(pattern = "server_.+\\.R")
sapply(file.sources, source)

source("bd_covid19.R")

# LECTURA DATOS ---- 
estatus_pais = fx_corte_status_pais()

key="pk.eyJ1IjoibWlub3Jib25pbGxhZ29tZXoiLCJhIjoiY2s5cGF4dzN4MDk2MjNkb2RxbjNrcDZ2aiJ9.fSjAKiPHJyCbtkD6u7hRvA"
set_token(key)

server = shinyServer(function(input, output, session) {
  
  output$profile <- renderUI({
    tagList(
      tags$div(
        class = "profile clearfix",
        tags$div(
          class = "profile_info",
          style = "padding-left: 23px",
          tags$span(i18n$t("Bienvenido al")),
          tags$h2("CIPAD")
        )
      ),
      br()
    )
  })
  
  output$graficoLineaAcumulada <- graficoLineaAcumulada
  
  output$mapaContagiosPais <- mapaContagiosPais
  
  output$mapaTimeline <- mapaTimeline
  
  output$mapaCasosCanton <- mapaCasosCanton
  
  output$positivos_genero <- pie_positivos_genero
  
  output$positivos_edad <- pie_positivos_edad
  
  output$positivos_nacionalidad <- pie_positivos_nacionalidad
  
  output$recuperados_genero <- pie_recuperados_genero
  
  output$recuperados_edad <- pie_recuperados_edad
  
  output$activos_genero <- pie_activos_genero
  
  output$hospitalizados_nivel <- pie_hospitalizados_nivel
  
  output$fallecidos_genero <- pie_fallecidos_genero
  
  output$positivos_nuevos_serie <- positivos_nuevos_serie
  
  output$recuperados_nuevos_serie <- recuperados_nuevos_serie
  
  output$hospitalizados_nuevos_serie <- hospitalizados_nuevos_serie
  
  output$fallecidos_nuevos_serie <- fallecidos_nuevos_serie
  
  estatus_canton_positivos <- reactiveVal("-") 
  estatus_canton_recuperados <- reactiveVal("-")
  estatus_canton_fallecidos <- reactiveVal("-") 
  
  indicador_poblacion <- reactiveVal("-")
  indicador_densidad_poblacional <- reactiveVal("-")
  indicador_tasa_densidad_contagio <- reactiveVal("-")
  indicador_tasa_contagio <- reactiveVal("-")
  indicador_extension <- reactiveVal("-")
  indicador_tasa_mortalidad <- reactiveVal("-")
  indicador_tasa_natalidad <- reactiveVal("-")
  indicador_tasa_nupcialidad <- reactiveVal("-")
  indicador_ids_2017 <- reactiveVal("-")
  indicador_matricula <- reactiveVal("-")
  indicador_ws_min <- reactiveVal("-")
  indicador_ws_avg <- reactiveVal("-")
  indicador_ws_max <- reactiveVal("-")
  
  observeEvent(input$fechaCorteCanton, {
    
    if (length(input$fechaCorteCanton) > 0){
      cantones = fx_cantones_covid(format(input$fechaCorteCanton, "%Y-%m-%d"))
      updateSelectizeInput(
        session, "seleccionCanton",
        i18n$t("Cantón:"),
        choices = cantones
      )
      if (length(cantones) > 0){
        estado_canton = fx_corte_status_canton(cantones[1], format(input$fechaCorteCanton, "%Y-%m-%d"))
        estatus_canton_positivos(estado_canton$positivos)
        estatus_canton_recuperados(estado_canton$recuperados)
        estatus_canton_fallecidos(estado_canton$fallecidos)
        
        indicador_poblacion(estado_canton$poblacion)
        indicador_densidad_poblacional(estado_canton$densidad_poblacional)
        indicador_tasa_densidad_contagio(ifelse(estado_canton$tasa_densidad_contagio < 0.1, "< 0.1" , estado_canton$tasa_densidad_contagio))
        indicador_tasa_contagio(estado_canton$tasa_contagio)
        indicador_extension(estado_canton$extension)
        indicador_tasa_mortalidad(estado_canton$tasa_mortalidad)
        indicador_tasa_natalidad(estado_canton$tasa_natalidad)
        indicador_tasa_nupcialidad(estado_canton$tasa_nupcialidad)
        indicador_ids_2017(estado_canton$ids_2017)
        indicador_matricula(estado_canton$matricula)
        indicador_ws_min(estado_canton$ws_min)
        indicador_ws_avg(estado_canton$ws_avg)
        indicador_ws_max(estado_canton$ws_max)
        
        SetDatos = fx_movilidad_canton_mapa(cantones[1], input$intensidadMovilidad, format(input$fechaCorteMovilidadCanton, "%Y-%m-%d"), input$horaMovilidad)
        
        if (nrow(SetDatos) > 0){
          
          SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
          
          mapaMovilidadCantonReduccion = mapaMovilidadCanton(SetDatos, "z_score_baja")
          
          output$mapaMovilidadCantonReduccion = renderMapdeck({
            mapaMovilidadCantonReduccion
          })
          
          SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
          
          mapaMovilidadCantonIncremento = mapaMovilidadCanton(SetDatos, "z_score_sube")
          
          output$mapaMovilidadCantonIncremento = renderMapdeck({
            mapaMovilidadCantonIncremento
          }) 
        }
        
        output$mapaWS <- mapaWS(cantones[1], input$minutosWS * 60, input$medioWS)
      }
      else {
        estatus_canton_positivos("-")
        estatus_canton_recuperados("-")
        estatus_canton_fallecidos("-")
        indicador_poblacion("-")
        indicador_densidad_poblacional("-")
        indicador_tasa_densidad_contagio("-")
        indicador_tasa_contagio("-")
        indicador_extension("-")
        indicador_tasa_mortalidad("-")
        indicador_tasa_natalidad("-")
        indicador_tasa_nupcialidad("-")
        indicador_ids_2017("-")
        indicador_matricula("-")
        indicador_ws_min("-")
        indicador_ws_avg("-")
        indicador_ws_max("-")
      }
    }
    else {
      estatus_canton_positivos("-")
      estatus_canton_recuperados("-")
      estatus_canton_fallecidos("-")
      indicador_poblacion("-")
      indicador_densidad_poblacional("-")
      indicador_tasa_densidad_contagio("-")
      indicador_tasa_contagio("-")
      indicador_extension("-")
      indicador_tasa_mortalidad("-")
      indicador_tasa_natalidad("-")
      indicador_tasa_nupcialidad("-")
      indicador_ids_2017("-")
      indicador_matricula("-")
      indicador_ws_min("-")
      indicador_ws_avg("-")
      indicador_ws_max("-")
    }
    
    output$estatus_canton_positivos = renderText({ estatus_canton_positivos() })
    output$estatus_canton_recuperados = renderText({ estatus_canton_recuperados() })
    output$estatus_canton_fallecidos = renderText({ estatus_canton_fallecidos() })
    
    output$indicador_poblacion = renderText({ indicador_poblacion() })
    output$indicador_densidad_poblacional = renderText({ indicador_densidad_poblacional() })
    output$indicador_tasa_densidad_contagio = renderText({ indicador_tasa_densidad_contagio() })
    output$indicador_tasa_contagio = renderText({ indicador_tasa_contagio() })
    output$indicador_extension = renderText({ indicador_extension() })
    output$indicador_tasa_mortalidad = renderText({ indicador_tasa_mortalidad() })
    output$indicador_tasa_natalidad = renderText({ indicador_tasa_natalidad() })
    output$indicador_tasa_nupcialidad = renderText({ indicador_tasa_nupcialidad() })
    output$indicador_ids_2017 = renderText({ indicador_ids_2017() })
    output$indicador_matricula = renderText({ indicador_matricula() })
    output$indicador_ws_min = renderText({ indicador_ws_min() })
    output$indicador_ws_avg = renderText({ indicador_ws_avg() })
    output$indicador_ws_max = renderText({ indicador_ws_max() })
    
  })
  
  observeEvent(input$seleccionCanton, {
    if (nchar(input$seleccionCanton) > 0){
      estado_canton = fx_corte_status_canton(input$seleccionCanton, format(input$fechaCorteCanton, "%Y-%m-%d"))
      estatus_canton_positivos(estado_canton$positivos)
      estatus_canton_recuperados(estado_canton$recuperados)
      estatus_canton_fallecidos(estado_canton$fallecidos)
      
      indicador_poblacion(estado_canton$poblacion)
      indicador_densidad_poblacional(estado_canton$densidad_poblacional)
      indicador_tasa_densidad_contagio(ifelse(estado_canton$tasa_densidad_contagio < 0.1, "< 0.1" , estado_canton$tasa_densidad_contagio))
      indicador_tasa_contagio(estado_canton$tasa_contagio)
      indicador_extension(estado_canton$extension)
      indicador_tasa_mortalidad(estado_canton$tasa_mortalidad)
      indicador_tasa_natalidad(estado_canton$tasa_natalidad)
      indicador_tasa_nupcialidad(estado_canton$tasa_nupcialidad)
      indicador_ids_2017(estado_canton$ids_2017)
      indicador_matricula(estado_canton$matricula)
      indicador_ws_min(estado_canton$ws_min)
      indicador_ws_avg(estado_canton$ws_avg)
      indicador_ws_max(estado_canton$ws_max)
      
      output$estatus_canton_positivos = renderText({ estatus_canton_positivos() })
      output$estatus_canton_recuperados = renderText({ estatus_canton_recuperados() })
      output$estatus_canton_fallecidos = renderText({ estatus_canton_fallecidos() })
      
      output$indicador_poblacion = renderText({ indicador_poblacion() })
      output$indicador_densidad_poblacional = renderText({ indicador_densidad_poblacional() })
      output$indicador_tasa_densidad_contagio = renderText({ indicador_tasa_densidad_contagio() })
      output$indicador_tasa_contagio = renderText({ indicador_tasa_contagio() })
      output$indicador_extension = renderText({ indicador_extension() })
      output$indicador_tasa_mortalidad = renderText({ indicador_tasa_mortalidad() })
      output$indicador_tasa_natalidad = renderText({ indicador_tasa_natalidad() })
      output$indicador_tasa_nupcialidad = renderText({ indicador_tasa_nupcialidad() })
      output$indicador_ids_2017 = renderText({ indicador_ids_2017() })
      output$indicador_matricula = renderText({ indicador_matricula() })
      output$indicador_ws_min = renderText({ indicador_ws_min() })
      output$indicador_ws_avg = renderText({ indicador_ws_avg() })
      output$indicador_ws_max = renderText({ indicador_ws_max() })
      
      SetDatos = fx_movilidad_canton_mapa(input$seleccionCanton, input$intensidadMovilidad, format(input$fechaCorteMovilidadCanton, "%Y-%m-%d"), input$horaMovilidad)
      
      if (nrow(SetDatos) > 0){
        SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
        
        mapaMovilidadCantonReduccion = mapaMovilidadCanton(SetDatos, "z_score_baja")
        
        output$mapaMovilidadCantonReduccion = renderMapdeck({
          mapaMovilidadCantonReduccion
        }) 
        
        SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
        
        mapaMovilidadCantonIncremento = mapaMovilidadCanton(SetDatos, "z_score_sube")
        
        output$mapaMovilidadCantonIncremento = renderMapdeck({
          mapaMovilidadCantonIncremento
        }) 
      }
      
      output$mapaWS <- mapaWS(input$seleccionCanton, input$minutosWS * 60, input$medioWS)
      
      SetDatosProbabilidad = fx_canton_riesgo(input$seleccionCanton)
      
      if (nrow(SetDatosProbabilidad) > 0){
        output$graficoLineaProbabilidad <- graficoLineaProbabilidad(SetDatosProbabilidad)
        
        if (SetDatosProbabilidad$excluir[1] == FALSE){
          output$labelAlertaProbabilidad <- renderUI({
            tags$p(i18n$t(""))
          })
        }
        else {
          output$labelAlertaProbabilidad <- renderUI({
            tags$p(i18n$t("*Este cantón no cuenta con datos suficientes para un cálculo preciso de probabilidades"), style="font-size: 16px; color: #f44336; text-align: center;")
          })
        }
      }
    }
  })
  
  observeEvent(input$fechaCorteMovilidadCanton, {
    SetDatos = fx_movilidad_canton_mapa(input$seleccionCanton, input$intensidadMovilidad, format(input$fechaCorteMovilidadCanton, "%Y-%m-%d"), input$horaMovilidad)
    
    if (nrow(SetDatos) > 0){
      
      SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
      
      mapaMovilidadCantonReduccion = mapaMovilidadCanton(SetDatos, "z_score_baja")
      
      output$mapaMovilidadCantonReduccion = renderMapdeck({
        mapaMovilidadCantonReduccion
      })
      
      SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
      
      mapaMovilidadCantonIncremento = mapaMovilidadCanton(SetDatos, "z_score_sube")
      
      output$mapaMovilidadCantonIncremento = renderMapdeck({
        mapaMovilidadCantonIncremento
      }) 
    }
  })
  
  observeEvent(input$intensidadMovilidad, {
    SetDatos = fx_movilidad_canton_mapa(input$seleccionCanton, input$intensidadMovilidad, format(input$fechaCorteMovilidadCanton, "%Y-%m-%d"), input$horaMovilidad)
    
    if (nrow(SetDatos) > 0){
      
      SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
      
      mapaMovilidadCantonReduccion = mapaMovilidadCanton(SetDatos, "z_score_baja")
      
      output$mapaMovilidadCantonReduccion = renderMapdeck({
        mapaMovilidadCantonReduccion
      })
      
      SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
      
      mapaMovilidadCantonIncremento = mapaMovilidadCanton(SetDatos, "z_score_sube")
      
      output$mapaMovilidadCantonIncremento = renderMapdeck({
        mapaMovilidadCantonIncremento
      }) 
    }
  })
  
  observeEvent(input$horaMovilidad, {
    SetDatos = fx_movilidad_canton_mapa(input$seleccionCanton, input$intensidadMovilidad, format(input$fechaCorteMovilidadCanton, "%Y-%m-%d"), input$horaMovilidad)
    
    if (nrow(SetDatos) > 0){
      
      SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
      
      mapaMovilidadCantonReduccion = mapaMovilidadCanton(SetDatos, "z_score_baja")
      
      output$mapaMovilidadCantonReduccion = renderMapdeck({
        mapaMovilidadCantonReduccion
      })
      
      SetDatos$Info=paste("<b>", SetDatos$canton_origen, " - " , SetDatos$canton_destino,round(SetDatos$z_score,1),"</b>" )
      
      mapaMovilidadCantonIncremento = mapaMovilidadCanton(SetDatos, "z_score_sube")
      
      output$mapaMovilidadCantonIncremento = renderMapdeck({
        mapaMovilidadCantonIncremento
      }) 
    }
  })
  
  observeEvent(input$minutosWS, {
    if(nchar(input$seleccionCanton) > 0){
      output$mapaWS <- mapaWS(input$seleccionCanton, input$minutosWS * 60, input$medioWS)
    }
  })
  
  observeEvent(input$medioWS, {
    if(nchar(input$seleccionCanton) > 0){
      output$mapaWS <- mapaWS(input$seleccionCanton, input$minutosWS * 60, input$medioWS)
    }
  })
  
  
  observeEvent(input$abrirInfoMovilidad, {
    showModal(modalDialog(
      title = "Movilidad Humana",
      div(
        tags$p("En esta sección se presentan los gráficos de movilidad humana separados por el criterio REDUCCIÓN e INCREMENTO, haciendo cada uno de ellos 
  referencia al patrón de comportamiento observado en la muestra de la población analizada (cerca de 230mil personas en cada bloque)."), 
        tags$p("Los datos miden el movimiento humano contabilizandolo como aquel que supera los 600 metros, asignando al individuo en funcion a su permanencia en 
  el mismo. Esta medida mejora el sesgo observado en datos provenientes de plataformas de movilidad vehicular, que tienen una menor
  representatividad, dada la naturaleza propia el grupo observada, que excluye a quienes no tienen vehiculo."), 
        tags$p("Con cortes de 8 horas, puede además realizarse con mayor precisión el contraste entre roles disimiles como el laboral y el familiar de 
  cada individuo de la población en observación."),
        tags$p("Los gráficos muestran la dimension origen o destino de cada cantón, indicándose de manera dinamica la dirección en el movimiento de las curvas."),
        tags$p("MOVILIDAD HUMANA:"),
        tags$p("Muestra el movimiento humano ocurrido en un intervalo de tiempo de 8 horas. Para ello son empleados los datos facilitados 
  por la division DATA FOR GOOD de la empresa FACEBOOK. Los datos son anonimizados además de ser entregados a los investigadores en bloques agrupados
  por 4 criterios:"), 
        tags$p("(1) Cantidad de individuos pre crisis: Movimiento humano considerado como NORMAL medido por 45 dias antes del período CRISIS"),
        tags$p("(2) Cantidad de individuos crisis: Cantidad de individuos que realizaron movimiento en las últimas 8 horas, utilizando para ello el posicionamiento global."),
        tags$p("(3) Indice Zeta, que escala los datos con respecto a la desviación observada en cada grupo para hacerlos comparables entre Cantones. De esta forma,
  cada unidad representa la cantidad de desviaciones estandar que representa la observacion actual con respecto el periodo anterior a la crisis (normal).
  Este valor puede ser negativo, indicando una reducción del movimiento de las personas durante las 8 horas del dia correspondiente -objetivo que 
  persigue el distanciamiento social- o positivo, indicando una movilidad mayor a la esperada aun en momentos de normalidad."),
        tags$p("(4) Diferencia observada entre el periodo NORMAL y el periodo CRISIS.")
      ),
      easyClose = TRUE,
      footer = modalButton("Aceptar")
    ))
  })
  
})