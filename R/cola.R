#' Add WebCola
#'
#' Easily add WebCola JavaScript dependencies in your HTML.
#'
#' @import htmlwidgets
#'
#' @export
cola <- function(width = 0, height = 0) {

  # forward options using x
  x <- list()

  # create widget
  htmlwidgets::createWidget(
    name = 'cola',
    x,
    width = width,
    height = height,
    package = 'colaR'
  )
}
