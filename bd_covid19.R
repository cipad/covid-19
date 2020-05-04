sDirDatos = ifelse(Sys.info()["sysname"] == "Linux","./inputdata","c:\\Temporal\\CV19\\inputdata\\")


fx_cantones_covid = function(psFecha = ""){
  
  ds_contagios = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagios$fecha)
  }
  
  ds_contagios = ds_contagios[ ds_contagios$fecha == psFecha, c("canton")]
  
  ds_contagios[order(ds_contagios)]
  
}



fx_diacovid_crc = function(psFecha = ""){
  
  ds_contagiospais = readRDS(file.path(sDirDatos,"st_contagiocanton.rds"))
  
  if (psFecha == "") {
    psFecha = max(ds_contagiospais$fecha)
  }
  
  ds_contagiospais[ ds_contagiospais$fecha == psFecha , c( "dia_covid19", "fecha")]
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
                       "positivos_adultos", "positivos_adulto_mayor", "positivos_menor",
                       "positivos_extranjero", "positivos_local", "positivos_investigacion",
                       "recuperados",
                       "recuperados_masculino", "recuperados_femenino",
                       "recuperados_adulto", "recuperados_adulto_mayor", "recuperados_menor",
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
