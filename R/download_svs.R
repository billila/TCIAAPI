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
#' @returns * `download_svs`: The path to the downloaded file
#'  * `svs_info`: A list containing the metadata of the SVS image
#'
#' @examples
#' if (interactive()) {
#'     svs_info("311781")
#'     download_svs("311781")
#'     download_svs(311781:311783)
#' }
#' @export
download_svs <- function(camic_ids, destdir = tempdir()) {
    svs_urls <- vapply(camic_ids, function(camic_id) {
        svs_info(camic_id)$field_wsiimage[[1L]][["url"]]
    }, character(1L))

    resps <- lapply(svs_urls, request) |>
        req_perform_parallel()

    lapply(resps, .write_svs, destdir)
}

#' @rdname download_svs
#'
#' @param camic_id `character(1)` A single CAMIC ID.
#'
#' @export
svs_info <- function(camic_id) {
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
