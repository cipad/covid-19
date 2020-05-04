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
  dfRet
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





fx_historico_variable_pais("positivos_nuevos")
fx_historico_variable_pais(c("positivos_nuevos","recuperados_nuevos"),psFecha = "2020-04-18" ,pnDias = 10 )


install.packages("fst", dependencies = TRUE)
x = data.frame(installed.packages())
x[x$Package=="fst",c("Package","Version","Built")]


sArchivo = "st_contagiopais"
yArch = readRDS(file.path(sDirDatos,paste0(sArchivo,".rds")) )
fst::write.fst(x=yArch, path = file.path(sDirDatos,paste(sArchivo,".fst")) )

xArch = fst::read.fst(  path = file.path(sDirDatos,paste(sArchivo,".fst")) )
identical(xArch, yArch)
class(xArch)
class(yArch)
nrow(xArch)
nrow(yArch)
head(yArch)
