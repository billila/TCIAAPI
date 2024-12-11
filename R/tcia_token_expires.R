#' Function to check when the API expires
#'
#' @description `tcia_token_expires` : report the expiration time of the access token.
#'
#' @return `tcia_token_expires` returns a character string containing the expiration time of the access token.
#'
#' @import httr2
#'
#' @examples
#' tcia_token_expires()
#'
#' @export
tcia_token_expires <- function() {
  token <- tcia_access_token()
  expires_at <- Sys.time() + token$expires_in
  print(paste("The access token will expire on", expires_at))
}
