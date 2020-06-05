library(mapdeck)

mapaMovilidadCanton = function(datos, variable, mapId){
  mapdeck(
    style = mapdeck_style("dark"),
    pitch = 10,
    token="pk.eyJ1IjoibWlub3Jib25pbGxhZ29tZXoiLCJhIjoiY2s5cGF4dzN4MDk2MjNkb2RxbjNrcDZ2aiJ9.fSjAKiPHJyCbtkD6u7hRvA"
  ) %>%
  mapdeck_update(map_id = mapId) %>%
  clear_path(layer_id = "arc_layer") %>%
  add_animated_arc(
    data = datos
    , layer_id =     "arc_layer"
    , origin =       c("longitud_origen", "latitud_origen")
    , destination =  c("longitud_destino", "latitud_destino")
    , stroke_from =  "canton_origen"
    , stroke_to =    "canton_destino"
    , stroke_width = variable
    , tooltip = "Info"
    , palette = "magma"
    , auto_highlight = TRUE
    , highlight_colour = "#AAFFFFFF"
    , frequency = 1
    , trail_length = 0.3
    , animation_speed = 0.1
  )
}