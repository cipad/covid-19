sDirDatos = ifelse(Sys.info()["sysname"] == "Linux","./inputdata/","c:\\Temporal\\CV19\\inputdata\\")


fx_corte_status_canton = function(psCanton, psFecha = ""){
  ds_contagios = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  ds_cantones = readRDS(file.path(sDirDatos,"integradocantonal.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagios$fecha)
  }

  dfRet = merge( ds_contagios[ds_contagios$fecha == psFecha & ds_contagios$canton == psCanton,],
                 ds_cantones[ds_cantones$canton == psCanton, c("canton","ids_2017", "poblacion", "tasa_mortalidad", "tasa_natalidad", "tasa_nupcialidad")],
                 by = c("canton"),
                 all.x = TRUE
          )
  
  dfRet$tasa_contagio = dfRet$positivos / dfRet$poblacion
  #dfRet$tasa_densidad_contagio = dfRet$positivos / dfRet$extension
   
  dfRet
}

#fx_historico_movilidad_canton("ATENAS")
# fx_historico_movilidad_canton = function(psCanton, psDireccion = "S", psFecha = ""){
# 
#   ds_movilidad = readRDS(file.path(sDirDatos,"st_movilidad.rds"))
# 
#   if (psFecha == "") {
#     psFecha = max(ds_movilidad$fecha)
#   }
#   
#   ds_movilidad = ds_movilidad[ds_movilidad$fecha <= psFecha & (ds_movilidad$canton_origen == psCanton | ds_movilidad$canton_destino == psCanton), c("fecha","hora","delta","z_score","canton_origen", "canton_destino") ]
# 
#   ds_movilidad$direccion = ifelse(ds_movilidad$canton_origen == psCanton,"S","E")
# 
#   ds_movilidad[ds_movilidad$direccion == psDireccion, c("fecha","hora","delta","z_score")]
# }


#fx_historico_movilidad_canton_mapa("ATENAS")
fx_historico_movilidad_canton_mapa = function(psCanton, psFecha = "", psHora = ""){
  
  ds_movilidad = readRDS(file.path(sDirDatos,"st_movilidad.rds"))

  if (psFecha == "") {
    psFecha = max(ds_movilidad$fecha)
  }
  
  # filtra por fecha y canton
  ds_movilidad = ds_movilidad[ds_movilidad$fecha == psFecha & (ds_movilidad$canton_origen == psCanton | ds_movilidad$canton_destino == psCanton), c("fecha","hora","z_score","canton_origen","canton_destino","latitud_origen","longitud_origen","latitud_destino","longitud_destino","n_lineabase") ]
  
  # filtra por la hora
  ds_movilidad = ds_movilidad[ds_movilidad$hora == ifelse(psHora=="",max(ds_movilidad$hora),psHora), ]

  
  ds_movilidad$z_score_sube = ds_movilidad$z_score
  
  ds_movilidad$z_score_baja = ds_movilidad$z_score * -1

  ds_movilidad$z_score_cuadrado = 2 * (ds_movilidad$z_score ^ 2)

  ds_movilidad[ ds_movilidad$canton_origen != ds_movilidad$canton_destino, c("fecha","hora","z_score_sube","z_score_baja","z_score_cuadrado","canton_origen","canton_destino","latitud_origen","longitud_origen","latitud_destino","longitud_destino")]
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
    psFecha = max(ds_contagios$fecha)
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


fx_corte_status_pais_mapa = function(psFecha = "") {
  
  ds_contagioscanton = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagioscanton$fecha)
  }

  ds_contagioscanton[ ds_contagioscanton$fecha == psFecha, 
                    c( "fecha", 
                       "positivos","recuperados","fallecidos","activos",
                       "latitud","longitud") ]
}
