ultimafechaConDatos = fx_diacovid_crc()$fecha
print(ultimafechaConDatos)
fechaInicioDatosPorCanton = "2020-03-15"

tabCanton = tabItem(
  tabName = "canton",
  fluidRow(
    column(
      12,
      tags$h3("Filtrado de datos")
    )
  ),
  fluidRow(
    column(
      12,
      dateInput(
        "fechaCorteCanton",
        "Fecha del Corte:",
        value = ultimafechaConDatos,
        min = fechaInicioDatosPorCanton,
        max = ultimafechaConDatos,
        language = "es"
      )
    )
  ),
  fluidRow(
    column(
      12,
      selectizeInput(
        'seleccionCanton',
        'Cantón:',
        choices = list(),
        options = list(
          placeholder = 'Por favor seleccione un cantón'
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
      tags$h3("Datos Acumulados")
    )
  )
)