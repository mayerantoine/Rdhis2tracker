
#' @title Execute a Call to the DHIS2 Web Api

query <- function(url_params) {
  if (grepl(x = url_params, pattern = "http"))
  {
    url <- url_params
  }
  else {
    url <- paste0(getOption("baseurl"), url_params)
  }


  #should we use try , timeout other http error
  result <-  GET(url)
  stop_for_status(result)

  if (http_type(result) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  return(content(result, type = "application/json"))

}



#' @title login into the DHIS2 instances
#' @export
loadSecret <- function(secrets=NA) {
  #Load from a file
  #
  #secrets <- read_json("secret2.json")
  if (!is.na(secrets)) {

    s <- read_json(secrets)
  } else {
    s <- list(dhis = list())
    s$dhis$username <- readline("Username: ")
    s$dhis$password <- getPass::getPass()
    s$dhis$baseurl <- readline("Server URL (ends with /): ")
  }

  options("baseurl" = s$dhis$baseurl)
  options("secrets" = secrets)
  url <- URLencode(URL = paste0(getOption("baseurl"), "api/me"))
  #Logging in here will give us a cookie to reuse
  # we need to handle connection error from the server side
  r <- GET(url , authenticate(s$dhis$username, s$dhis$password),
                 timeout(60))
  r <- content(r, mime = "application/json")
  #me <- fromJSON(r)
  options("organisationUnit" = r$organisationUnits)
  #Set the cache time out in days
  options("maxCacheAge" = 7)
}
