#' Add WebCola
#'
#' Easily add WebCola JavaScript to your HTML or
#'  use with \link{V8}.
#'
#' @import htmlwidgets
#'
#' @export
cola <- function(message, width = 0, height = 0) {

  # forward options using x
  x = list()

  # create widget
  htmlwidgets::createWidget(
    name = 'cola',
    x,
    width = width,
    height = height,
    package = 'colaR'
  )
}
