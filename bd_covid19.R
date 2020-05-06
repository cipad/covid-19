sDirDatos = ifelse(Sys.info()["sysname"] == "Linux","./inputdata/","c:\\Temporal\\CV19\\inputdata\\")

# fx_corte_status_canton_acumulado("ALAJUELA")
fx_corte_status_canton_acumulado = function(psCanton, psFecha = "") {
  
  ds_contagios = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagios$fecha)
  }
  
  dfRet = ds_contagios[ ds_contagios$canton == psCanton & ds_contagios$fecha <= psFecha, 
                        c( "fecha",
                           "positivos","recuperados","fallecidos","activos") ]
  dfRet = dfRet[!is.na(dfRet$fecha),]
  dfRet[order(dfRet$fecha),]
}


fx_historico_variable_canton = function(psCanton, psVariable, psFecha = "", pnDias = 7){
  ds_contagios = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagios$fecha)
  }
  psInicio = as.Date(psFecha) - pnDias
  
  ds_contagios[ ds_contagios$canton == psCanton & ds_contagios$fecha > psInicio & ds_contagios$fecha <= psFecha , 
                    union(c("fecha"),psVariable)]
}

# fx_corte_status_canton("ATENAS")
fx_corte_status_canton = function(psCanton, psFecha = ""){
  ds_contagios = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  ds_cantones = readRDS(file.path(sDirDatos,"integradocantonal.rds"))
  ds_distritos = readRDS(file.path(sDirDatos,"integradodistrital.rds"))
  ds_mapa_ws = readRDS(file.path(sDirDatos,"mapa_walkscore.rds"))
  
  df_ws = ds_distritos %>%
                select(canton, walkscore) %>%
                group_by(canton) %>%
                summarise(ws_min = round(min(walkscore),1), ws_max = round(max(walkscore),1), ws_avg = round(mean(walkscore),1))

  if (psFecha == "") {
    psFecha = max(ds_contagios$fecha)
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
                 ds_mapa_ws[ds_mapa_ws$modo=="walk" & ds_mapa_ws$canton==psCanton, c("canton","mapa_ws")],
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
  
  dfRet
}

# fx_movilidad_canton_mapa("ALAJUELITA", pnZScore = 0, psFecha = "2020-05-03", psHora = 16)
fx_movilidad_canton_mapa = function(psCanton, pnZScore = 0, psFecha = "", psHora = ""){
  #psCanton = "ABANGARES"
  ds_movilidad = readRDS(file.path(sDirDatos,"st_movilidad.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_movilidad$fecha)
  }
  
  # filtra por fecha y canton
  ds_movilidad = ds_movilidad[ds_movilidad$fecha == psFecha & abs(ds_movilidad$z_score) >= pnZScore & (ds_movilidad$canton_origen == psCanton | ds_movilidad$canton_destino == psCanton), c("fecha","hora","z_score","canton_origen","canton_destino","latitud_origen","longitud_origen","latitud_destino","longitud_destino","n_lineabase") ]
  # ds_movilidad = ds_movilidad[ds_movilidad$fecha == psFecha & (ds_movilidad$canton_origen == psCanton | ds_movilidad$canton_destino == psCanton), c("fecha","hora","z_score","canton_origen","canton_destino","latitud_origen","longitud_origen","latitud_destino","longitud_destino","n_lineabase") ]
  
  # filtra por la hora
  if (psHora == ""){
    psHora = max(ds_movilidad$hora)
  } else {
    #psHora = 24
    psHora = as.numeric(psHora)-8
    psHora = paste0(ifelse(psHora <= 8, "0", ""),psHora,":00")
  }
  
  ds_movilidad = ds_movilidad[ds_movilidad$hora == psHora, ]
  
  ds_movilidad$z_score_sube = ifelse(ds_movilidad$z_score>0, ds_movilidad$z_score^2, -1)
  
  ds_movilidad$z_score_baja = ifelse(ds_movilidad$z_score<0, ds_movilidad$z_score^2, -1) 
  
  # ds_movilidad$z_score_cuadrado = 2 * (ds_movilidad$z_score ^ 2)
  
  ds_movilidad[ ds_movilidad$canton_origen != ds_movilidad$canton_destino, c("fecha","hora", "z_score","z_score_sube","z_score_baja","canton_origen","canton_destino","latitud_origen","longitud_origen","latitud_destino","longitud_destino")]
}

fx_cantones_covid = function(psFecha = ""){
  
  ds_contagios = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagios$fecha)
  }
  
  ds_contagios = ds_contagios[ ds_contagios$fecha == psFecha, c("canton")]
  
  ds_contagios[order(ds_contagios)]
}

fx_diacovid_crc = function(psFecha = ""){
  ds_contagiospais = readRDS(file.path(sDirDatos,"st_contagiopais.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagiospais$fecha)
  }
  
  ds_contagiospais[ ds_contagiospais$fecha == psFecha , c( "dia_covid19", "fecha")]
}


fx_historico_variable_pais = function(psVariable, psFecha = "", pnDias = 7){
  ds_contagiospais = readRDS(file.path(sDirDatos,"st_contagiopais.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagiospais$fecha)
  }
  psInicio = as.Date(psFecha) - pnDias
  
  ds_contagiospais[ ds_contagiospais$fecha > psInicio & ds_contagiospais$fecha <= psFecha , 
                    union(c( "dia_covid19", "fecha"),psVariable)]
}


fx_corte_status_pais = function(psFecha = ""){
  
  ds_contagiospais = readRDS(file.path(sDirDatos,"st_contagiopais.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagiospais$fecha)
  }
  
  ds_contagiospais[ ds_contagiospais$fecha == psFecha, 
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
                       "salon_nuevos","uci_nuevos") ]
}


fx_corte_status_pais_acumulado = function(psFecha = "") {
  
  ds_contagiospais = readRDS(file.path(sDirDatos,"st_contagiopais.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagiospais$fecha)
  }
  
  ds_contagiospais[ ds_contagiospais$fecha <= psFecha, 
                    c( "dia_covid19", "fecha", 
                       "positivos","recuperados","fallecidos",
                       "positivos_nuevos","recuperados_nuevos","fallecidos_nuevos", 
                       "hospitalizados","salon","uci",
                       "hospitalizados_nuevos","salon_nuevos","uci_nuevos") ]
}


fx_corte_status_pais_mapa = function(psFecha = "", pnAcumula = 0) {
  
  ds_contagioscanton = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagioscanton$fecha)
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
  dfRet
}
