source("bd_covid19.R")
library(shiny.i18n)

i18n <- Translator$new(translation_json_path = "./www/translations.json")
i18n$set_translation_language("es")

estatus_pais = fx_corte_status_pais()

tabInicio = tabItem(
  tabName = "inicio",
  fluidRow(
    column(
      12,
      tags$h3(i18n$t("Datos Nuevos"))
    )
  ),
  fluidRow(
    column(
      3,
      accordionItem("positivos_nuevos", estatus_pais$positivos_nuevos, "fa fa-plus", i18n$t("Positivos"), i18n$t("Nuevos pacientes con prueba positiva ▼"), 
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
      accordionItem("recuperados_nuevos", estatus_pais$recuperados_nuevos, "fa fa-smile-o", i18n$t("Recuperados"), i18n$t("Pacientes COVID con prueba negativa ▼"), 
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
      accordionItem("hospitalizados_nuevos", estatus_pais$hospitalizados_nuevos, "fa fa-hospital-o", i18n$t("Hospitalizados"), i18n$t("Pacientes en hospital ▼"), 
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
      accordionItem("fallecidos_nuevos", estatus_pais$fallecidos_nuevos, "fa fa-frown-o", i18n$t("Fallecidos"), i18n$t("Desde el último reporte del MS ▼"), 
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
      tags$h3(i18n$t("Datos Acumulados"))
    )
  ),
  fluidRow(
    column(
      3,
      accordionItem("positivos", estatus_pais$positivos, "fa fa-plus", i18n$t("Positivos"), i18n$t("Pacientes con prueba positiva ▼"),
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
      accordionItem("recuperados", estatus_pais$recuperados, "fa fa-smile-o", i18n$t("Recuperados"), paste(estatus_pais$positivos - (estatus_pais$recuperados + estatus_pais$fallecidos), i18n$t("casos activos ▼")),
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
      accordionItem("hospitalizados", estatus_pais$hospitalizados, "fa fa-hospital-o", i18n$t("Hospitalizados"), i18n$t("Pacientes en hospital al día de hoy ▼"),
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
      accordionItem("fallecidos", estatus_pais$fallecidos, "fa fa-frown-o", i18n$t("Fallecidos"), i18n$t("Fallecimientos totales ▼"),
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
    tags$h3(i18n$t("Contagios por Canton"))
  ),
  fluidRow(
    column(12,
           mapdeckOutput("mapaCasosCanton", height = 470)
    )
  ),
  fluidRow(
    tags$hr()
  ),
  fluidRow(
    tags$h3(i18n$t("Linea de Tiempo de Contagios"))
  ),
  fluidRow(
    column(12,
           leafletOutput("mapaTimeline", height = 470)
    )
  ),
  fluidRow(
    tags$hr()
  ),
  fluidRow(
    tags$h3(i18n$t("Resumen de datos"))
  ),
  fluidRow(
    column(6,
           leafletOutput("mapaContagiosPais", height = 470)
    ),
    column(6,
           graph_box(dygraphOutput("graficoLineaAcumulada"),
                     boxtitle = i18n$t("# Casos por Estado"),
                     subtitle = "",
                     datepicker = NULL),
           style = "padding: 0;"
    )
  )
)