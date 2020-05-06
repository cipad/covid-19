library(mapdeck)

source("bd_covid19.R")
ultimafechaConDatos = fx_diacovid_crc()$fecha
fechaInicioDatosPorCanton = "2020-03-15"
ultimaFechaConDatosMovilidad = format((as.Date(ultimafechaConDatos)-1), "%Y-%m-%d")

tabCanton = tabItem(
  tabName = "canton",
  fluidRow(
    column(
      12,
      tags$h3("Filtrado de datos")
    ),
  ),
  fluidRow(
    column(
      3,
      dateInput(
        "fechaCorteCanton",
        "Fecha del Corte:",
        value = ultimafechaConDatos,
        min = fechaInicioDatosPorCanton,
        max = ultimafechaConDatos,
        language = "es"
      )
    ),
    column(
      3,
      selectizeInput(
        'seleccionCanton',
        'Cantón:',
        choices = list(),
        options = list(
          placeholder = 'Por favor seleccione un cantón'
        )
      )
    ),
    column(
      6
    )
  ),
  fluidRow(
    tags$hr()
  ),
  fluidRow(
    column(
      12,
      tags$h3("Datos COVID-19")
    )
  ),
  fluidRow(
    column(
      4,
      accordionItem("positivosCanton", textOutput("estatus_canton_positivos"), "fa fa-plus", "Positivos", "Pacientes con prueba positiva",NULL)
    ),
    column(
      4,
      accordionItem("recuperadosCanton", textOutput("estatus_canton_recuperados"), "fa fa-smile-o", "Recuperados", "Pacientes COVID con prueba negativa", NULL)
    ),
    column(
      4,
      accordionItem("fallecidosCanton", textOutput("estatus_canton_fallecidos"), "fa fa-frown-o", "Fallecidos", "Fallecimientos totales",NULL)
    )
  ),
  fluidRow(
    tags$hr()
  ),
  fluidRow(
    column(
      12,
      tags$h3("Indicadores")
    )
  ),
  fluidRow(
    column(
      3,
      accordionItem("indicadorCantonPoblacion", textOutput("indicador_poblacion"), "fa fa-users", "Población", "Censo 2016", NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonDensidadPoblacional", textOutput("indicador_densidad_poblacional"), "fa fa-street-view", "Personas por km2", "CIPAD",NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonDensidadContagio", textOutput("indicador_tasa_densidad_contagio"), "fa fa-fast-forward", "Contagios por km2", "CIPAD",NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonTasaContagio", textOutput("indicador_tasa_contagio"), "fa fa-forward", "Contagios / 1000 hab.", "CIPAD", NULL)
    )
  ),
  fluidRow(
    column(
      3,
      accordionItem("indicadorCantonExtension", textOutput("indicador_extension"), "fa fa-map-o", "Extensión (km2)", "Estado de la Nación 2016",NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonMortalidad", textOutput("indicador_tasa_mortalidad"), "fa fa-user-times", "Mortalidad / 1000 hab.", "INEC 2018",NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonNatalidad", textOutput("indicador_tasa_natalidad"), "fa fa-user-plus", "Natalidad / 1000 hab.", "INEC 2018",NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonNupcialidad", textOutput("indicador_tasa_nupcialidad"), "fa fa-venus-mars", "Nupcialidad / 1000 hab.", "INEC 2018",NULL)
    )
  ),
  fluidRow(
    column(
      3,
      accordionItem("indicadorCantonIDS", textOutput("indicador_ids_2017"), "fa fa-thermometer-2", "Índice Desarrollo Social", "Estado de la Nación 2017",NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonMatricula", textOutput("indicador_matricula"), "fa fa-graduation-cap", "Matrícula", "MEP 2019", NULL)
    )
  ),
  fluidRow(
    tags$hr()
  ),
  fluidRow(
    column(
      12,
      tags$h3(tags$span("Movilidad Humana Cantonal"), actionLink("abrirInfoMovilidad", icon("question-circle-o")))
    )
  ),
  fluidRow(
    column(
      6,
      style = "text-align: center",
      tags$a(href="http://cipadcr.com/", target="_blank", tags$span(tags$span("Desarrollado por"), tags$img(src="./CIPAD.png", style="margin-left: 10px;")))
    ),
    column(
      6,
      style = "text-align: center",
      tags$a(href="https://dataforgood.fb.com/", target="_blank", tags$span(tags$span("Mobility Data Provided by"),tags$img(src="./facebookDataForGood.svg", style="width: 300px")))
    ),
    style = "margin: 30px 0px;"
  ),
  fluidRow(
    column(
      12,
      tags$h4("Filtros Mapas Movilidad")
    )
  ),
  fluidRow(
    column(
      3,
      dateInput(
        "fechaCorteMovilidadCanton",
        "Fecha del Corte:",
        value = ultimaFechaConDatosMovilidad,
        min = "2020-04-13",
        max = ultimaFechaConDatosMovilidad,
        language = "es"
      )
    ),
    column(
      3,
      sliderInput("intensidadMovilidad", "Intensidad Mínima de Movilidad:",
                  min = 0, max = 3,
                  value = 0, step = 1, ticks = FALSE)
    ),
    column(
      3,
      sliderInput("horaMovilidad", "Hora del día (8:00, 16:00, 24:00):",
                  min = 8, max = 24,
                  value = 16, step = 8, ticks = FALSE)
    )
  ),
  fluidRow(
    column(
      6,
      fluidRow(
        column(
          12,
          tags$h4("Reducción de Movilidad Humana")
        ),
        column(
          12,
          mapdeckOutput("mapaMovilidadCantonReduccion")
        )
      )
    ),
    column(
      6,
      fluidRow(
        column(
          12,
          tags$h4("Incremento de Movilidad Humana")
        ),
        column(
          12,
          mapdeckOutput("mapaMovilidadCantonIncremento")
        )
      )
    )
  ),
  fluidRow(
    tags$hr()
  ),
  fluidRow(
    column(
      12,
      tags$h3("Urbanismo")
    )
  ),
  fluidRow(
    column(
      4,
      accordionItem("indicadorCantonWSMin", textOutput("indicador_ws_min"), "fa fa-building-o", "Urbanidad mínima", "WalkScore®",NULL)
    ),
    column(
      4,
      accordionItem("indicadorCantonWSAvg", textOutput("indicador_ws_avg"), "fa fa-building-o", "Urbanidad promedio", "WalkScore®", NULL)
    ),
    column(
      4,
      accordionItem("indicadorCantonWSMax", textOutput("indicador_ws_max"), "fa fa-building-o", "Urbanidad máxima", "WalkScore®", NULL)
    )
  ),
  fluidRow(
    column(
      3,
      sliderInput("minutosWS", "Minutos desde el punto 0:",
                  min = 15, max = 45,
                  value = 15, step = 15, ticks = TRUE)
    ),
    column(
      3,
      radioButtons("medioWS", "Medio Transporte:",
                   c("A Pie" = "walk",
                     "Bicicleta" = "bike",
                     "Vehículo" = "drive"), selected = "walk", inline = TRUE)
    )
  ),
  fluidRow(
    column(12,
      leafletOutput("mapaWS", height = 600)
    )
  )
)
