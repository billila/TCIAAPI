.PATHDB_TCIA_URL <- "https://pathdb.cancerimagingarchive.net"

#' @title Download SVS Images from the Cancer Imaging Archive
#'
#' @description This function downloads SVS images from the Cancer Imaging
#'   Archive (TCIA) using the CAMIC ID obtained from the 'TCIA Histopathology
#'   Custom Dataset Builder.json' file.
#'
#' @details The json file can be obtained by navigating to the TCIA website
#'   <https://www.cancerimagingarchive.net/> under 'Access The Data' > 'Search
#'   Histopathology Portal' and clicking on the 'TCIA Histopathology Custom
#'   Dataset Builder' link.
#'
#' @param camic_ids `character()` A vector of CAMIC IDs obtained from the 'TCIA
#'   Histopathology Custom Dataset Builder.json' file.
#'
#' @param destdir `character(1)` The destination directory where the SVS images
#'   will be saved. The default is `tempdir()`.
#'
#' @returns * `tcia_svs_download`: The path to the downloaded file
#'  * `tcia_svs_info`: A list containing the metadata of the SVS image
#'
#' @examples
#' if (interactive()) {
#'     tcia_svs_info("311781")
#'     tcia_svs_download("311781")
#'     tcia_svs_download(311781:311783)
#' }
#' @export
tcia_svs_download <- function(camic_ids, destdir = tempdir()) {
    svs_urls <- vapply(camic_ids, function(camic_id) {
        tcia_svs_info(camic_id)$field_wsiimage[[1L]][["url"]]
    }, character(1L))

    resps <- lapply(svs_urls, request) |>
        req_perform_parallel()

    ## TODO: check if file exists then download if not in destdir
    ##  force = TRUE to overwrite existing files
    vapply(resps, .write_svs, character(1L), destdir)
}

#' @rdname tcia_svs_download
#'
#' @param camic_id `character(1)` A single CAMIC ID.
#'
#' @export
tcia_svs_info <- function(camic_id) {
    if (!is.character(camic_id))
        camic_id <- as.character(camic_id)
    request(.PATHDB_TCIA_URL) |>
        req_template("node/{camic_id}?_format=json") |>
        req_perform() |>
        resp_body_json()
}

.write_svs <- function(resp, destdir) {
    bin_raw <- resp_body_raw(resp)
    outfile <-
        file.path(destdir, basename(resp_url(resp)))
    if (file.exists(outfile))
        warning("Overwriting existing file: ", outfile)
    writeBin(bin_raw, outfile)
    outfile
}
