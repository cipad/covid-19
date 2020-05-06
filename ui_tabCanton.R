library(mapdeck)

source("bd_covid19.R")
ultimafechaConDatos = fx_diacovid_crc()$fecha
fechaInicioDatosPorCanton = "2020-03-15"

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
      tags$h3("Datos Acumulados")
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
    column(
      12,
      tags$h3(tags$span("Movilidad Humana Cantonal"), actionLink("abrirInfoMovilidad", icon("question-circle-o")))
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
  )
)