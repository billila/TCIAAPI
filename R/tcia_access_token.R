#' Set API and Obtain Access Token
#'
#' This function sends a request to the TCIA API to obtain an access token.
#'
#' @param username A character string for the username (default: "nbia_guest").
#'
#' @param client_id A character string for the client ID (default: "NBIA").
#'
#' @param grant_type A character string for the grant type (default:
#'   "password").
#'
#' @return A character string containing the access token.
#'
#' @import httr2
#'
#' @examples
#' tcia_access_token() |> httr2::obfuscate()
#'
#' @export
tcia_access_token <- function(
    username = "nbia_guest", client_id = "NBIA", grant_type = "password"
) {
    # Build the request
    response <- request("https://services.cancerimagingarchive.net/") |>
        req_template("nbia-api/oauth/token") |>
        req_body_form(
            username = username, client_id = client_id, grant_type = grant_type
        ) |>
        req_method("POST") |>
        req_perform() |>
        resp_body_json()

    # Check for errors in the response
    if (!is.null(response$error))
      stop("Authentication error: ", response$error)

    # Return the access token
    return(response$access_token)
}
