# Map the studies included in a systematic review.
sys_map <- function(studies_data, latitude,
                    longitude, popup_user=NULL,
                    radius_user=NULL, links_user=NULL,
                    cluster_points=T) {
  if (!is.null(popup_user)) {
    #hacky for loop, should be made vectorized & pretty someday
    popup_string <- ''
    for (popup in popup_user) {
      popup_string = paste0(popup_string, "<strong>", popup, '</strong>: ',
                            studies_data[, popup], "<br/>")
    }
  } else {popup_string <- ""}

  if (!is.null(links_user) & links_user != "None") {
    links_input <- sapply(studies_data[links_user], as.character)
    links = paste0("<strong><a href='", links_input, "'>Link to paper</a></strong>")
  } else {links <- ""}

  if (!is.null(radius_user)) {
    radiusby <- sapply(studies_data[radius_user], as.numeric)
  } else {radiusby <- 1}

  lat_plotted <- as.numeric(unlist(studies_data %>% dplyr::select(latitude)))
  lng_plotted <- as.numeric(unlist(studies_data %>% dplyr::select(longitude)))

  basemap <- leaflet::leaflet(studies_data,
                              options = leafletOptions(minZoom = 2)) %>%
    leaflet::addTiles()

  if (cluster_points == T) {
    map <- basemap %>%
      leaflet::addCircleMarkers(lat = ~lat_plotted, lng = ~lng_plotted,
                                popup = ~paste(popup_string, links),
                                radius = ~as.numeric(radiusby),
                                stroke = FALSE, fillOpacity = 0.5,
                                clusterOptions = markerClusterOptions() )
  } else {
    map <- basemap %>%
      leaflet::addCircleMarkers(lat = ~lat_plotted, lng = ~lng_plotted,
                                popup = ~paste(popup_string, links),
                                radius = ~as.numeric(radiusby * 2),
                                label = ~popup_string %>% lapply(shiny::HTML)
      )
  }

  map
}