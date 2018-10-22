

#' @title Retrieve the program id  of a program in a DHIS2 Tracker instance
#' @export
get_program_id <- function(program_name){

    if (is.null(program_name)) {
      stop("You must provide the program name")
    }

    all_programs <- as.data.frame(get_all_programs())
    #if programname does not exist
    #if all programs is null or error

    if (is.null(all_programs)) {
      stop("No programs found ")
    }


    program_id <- all_programs[all_programs$name == program_name,"id"]

    if(is.null(program_id) || length(program_id) == 0 ) {
       stop(paste("No program found with name :", program_name),call. = FALSE)
    }

    return(program_id)
}


#' @title Retrieve all data elements in a DHIS2 Traker instance
#' @export
get_all_dataelements <- function() {
  dataElements <-
    query(
      "api/dataElements?fields=id,name,domainType&domainType=TRACKER&links=false&paging=false"
    )


  df_dataElements <- map_df(dataElements$dataElements,`[`,c("id","name","domainType"))

  return(df_dataElements)

}

#' @title Retrieve all programs information
#' @export
get_all_programs <- function() {

  programs <- query("api/programs?fields=id,name&links=false&paging=false")

  programs <- map_df(programs$programs,`[`,c("id","name"))

  return(programs)

}


#' @title Retrieve all programs attributes
#' @export
get_program_attributes <-
  function(program_name= NULL, program_id = NULL) {

     if (is.null(program_id) && is.null(program_name)) {
      stop("You should provide the  program id or the program name ")
   }
  if(is.null(program_id)) { program_id <- get_program_id(program_name)}

    url <-
      paste0("api/programs/",
             program_id,
             "?fields=programTrackedEntityAttributes[id,name]")

    program_attributes <- query(url_params = url)

    program_attributes <- map_df(program_attributes$programTrackedEntityAttributes,`[`,c("id","name"))

    return(program_attributes)

  }


#' @title Retrieve the program stages of a specific program
#' @export
get_program_programstages <-
  function(program_name= NULL, program_id = NULL) {

   if (is.null(program_id) && is.null(program_name)) {
      stop("You should provide the  program id or the program name ")
   }
  if(is.null(program_id)) { program_id <- get_program_id(program_name)}
    url <-
      paste0("api/programs/",
             program_id,
             "?fields=programStages[id,name]")

    programstages <- query(url_params = url)
    programstages <-map_df(programstages$programStages,`[`,c("id","name"))

    return(programstages)

  }



#' @title Retrieve all data elements of a specific program
#' @export
get_program_data_elements <- function(
            program_name = NULL,
            program_id = NULL)
  {


   if (is.null(program_id) && is.null(program_name)) {
      stop("You should provide the  program id or the program name ")
   }

  #if programname does not exist

  if(is.null(program_id)) { program_id <- get_program_id(program_name)}
  # get all program stages of program
  stages <- get_program_programstages(program_id = program_id)

  #if null or error

  # get all the dataelements of those stages

  df_stage_DE <- map_df(stages$id, function(x){
    stage_id <- x
    url <- paste0("api/programStages/", stage_id,"?fields=id,name,programStageDataElements[id,dataElement]")
    data_elements <- query(url)

    df_data_elements<- map_df(data_elements$programStageDataElements, function(x){

    return( list(program_stage_name = data_elements$name,
                 programstage_id = stage_id,
                 id = x$dataElement$id))

    })


    return(df_data_elements)
  })


  # get all data element
   DE <- get_all_dataelements()

   # join with stage_DE
   df_stage_DE <- df_stage_DE %>%
                    left_join(DE, by = c("id"="id")) %>%
                      select(id, name)


  return(df_stage_DE)
}



#' @title Retrieve all variaables of a specific program
#' @export
get_program_variables <- function(program_name = NULL, program_id = NULL){

    if (is.null(program_id) && is.null(program_name)) {
      stop("You should provide the program id or the program name")
   }

  #if programname does not exist
  if(is.null(program_id)) { program_id <- get_program_id(program_name)}

  attributes <- get_program_attributes(program_id = program_id)
  data_elements <- get_program_data_elements(program_id = program_id)

  return(bind_rows(data_elements))

}


#query("api/programs/ybHHvBdo1ke.xml?fields=id,name,organisationUnits[id,name]")
#' @title Retrieve all orgs units of a specific program
#' @export
get_program_orgunits <- function(program_name = NULL, program_id = NULL){

    if (is.null(program_id) && is.null(program_name)) {
      stop("You should provide the program id or the program name")
   }

  #if programname does not exist
  if(is.null(program_id)) { program_id <- get_program_id(program_name)}

  url <- paste0("api/programs/",program_id,"?fields=id,name,organisationUnits[id,name]")

  orgUnits <- query(url)
  df_orgUnits <- map_df(orgUnits$organisationUnits,`[`,c("id","name"))

  return(df_orgUnits)

}
