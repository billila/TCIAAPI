#' TCIA Viewer Widget
#'
#' Embeds the caMicroscope mini viewer for a given slide ID using an iframe.
#' Requires an active internet connection.
#'
#' @param camic_id Character string or numeric. The slide ID for caMicroscope
#'   (e.g., "311781").
#' @param width Character string. The width of the widget (e.g., "100%",
#'   "800px").
#' @param height Character string. The height of the widget (e.g., "600px",
#'   "80vh").
#' @param elementId Optional character string. An explicit ID for the widget's
#'   root HTML element.
#'
#' @return An HTML widget object.
#'
#' @import htmlwidgets
#' @importFrom BiocBaseUtils isScalarCharacter
#'
#' @examples
#' tcia_viewer("311781")
#'
#' @export
tcia_viewer <- function(
    camic_id,
    width = "100%",
    height = "600px",
    elementId = NULL
) {
    if (!isScalarCharacter(camic_id))
        stop("A valid 'camic_id' must be provided.", call. = FALSE)

    camic_id <- utils::URLencode(camic_id)
    iframe_url <- glue::glue(
        paste0(
            "https://pathdb.cancerimagingarchive.net/",
            "caMicroscope/apps/mini/viewer.html",
            "?mode=pathdb&slideId={camic_id}"
        )
    )

    # Data to be passed to JavaScript
    x <- list(
        url = iframe_url,
        camic_id = camic_id
    )

    # Create the widget
    htmlwidgets::createWidget(
        name = 'tcia_viewer', # This must match the JS binding name
        x,
        width = width,
        height = height,
        package = "TCIAAPI",
        elementId = elementId,
        sizingPolicy = htmlwidgets::sizingPolicy(
            defaultWidth = "100%",
            defaultHeight = "100%", # Let the container define height
            viewer.padding = 0,
            viewer.fill = TRUE, # iframe should fill the widget container
            browser.fill = TRUE # Widget can fill browser page in some contexts
        )
    )
}

#' Shiny bindings for tcia_viewer
#'
#' Output and render functions for using TCIA's caMicroscope Viewer within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a caMicroscopeViewer
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name tcia_viewer-shiny
#'
#' @export
tcia_viewer_output <- function(
    outputId,
    width = '100%',
    height = '600px'
) {
    htmlwidgets::shinyWidgetOutput(
        outputId,
        'tcia_viewer',
        width,
        height,
        package = "TCIAAPI"
    )
}

#' @rdname tcia_viewer-shiny
#' @export
render_tcia_viewer <- function(
    expr,
    env = parent.frame(),
    quoted = FALSE
) {
    if (!quoted) {
        expr <- substitute(expr)
    } # force quoted
    htmlwidgets::shinyRenderWidget(
        expr,
        tcia_viewer_output,
        env,
        quoted = TRUE
    )
}
