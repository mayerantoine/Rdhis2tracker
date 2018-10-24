

## minimum users privileges to use the package
## how to handle paging
## timeout 504

#query("api/trackedEntityInstances?ouMode=ALL&program=ybHHvBdo1ke&links=false&paging=false")

#' @title Retrieve entities data for a specific program
#'
#' @param program_name program name to retreive the data
#' @param program_id  uid of the program to retreive the data
#' @param ou  organisation unit uid of which you want to retreive the data
#' @export
get_program_tracked_entities_data <- function(program_name = NULL,
                                              program_id = NULL,
                                              ou = NULL)
  {

  if (is.null(program_id) && is.null(program_name)) {
      stop("You must provide the  program id or the program name ")
   }
  if(is.null(program_id)) { program_id <- get_program_id(program_name)}

  ouMode <-  "ALL"
  url <-
    paste0("api/trackedEntityInstances?ouMode=",
           ouMode,
           "&program=",
           program_id,
           "&links=false&paging=true")
  if (!is.null(ou)) {
    url <-
      paste0("api/trackedEntityInstances?ou=",
             ou,
             "&program=",
              program_id,
             "&links=false&paging=false")

  }


  tei <- query(url_params = url)

  #if tei lenght is 0 or NULL

  df_tei <- map_df(tei$trackedEntityInstances, function(x) {
    df_attr <-  map_df(x$attributes, `[`, c("displayName", "value")) %>%
      mutate(
        orgUnit = x$orgUnit,
        trackedEntityInstanceID = x$trackedEntityInstance
      )

  })

  orgUnits <- get_program_orgunits(program_id = program_id)

  df_tei <- df_tei %>%
    left_join(orgUnits, by = c("orgUnit" = "id")) %>%
    select(trackedEntityInstanceID,name,displayName,value)

  return(df_tei)

}

#query("/api/events?fields=storedBy,dataValues,trackedEntityInstance,status,orgUnitName,orgUnit,programStage&program=ybHHvBdo1ke&links=false&paging=false")


#' @title Retrieve events data for a specific program
#' @param program_name program name to retreive the data
#' @param program_id  uid of the program to retreive the data
#' @param ou  organisation unit uid of which you want to retreive the data
#' @export
get_program_events_data <- function(program_name = NULL,
                                    program_id = NULL,
                                    ou = NULL) {

  if (is.null(program_id) && is.null(program_name)) {
      stop("You must provide the  program id or the program name ")
  }

 if(is.null(program_id)) { program_id <- get_program_id(program_name)}

  program_id <- get_program_id(program_name)

  url <-
    paste0(
      "api/events?fields=storedBy,dataValues,trackedEntityInstance,status,",
      "orgUnitName,orgUnit,programStage&program=",program_id,"&links=false&paging=true")

  if (!is.null(ou)) {
    url <-
      paste0(
        "api/events?fields=storedBy,dataValues,",
        "trackedEntityInstance,status,orgUnitName,orgUnit,programStage&orgUnit=",
        ou,
        "&program=",
        program_id,
        "&links=false")
  }

  events <- query(url_params = url)
  all_DE <- get_program_data_elements(program_id = program_id)

  df_events <- map_df(events$events, function(x) {
    df_dataElement <-  map_df(x$dataValues, `[`, c("dataElement", "value","created"))

    if(nrow(df_dataElement) > 0 ) {

    df_dataElement <- df_dataElement %>%
      mutate(
        programStage = x$programStage,
        trackedEntityInstanceID = x$trackedEntityInstance,
        orgUnitName = x$orgUnitName,
        status = x$status
      )
    }

    df_dataElement

  }) %>%
  left_join(all_DE,by=c("dataElement" = "id")) %>%
  select(trackedEntityInstanceID,orgUnitName,name,value,programStage,created,status)

  return(df_events)

}
