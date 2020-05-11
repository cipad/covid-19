library(shiny.i18n)

i18n <- Translator$new(translation_json_path = "./www/translations.json")
i18n$set_translation_language("es")

sidebar = gentelellaSidebar(
  site_title = shiny::HTML(paste(shiny::icon("flask"),
                                 "COVID-19")),
  uiOutput("profile"),
  sidebarDate(),
  sidebarMenu(
    sidebarItem(
      i18n$t("Inicio"),
      tabName = "inicio", 
      icon = tags$i(class = "fas fa-home")
    ),
    sidebarItem(
      i18n$t("Canton"),
      tabName = "canton", 
      icon = tags$i(class = "fas fa-map-marker")
    )
  )
)