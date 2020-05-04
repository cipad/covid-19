# Incluye todos los archivos con el prefijo ui para que esten disponibles al renderizar el app
file.sources = list.files(pattern = "ui_.+\\.R")
sapply(file.sources, source)

# Funcion covidUI principal que renderiza la aplicación
covidUI = gentelellaPageCustom(
  title = "COVID-19",
  navbar = gentelellaNavbar(),
  sidebar = sidebar,
  body = gentelellaBody(
    includeCSS("dashboard.css"),
    tags$script(HTML(
      '$(document).ready(function(){$(".collapse").each((i, item) => { $(item).removeClass("in") });});'
    )),
    tabs
  ),
  footer = gentelellaFooter(leftText = "Centro de Investigación en Procesamiento y Análisis de Datos", rightText = "2020")
)