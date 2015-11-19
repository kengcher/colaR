#' Add d3
#'
#' Easily add d3 JavaScript dependencies in your HTML.
#'
#' @import htmlwidgets
#'
#' @export
d3 <- function(width = 0, height = 0) {
  
  # forward options using x
  x <- list()
  
  # create widget
  htmlwidgets::createWidget(
    name = 'd3',
    x,
    width = width,
    height = height,
    package = 'colaR'
  )
}
