accordionItem = function(id, valor, icono, titulo, descripcion, contenido){
  bs_accordion(id = id) %>%
    bs_set_opts(panel_type = "default", use_heading_link = TRUE) %>%
    bs_append(title = shiny::HTML(paste('<div style="border: none; background: none;" class="tile-stats">
                    <div class="icon">
                      <i style="font-size: 40px;" class="',icono,'"></i>
                    </div>
                    <div style="color: #73879C;" class="count">',valor,'</div>
                    <h3>',titulo,'</h3>
                    <p style="color: #73879C;">',descripcion,'</p>
                  </div>')), 
              content = contenido)
}