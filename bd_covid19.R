
library(dplyr)
sDirDatos = ifelse(Sys.info()["sysname"] == "Linux","./inputdata/",(ifelse(Sys.info()["sysname"]  == "Darwin", "./inputdata/","c:\\Temporal\\CV19\\inputdata\\")))

fx_canton_top_resumen = function( psFecha = "", pnDias = 7, pnTop = 10, psVariable = "activos") {

  # Contagio cantonal
  ds_contagios = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagios$fecha, na.rm = T)
  }
  psInicio = as.Date(psFecha) - pnDias
  
  dfRet = na.omit(ds_contagios[ ds_contagios$fecha > psInicio & ds_contagios$fecha <= psFecha, ])
  
  dfRet = dfRet[order(dfRet[,c("canton")], dfRet[,c("fecha")]), c("canton","fecha","positivos","fallecidos","recuperados","activos")]
  
  names(dfRet) = c("canton","fecha","p","f","r","a")
  
  ds_hist = reshape( direction= "wide",
                     data = dfRet,
                     timevar = "fecha", 
                     idvar = c("canton"),
                     ids = "" )
  
  ds_hist = ds_hist[, union(c(1), order( setdiff(names(ds_hist),c("canton")) )+1) ]
  
  # Proyeccion de riesgo cantonal
  ds_prob = readRDS(file.path(sDirDatos,"st_prob_canton_riesgo.rds"))
  
  names(ds_prob) = c("canton","fecha","z","excluir")
  
  ds_prob = reshape( direction= "wide",
                     data = ds_prob,
                     timevar = "fecha", 
                     idvar = c("canton","excluir"),
                     ids = "" )
  
  ds_prob = ds_prob[, c(names(ds_prob)[1:2],names(ds_prob)[3:10][order(names(ds_prob)[3:10])])]
  
  ds_prop = ds_prob[order(ds_prob[,2], -ds_prob[,4]), c(1:2,4:(3+pnDias))]
  
  
  ds_deltas = merge( x = dfRet[dfRet$fecha == max(dfRet$fecha), c(1,3:6)],
                     y = dfRet[dfRet$fecha == min(dfRet$fecha), c(1,3:6)],
                     by = c("canton"),
                     all.x = T)
  
  ds_deltas = data.frame( canton = ds_deltas[,c(1)], 
                          delta_positivos = ds_deltas$p.x - ifelse(is.na(ds_deltas$p.y),0,ds_deltas$p.y),
                          delta_fallecidos = ds_deltas$f.x - ifelse(is.na(ds_deltas$f.y),0,ds_deltas$f.y),
                          delta_recuperados = ds_deltas$r.x - ifelse(is.na(ds_deltas$r.y),0,ds_deltas$r.y),
                          delta_activos = ds_deltas$a.x - ifelse(is.na(ds_deltas$a.y),0,ds_deltas$a.y),
                          stringsAsFactors = F )
  
  
  # Consolida datos actuales con riesgo probable
  df_Consolidado = merge( x = dfRet[dfRet$fecha == max(dfRet$fecha), c(1,3:6)],
                          y = ds_prop[!ds_prop$excluir,c(1,3)],
                          by = c("canton"),
                          all.x = T)
  
  names(df_Consolidado)[2:6] = c("positivos","fallecidos","recuperados","activos","probabilidad_riesgo")
  
  # Agrega los deltas
  df_Consolidado = merge( x = df_Consolidado,
                          y = ds_deltas,
                          by = c("canton"),
                          all.x = T)
  
  
  # Agrega historico
  df_Consolidado = merge( x = df_Consolidado,
                          y = ds_hist,
                          by = c("canton"),
                          all.x = T)
  
  # Agrega probabilidad de riesgo
  df_Consolidado = merge( x = df_Consolidado,
                          y = ds_prop,
                          by = c("canton"),
                          all.x = T)
  
  # names(df_Consolidado)
  # psVariable = "delta_positivos"
  
  df_Consolidado = df_Consolidado[order(df_Consolidado[,which(names(df_Consolidado) == psVariable)],decreasing = T),]
  
  row.names(df_Consolidado) = seq.int(from = 1, to = nrow(df_Consolidado), by = 1)
  head( df_Consolidado, n = pnTop )
}


fx_canton_top_riesgo = function(pnTop = 10, pnDias=1) {
  
  ds_prob = readRDS(file.path(sDirDatos,"st_prob_canton_riesgo.rds"))
  
  names(ds_prob) = c("canton","fecha","probabilidad","excluir")
  
  head(ds_prob)
  
  ds_prob = reshape( direction= "wide",
                     data = ds_prob,
                     timevar = "fecha", 
                     idvar = c("canton","excluir"),
                     ids = "" )
  
  names(ds_prob) = gsub("probabilidad","prob", names(ds_prob))
  
  ds_prob = ds_prob[, c(names(ds_prob)[1:2],names(ds_prob)[3:10][order(names(ds_prob)[3:10])])]

  head (ds_prob[order(ds_prob[,2], -ds_prob[,4]), c(1:2,4:(3+pnDias))], n = pnTop )
}


fx_canton_riesgo = function(psCanton) {
  
  ds_prob = readRDS(file.path(sDirDatos,"st_prob_canton_riesgo.rds"))
  
  names(ds_prob) = c("canton","fecha","probabilidad","excluir")
  
  ds_prob = ds_prob[ds_prob$canton == psCanton,c("canton","fecha","probabilidad","excluir")]
  ds_prob[order(ds_prob$fecha,decreasing = F),]
}

# names(ds_contagios)
# fx_corte_status_canton_acumulado("ALAJUELA")
fx_corte_status_canton_acumulado = function(psCanton, psFecha = "") {
  
  ds_contagios = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagios$fecha, na.rm = T)
  }
  
  dfRet = ds_contagios[ ds_contagios$canton == psCanton & ds_contagios$fecha <= psFecha, 
                        c( "fecha",
                           "positivos","recuperados","fallecidos","activos") ]
  dfRet = dfRet[!is.na(dfRet$fecha),]
  na.omit(dfRet[order(dfRet$fecha),])
}


fx_historico_variable_canton = function(psCanton, psVariable, psFecha = "", pnDias = 7){
  ds_contagios = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagios$fecha, na.rm = T)
  }
  psInicio = as.Date(psFecha) - pnDias
  
  na.omit(ds_contagios[ ds_contagios$canton == psCanton & ds_contagios$fecha > psInicio & ds_contagios$fecha <= psFecha , 
                    union(c("fecha"),psVariable)])
}

# x = fx_corte_status_canton("ABANGARES")
# names(x)
fx_corte_status_canton = function(psCanton, psFecha = ""){
  ds_contagios = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  ds_cantones = readRDS(file.path(sDirDatos,"integradocantonal.rds"))
  ds_distritos = readRDS(file.path(sDirDatos,"integradodistrital.rds"))
  ds_mapa_ws = readRDS(file.path(sDirDatos,"mapa_walkscore.rds"))

  ds_mapa_ws = reshape(ds_mapa_ws[ds_mapa_ws$canton==psCanton, c("canton","mapa_ws", "modo")], direction= "wide", idvar = c("canton"), timevar = "modo" )
  names(ds_mapa_ws) = gsub("\\.","_",names(ds_mapa_ws))
  
  df_ws = ds_distritos %>%
                select(canton, walkscore) %>%
                group_by(canton) %>%
                summarise(ws_min = round(min(walkscore),1), ws_max = round(max(walkscore),1), ws_avg = round(mean(walkscore),1))

  if (psFecha == "") {
    psFecha = max(ds_contagios$fecha, na.rm = T)
  }
  
  dfRet = merge( ds_contagios[ds_contagios$fecha == psFecha & ds_contagios$canton == psCanton,],
                 ds_cantones[ds_cantones$canton == psCanton, c("canton","ids_2017", "poblacion", "tasa_mortalidad", "tasa_natalidad", "tasa_nupcialidad", "extension", "matricula")],
                 by = c("canton"),
                 all.x = TRUE
  )
  
  dfRet = merge( dfRet,
                 df_ws,
                 by = c("canton"),
                 all.x = TRUE
  )
  
  dfRet = merge( dfRet,
                 ds_mapa_ws[ds_mapa_ws$canton==psCanton, ],
                 by = c("canton"),
                 all.x = TRUE
  )
  

  dfRet$ids_2017 = round(dfRet$ids_2017, 1)
  dfRet$tasa_mortalidad = round(dfRet$tasa_mortalidad, 1)
  dfRet$tasa_natalidad = round(dfRet$tasa_natalidad, 1)
  dfRet$tasa_nupcialidad = round(dfRet$tasa_nupcialidad, 1)
  
  dfRet$tasa_contagio = round(1000 * dfRet$positivos / dfRet$poblacion, 1)
  dfRet$tasa_densidad_contagio = round(dfRet$positivos / dfRet$extension,1)
  dfRet$densidad_poblacional = round(dfRet$poblacion / dfRet$extension,1)
  
  na.omit(dfRet)
}

# fx_movilidad_canton_mapa("ALAJUELITA", pnZScore = 0, psFecha = "2020-05-10", psHora = 16)
fx_movilidad_canton_mapa = function(psCanton, pnZScore = 0, psFecha = "", psHora = ""){
  #psCanton = "PUNTARENAS"
  ds_movilidad = readRDS(file.path(sDirDatos,"st_movilidad.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_movilidad$fecha)
  }
  
  # filtra por fecha y canton
  ds_movilidad = ds_movilidad[ds_movilidad$fecha == psFecha & abs(ds_movilidad$z_score) >= pnZScore & (ds_movilidad$canton_origen == psCanton | ds_movilidad$canton_destino == psCanton), c("fecha","hora","z_score","canton_origen","canton_destino","latitud_origen","longitud_origen","latitud_destino","longitud_destino","n_lineabase") ]
  # ds_movilidad = ds_movilidad[ds_movilidad$fecha == psFecha & (ds_movilidad$canton_origen == psCanton | ds_movilidad$canton_destino == psCanton), c("fecha","hora","z_score","canton_origen","canton_destino","latitud_origen","longitud_origen","latitud_destino","longitud_destino","n_lineabase") ]
  
  # filtra por la hora
  if (psHora == ""){
    psHora = max(ds_movilidad$hora, na.rm = T)
  } else {
    #psHora = 24
    psHora = as.numeric(psHora)-8
    psHora = paste0(ifelse(psHora <= 8, "0", ""),psHora,":00")
  }
  
  ds_movilidad = ds_movilidad[ds_movilidad$hora == psHora, ]
  
  ds_movilidad$z_score_sube = ifelse(ds_movilidad$z_score>0, ds_movilidad$z_score^2, -1)
  
  ds_movilidad$z_score_baja = ifelse(ds_movilidad$z_score<0, ds_movilidad$z_score^2, -1) 
  
  dfRet = ds_movilidad[ ds_movilidad$canton_origen != ds_movilidad$canton_destino, c("fecha","hora", "z_score","z_score_sube","z_score_baja","canton_origen","canton_destino")]
  
  ds_cantones = readRDS(file.path(sDirDatos,"integradocantonal.rds"))
  
  dfRet = merge(dfRet,
                ds_cantones[,c("canton", "latitud", "longitud")],
                by.x = c("canton_origen"),
                by.y = c("canton"),
                all.x = T
                )
  names(dfRet)[names(dfRet)=="latitud"] = "latitud_origen"
  names(dfRet)[names(dfRet)=="longitud"] = "longitud_origen"
  
  dfRet = merge(dfRet,
                ds_cantones[,c("canton", "latitud", "longitud")],
                by.x = c("canton_destino"),
                by.y = c("canton"),
                all.x = T
  )
  names(dfRet)[names(dfRet)=="latitud"] = "latitud_destino"
  names(dfRet)[names(dfRet)=="longitud"] = "longitud_destino"
  
  na.omit(dfRet)
}

fx_cantones_covid = function(psFecha = ""){
  
  ds_contagios = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagios$fecha, na.rm = T)
  }
  
  ds_contagios = ds_contagios[ ds_contagios$fecha == psFecha, c("canton")]
  
  na.omit(ds_contagios[order(ds_contagios)])
}

fx_diacovid_crc = function(psFecha = ""){
  ds_contagiospais = readRDS(file.path(sDirDatos,"st_contagiopais.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagiospais$fecha, na.rm = T)
  }
  
  na.omit(ds_contagiospais[ ds_contagiospais$fecha == psFecha , c( "dia_covid19", "fecha")])
}


fx_historico_variable_pais = function(psVariable, psFecha = "", pnDias = 7){
  ds_contagiospais = readRDS(file.path(sDirDatos,"st_contagiopais.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagiospais$fecha, na.rm = T)
  }
  psInicio = as.Date(psFecha) - pnDias
  
  na.omit(ds_contagiospais[ ds_contagiospais$fecha > psInicio & ds_contagiospais$fecha <= psFecha , 
                    union(c( "dia_covid19", "fecha"),psVariable)])
}


fx_corte_status_pais = function(psFecha = ""){
  
  ds_contagiospais = readRDS(file.path(sDirDatos,"st_contagiopais.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagiospais$fecha, na.rm = T)
  }
  
  na.omit(ds_contagiospais[ ds_contagiospais$fecha == psFecha, 
                    c( "dia_covid19", "fecha", 
                       "positivos",
                       "positivos_masculino", "positivos_femenino",
                       "positivos_adultos","positivos_adulto_mayor","positivos_menor",
                       "positivos_extranjero","positivos_local","positivos_investigacion",
                       "recuperados",
                       "recuperados_masculino", "recuperados_femenino",
                       "recuperados_adulto","recuperados_adulto_mayor","recuperados_menor",
                       "fallecidos",
                       "fallecidos_masculino", "fallecidos_femenino",
                       "positivos_nuevos","recuperados_nuevos","fallecidos_nuevos", 
                       "hospitalizados",
                       "salon","uci",
                       "hospitalizados_nuevos",
                       "salon_nuevos","uci_nuevos") ] )
}


fx_corte_status_pais_acumulado = function(psFecha = "") {
  
  ds_contagiospais = readRDS(file.path(sDirDatos,"st_contagiopais.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagiospais$fecha, na.rm = T)
  }
  
  na.omit(ds_contagiospais[ ds_contagiospais$fecha <= psFecha, 
                    c( "dia_covid19", "fecha", 
                       "positivos","recuperados","fallecidos",
                       "positivos_nuevos","recuperados_nuevos","fallecidos_nuevos", 
                       "hospitalizados","salon","uci",
                       "hospitalizados_nuevos","salon_nuevos","uci_nuevos") ] )
}


fx_corte_status_pais_mapa = function(psFecha = "", pnAcumula = 0) {
  
  ds_contagioscanton = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagioscanton$fecha, na.rm = T)
  }
  
  if (pnAcumula == 0) {
    dfRet = ds_contagioscanton[ ds_contagioscanton$fecha == psFecha, 
                        c( "fecha", "canton", 
                           "positivos","recuperados","fallecidos","activos",
                           "latitud","longitud") ]
  } else {
    dfRet = ds_contagioscanton[ ds_contagioscanton$fecha <= psFecha, 
                                c( "fecha", "canton", 
                                   "positivos","recuperados","fallecidos","activos",
                                   "latitud","longitud") ]
  }
  
  dfRet = dfRet[!is.na(dfRet$latitud) | !is.na(dfRet$longitud), ]
  na.omit(dfRet)
}
