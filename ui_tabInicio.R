source("bd_covid19.R")
estatus_pais = fx_corte_status_pais()

tabInicio = tabItem(
  tabName = "inicio",
  fluidRow(
    column(
      12,
      tags$h3("Datos Nuevos")
    )
  ),
  fluidRow(
    column(
      3,
      accordionItem("positivos_nuevos", estatus_pais$positivos_nuevos, "fa fa-plus", "Positivos", "Nuevos pacientes con prueba positiva", 
                    fluidRow(
                      column(
                        12,
                        fluidRow(
                          column(
                            12,
                            dygraphOutput("positivos_nuevos_serie", height = 100)
                            , style = "position: relative; right: 10%"
                          )
                        )
                      )
                    ))
    ),
    column(
      3,
      accordionItem("recuperados_nuevos", estatus_pais$recuperados_nuevos, "fa fa-smile-o", "Recuperados", "Pacientes COVID con prueba negativa", 
                    fluidRow(
                      column(
                        12,
                        fluidRow(
                          column(
                            12,
                            dygraphOutput("recuperados_nuevos_serie", height = 100)
                            , style = "position: relative; right: 10%"
                          )
                        )
                      )
                    ))
    ),
    column(
      3,
      accordionItem("hospitalizados_nuevos", estatus_pais$hospitalizados_nuevos, "fa fa-hospital-o", "Hospitalizados", "Pacientes en hospital", 
                    fluidRow(
                      column(
                        12,
                        fluidRow(
                          column(
                            12,
                            dygraphOutput("hospitalizados_nuevos_serie", height = 100)
                            , style = "position: relative; right: 10%"
                          )
                        )
                      )
                    ))
    ),
    column(
      3,
      accordionItem("fallecidos_nuevos", estatus_pais$fallecidos_nuevos, "fa fa-frown-o", "Fallecidos", "Desde el último reporte del MS", 
                    fluidRow(
                      column(
                        12,
                        fluidRow(
                          column(
                            12,
                            dygraphOutput("fallecidos_nuevos_serie", height = 100)
                            , style = "position: relative; right: 10%"
                          )
                        )
                      )
                    ))
    ),
  ),
  fluidRow(
    column(
      12,
      tags$h3("Datos Acumulados")
    )
  ),
  fluidRow(
    column(
      3,
      accordionItem("positivos", estatus_pais$positivos, "fa fa-plus", "Positivos", "Pacientes con prueba positiva",
                    fluidRow(
                      column(
                        12,
                        fluidRow(
                          column(
                            12,
                            plotOutput("positivos_genero", height = "200px")
                          )
                        ),
                        fluidRow(
                          column(
                            12,
                            plotOutput("positivos_edad", height = "200px")
                          )
                        ),
                        fluidRow(
                          column(
                            12,
                            plotOutput("positivos_nacionalidad", height = "200px")
                          )
                        )
                      )
                    ))
    ),
    column(
      3,
      accordionItem("recuperados", estatus_pais$recuperados, "fa fa-smile-o", "Recuperados", "Pacientes COVID con prueba negativa",
                    fluidRow(
                      column(
                        12,
                        fluidRow(
                          column(
                            12,
                            plotOutput("recuperados_genero", height = "200px")
                          )
                        ),
                        fluidRow(
                          column(
                            12,
                            plotOutput("recuperados_edad", height = "200px")
                          )
                        )
                      )
                    ))
    ),
    column(
      3,
      accordionItem("hospitalizados", estatus_pais$hospitalizados, "fa fa-hospital-o", "Hospitalizados", "Pacientes en hospital al día de hoy",
                    fluidRow(
                      column(
                        12,
                        fluidRow(
                          column(
                            12,
                            plotOutput("hospitalizados_nivel", height = "200px")
                          )
                        )
                      )
                    ))
      
    ),
    column(
      3,
      accordionItem("fallecidos", estatus_pais$fallecidos, "fa fa-frown-o", "Fallecidos", "Fallecimientos totales",
                    fluidRow(
                      column(
                        12,
                        fluidRow(
                          column(
                            12,
                            plotOutput("fallecidos_genero", height = "200px")
                          )
                        )
                      )
                    ))
    ),
  ),
  fluidRow(
    tags$hr()
  ),
  fluidRow(
    column(6,
           leafletOutput("mapaContagiosPais", height = 470)
    ),
    column(6,
           graph_box(dygraphOutput("graficoLineaAcumulada"),
                     boxtitle = "# Casos por Estado",
                     subtitle = "",
                     datepicker = NULL),
           style = "padding: 0;"
    )
  )
)