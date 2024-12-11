.PATHDB_TCIA_URL <- "https://pathdb.cancerimagingarchive.net"

#' @param camic_id `character(1)` The CAMIC ID obtained from the 'TCIA
#'   Histopathology Custom Dataset Builder.json' file.
#'
#' @examples
#' download_svs("311781")
#'
#' @export
download_svs <- function(camic_id, destdir = tempdir()) {
    resp <- request("https://pathdb.cancerimagingarchive.net/") |>
        req_template("node/{camic_id}?_format=json") |>
        req_perform() |>
        resp_body_json()
    svs_url <- resp[["field_wsiimage"]][[1L]]$url

    file_content <- request(svs_url) |>
        req_perform() |>
        resp_body_raw()

    ## TODO: check if image is already in the folder

    outfile <- file.path(destdir, basename(svs_url))
    writeBin(file_content, outfile)
    outfile
}

