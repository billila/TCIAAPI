.TCIA_SERVICES_URL <- "https://services.cancerimagingarchive.net/"

.tcia_access_token_new <- function(username, client_id, grant_type) {
    resp <- request(.TCIA_SERVICES_URL) |>
        req_template("nbia-api/oauth/token") |>
        req_body_form(
            username = username, client_id = client_id, grant_type = grant_type
        ) |>
        req_perform() |>
        resp_body_json()
    resp[["created"]] <- Sys.time()
    resp
}

.t_diff_secs <- function(t1, t2) {
    as.numeric(difftime(t1, t2, units = "secs"))
}

#' Set API and Obtain Access Token
#'
#' This function sends a request to the TCIA API to obtain an access token.
#'
#' @param username `character(1)` The username (default: "nbia_guest").
#'
#' @param client_id `character(1)` The client ID (default: "NBIA").
#'
#' @param grant_type `character(1)` The grant type (default: "password").
#'
#' @param response `logical(1)` Whether to return the actual response (default:
#'   `FALSE`).
#'
#' @return A character string containing the access token.
#'
#' @import httr2
#'
#' @examples
#' tcia_access_token() |> httr2::obfuscate()
#'
#' @export
tcia_access_token <- local({
    tokens <- new.env(parent = emptyenv())
    function(
        username = "nbia_guest", client_id = "NBIA", grant_type = "password",
        response = FALSE
    ) {
        key <- paste(username, client_id, grant_type, sep = ":")
        now <- Sys.time()

        if (is.null(tokens[[key]])) {
            tokens[[key]] <- .tcia_access_token_new(
                username = username,
                client_id = client_id,
                grant_type = grant_type
            )
        } else {
            expires_in <-
                tokens[[key]]$expires_in -
                    .t_diff_secs(now, tokens[[key]]$created)
            if (expires_in < 1L) {
                if (expires_in > 0L)
                    Sys.sleep(expires_in)
                tokens[[key]] <- .tcia_access_token_new(
                    username = username,
                    client_id = client_id,
                    grant_type = grant_type
                )
            }
        }
        if (meta)
            tokens[[key]]
        else
            tokens[[key]]$id_token
  }
})

#' @rdname tcia_access_token
#'
#' @examples
#' tcia_token_expires()
#' @export
tcia_token_expires <- function(
    username = "nbia_guest", client_id = "NBIA", grant_type = "password"
) {
    token <- tcia_access_token(
        username = username, client_id = client_id, grant_type = grant_type,
        response = TRUE
    )
    expires <- token$created + token$expires_in
    message("The access token will expire on ", expires)
}
