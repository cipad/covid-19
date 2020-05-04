sidebar = gentelellaSidebar(
  site_title = shiny::HTML(paste(shiny::icon("flask"),
                                 "COVID-19")),
  uiOutput("profile"),
  sidebarDate(),
  sidebarMenu(
    sidebarItem(
      "Inicio",
      tabName = "inicio", 
      icon = tags$i(class = "fas fa-home")
    ),
    sidebarItem(
      "Canton",
      tabName = "canton", 
      icon = tags$i(class = "fas fa-map-marker")
    )
  )
)