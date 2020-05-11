options(shiny.jquery.version=1)
library(gentelellaShiny)
library(bsplus)
library(leaflet)
library(dygraphs)
library(shiny.i18n)

i18n <- Translator$new(translation_json_path = "./www/translations.json")
i18n$set_translation_language("es")

source("bd_covid19.R")

# Incluye todos los archivos con el prefijo ui para que esten disponibles al renderizar el app
file.sources = list.files(pattern = "ui_.+\\.R")
sapply(file.sources, source)

# Funcion covidUI principal que renderiza la aplicación
ui = shinyUI(gentelellaPageCustom(
  title = "COVID-19",
  navbar = gentelellaNavbar(),
  sidebar = sidebar,
  body = gentelellaBody(
    includeCSS("dashboard.css"),
    tags$head(includeHTML(("analytics.html"))),
    tags$script(HTML(
      '$(document).ready(function(){$(".collapse").each((i, item) => { $(item).removeClass("in") });});'
    )),
    tabs
  ),
  footer = gentelellaFooter(leftText = tags$span(tags$span(i18n$t("Centro de Investigación en Procesamiento y Análisis de Datos")), tags$a(href="mailto:info@cipadcr.com","(info@cipadcr.com)")), rightText = "2020")
))
