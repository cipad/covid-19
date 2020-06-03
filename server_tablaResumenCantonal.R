library(sparkline)
library(formattable)
library(htmltools)
source("bd_covid19.R")

custom_color_tile <- function (...) 
{
  formatter("span",
            style = function(x) style(display = "block", 
                                      padding = "0 4px", 
                                      `color` = "white", 
                                      `border-radius` = "4px", 
                                      `background-color` = csscolor(gradient(as.numeric(x),...))
            )
  )
}

tablaResumenCantonal = function(psVariable= "probabilidad_riesgo", pnTop = 10) {
  
  nDias = 7
  df = fx_canton_top_resumen(pnDias = nDias, psVariable = psVariable, pnTop = pnTop)
  
  # Crea los graficos para cada canton
  
  df$activos_hist = ""
  df$fallecidos_hist = ""
  df$positivos_hist = ""
  df$recuperados_hist = ""
  df$riesgo_proyectado = ""
  for (i in 1:nrow(df) ) {
    nBaseRangos = 11
    df$activos_hist[i]  = as.character(htmltools::as.tags(sparkline(as.numeric(df[i,c(nBaseRangos:(nBaseRangos+nDias-1))]), type = "bar", barColor = "orange")))
    nBaseRangos = nBaseRangos + nDias
    df$fallecidos_hist[i]    = as.character(htmltools::as.tags(sparkline(as.numeric(df[i,c(nBaseRangos:(nBaseRangos+nDias-1))]), type = "bar", barColor = "black")))
    nBaseRangos = nBaseRangos + nDias
    df$positivos_hist[i]      = as.character(htmltools::as.tags(sparkline(as.numeric(df[i,c(nBaseRangos:(nBaseRangos+nDias-1))]), type = "bar", barColor = "blue")))
    nBaseRangos = nBaseRangos + nDias
    df$recuperados_hist[i]   = as.character(htmltools::as.tags(sparkline(as.numeric(df[i,c(nBaseRangos:(nBaseRangos+nDias-1))]), type = "bar", barColor = "green")))
    nBaseRangos = nBaseRangos + 1 + nDias
    df$riesgo_proyectado[i] = as.character(htmltools::as.tags(sparkline(as.numeric(df[i,c(nBaseRangos:(nBaseRangos+nDias-1))]), type = "line", lineColor = "red")))  
  }
  
  df[,c(6)] = df[,c(6)] * 100
  
  # Deja solo las columnas para la tabla de despliegue
  df_g = df[,c(1:10,47:51)]
  
  renderUI({
    out = formattable(
      df_g,
      align = c("l",rep("c", 4),"r",rep("c", 3+6)), 
      list(`canton` = formattable::formatter("span", style = ~ style(color = "grey",font.weight = "bold")) 
           , formattable::area(col = 6) ~ color_bar("#FA614B", fun=function(x) (x) / (max(x)) )
           , formattable::area(col = 2:5) ~ custom_color_tile("#B1CBEB", "#3E7DCC")
           , formattable::area(col = 7:10) ~ color_tile("#DeF7E9", "#71CA97")
           , formattable::area(col = 10) ~ formattable::formatter("span", 
                                                                  style = ~ style(color = ifelse(`delta_activos` > 0, "red", "green")),
                                                                  ~ icontext(provider = getOption("formattable.icon.provider", "fa"), sapply(`delta_activos`, function(x) if (x < 0) "arrow-down" else if (x > 0) "arrow-up" else ""), `delta_activos`)
           )
      )
    ) %>%
      formattable::format_table() %>%
      htmltools::HTML() %>%
      div() %>%
      # use new sparkline helper for adding dependency
      spk_add_deps()
  })
}