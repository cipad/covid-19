library(mapdeck)
library(shiny.i18n)

i18n <- Translator$new(translation_json_path = "./www/translations.json")
i18n$set_translation_language("es")

labelAPie = i18n$t("A Pie")
labelBicicleta = i18n$t("Bicicleta")
labelVehiculo = i18n$t("Vehículo")

source("bd_covid19.R")
ultimafechaConDatos = fx_diacovid_crc()$fecha
fechaInicioDatosPorCanton = "2020-03-15"
ultimaFechaConDatosMovilidad = format((as.Date(ultimafechaConDatos)-1), "%Y-%m-%d")

tabCanton = tabItem(
  tabName = "canton",
  fluidRow(
    column(
      12,
      tags$h3(i18n$t("Filtrado de datos"))
    ),
  ),
  fluidRow(
    column(
      3,
      dateInput(
        "fechaCorteCanton",
        i18n$t("Fecha del Corte:"),
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
        i18n$t("Cantón:"),
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
      tags$h3(i18n$t("Datos COVID-19"))
    )
  ),
  fluidRow(
    column(
      4,
      accordionItem("positivosCanton", textOutput("estatus_canton_positivos"), "fa fa-plus", i18n$t("Positivos"), i18n$t("Pacientes con prueba positiva"),NULL)
    ),
    column(
      4,
      accordionItem("recuperadosCanton", textOutput("estatus_canton_recuperados"), "fa fa-smile-o", i18n$t("Recuperados"), i18n$t("Pacientes COVID con prueba negativa"), NULL)
    ),
    column(
      4,
      accordionItem("fallecidosCanton", textOutput("estatus_canton_fallecidos"), "fa fa-frown-o", i18n$t("Fallecidos"), i18n$t("Fallecimientos totales"),NULL)
    )
  ),
  fluidRow(
    tags$hr()
  ),
  fluidRow(
    column(
      12,
      tags$h3(i18n$t("Indicadores"))
    )
  ),
  fluidRow(
    column(
      3,
      accordionItem("indicadorCantonPoblacion", textOutput("indicador_poblacion"), "fa fa-users", i18n$t("Población"), i18n$t("Censo 2016"), NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonDensidadPoblacional", textOutput("indicador_densidad_poblacional"), "fa fa-street-view", i18n$t("Personas por km2"), i18n$t("CIPAD"),NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonDensidadContagio", textOutput("indicador_tasa_densidad_contagio"), "fa fa-fast-forward", i18n$t("Contagios por km2"), i18n$t("CIPAD"),NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonTasaContagio", textOutput("indicador_tasa_contagio"), "fa fa-forward", i18n$t("Contagios / 1000 hab."), i18n$t("CIPAD"), NULL)
    )
  ),
  fluidRow(
    column(
      3,
      accordionItem("indicadorCantonExtension", textOutput("indicador_extension"), "fa fa-map-o", i18n$t("Extensión (km2)"), i18n$t("Estado de la Nación 2016"),NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonMortalidad", textOutput("indicador_tasa_mortalidad"), "fa fa-user-times", i18n$t("Mortalidad / 1000 hab."), i18n$t("INEC 2018"),NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonNatalidad", textOutput("indicador_tasa_natalidad"), "fa fa-user-plus", i18n$t("Natalidad / 1000 hab."), i18n$t("INEC 2018"),NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonNupcialidad", textOutput("indicador_tasa_nupcialidad"), "fa fa-venus-mars", i18n$t("Nupcialidad / 1000 hab."), i18n$t("INEC 2018"),NULL)
    )
  ),
  fluidRow(
    column(
      3,
      accordionItem("indicadorCantonIDS", textOutput("indicador_ids_2017"), "fa fa-thermometer-2", i18n$t("Índice Desarrollo Social"), i18n$t("Estado de la Nación 2017"),NULL)
    ),
    column(
      3,
      accordionItem("indicadorCantonMatricula", textOutput("indicador_matricula"), "fa fa-graduation-cap", i18n$t("Matrícula"), i18n$t("MEP 2019"), NULL)
    )
  ),
  fluidRow(
    tags$hr()
  ),
  fluidRow(
    column(
      12,
      tags$h3(tags$span(i18n$t("Movilidad Humana Cantonal")), actionLink("abrirInfoMovilidad", icon("question-circle-o")))
    )
  ),
  fluidRow(
    column(
      6,
      style = "text-align: center",
      tags$a(href="http://cipadcr.com/", target="_blank", tags$span(tags$span(i18n$t("Desarrollado por")), tags$img(src="./CIPAD.png", style="margin-left: 10px;")))
    ),
    column(
      6,
      style = "text-align: center",
      tags$a(href="https://dataforgood.fb.com/", target="_blank", tags$span(tags$span(i18n$t("Datos de movilidad provistos por")),tags$img(src="./facebookDataForGood.svg", style="width: 300px")))
    ),
    style = "margin: 30px 0px;"
  ),
  fluidRow(
    column(
      12,
      tags$h4(i18n$t("Pronóstico de Contagio por Cantón basado en la Movilidad Humana"))
    )
  ),
  fluidRow(
    column(
      12,
       graph_box(dygraphOutput("graficoLineaProbabilidad"),
                 boxtitle = i18n$t("Probabilidad diaria"),
                 subtitle = "",
                 datepicker = NULL),
       style = "padding: 0;"
    )
  ),
  fluidRow(
    column(
      12,
      uiOutput("labelAlertaProbabilidad")
    )
  ),
  fluidRow(
    column(
      12,
      tags$h4(i18n$t("Filtros Mapas Movilidad"))
    )
  ),
  fluidRow(
    column(
      3,
      dateInput(
        "fechaCorteMovilidadCanton",
        i18n$t("Fecha del Corte:"),
        value = ultimaFechaConDatosMovilidad,
        min = "2020-04-13",
        max = ultimaFechaConDatosMovilidad,
        language = "es"
      )
    ),
    column(
      3,
      sliderInput("intensidadMovilidad", i18n$t("Intensidad Mínima de Movilidad:"),
                  min = 0, max = 3,
                  value = 0, step = 1, ticks = FALSE)
    ),
    column(
      3,
      sliderInput("horaMovilidad", i18n$t("Hora del día (8:00, 16:00, 24:00):"),
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
          tags$h4(i18n$t("Reducción de Movilidad Humana"))
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
          tags$h4(i18n$t("Incremento de Movilidad Humana"))
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
      tags$h3(i18n$t("Urbanismo"))
    )
  ),
  fluidRow(
    column(
      4,
      accordionItem("indicadorCantonWSMin", textOutput("indicador_ws_min"), "fa fa-building-o", i18n$t("Urbanidad mínima"), i18n$t("WalkScore®"),NULL)
    ),
    column(
      4,
      accordionItem("indicadorCantonWSAvg", textOutput("indicador_ws_avg"), "fa fa-building-o", i18n$t("Urbanidad promedio"), i18n$t("WalkScore®"), NULL)
    ),
    column(
      4,
      accordionItem("indicadorCantonWSMax", textOutput("indicador_ws_max"), "fa fa-building-o", i18n$t("Urbanidad máxima"), i18n$t("WalkScore®"), NULL)
    )
  ),
  fluidRow(
    column(
      3,
      sliderInput("minutosWS", i18n$t("Minutos desde el punto 0:"),
                  min = 15, max = 45,
                  value = 15, step = 15, ticks = TRUE)
    ),
    column(
      3,
      radioButtons("medioWS", i18n$t("Medio Transporte:"),
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
