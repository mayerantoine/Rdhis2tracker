# Rdhis2tracker
An R Client for DHIS2 Tracker Web API

_Author:_ Mayer Antoine <br/>
_Status:_ in developement


### Description
This is a client library for the DHIS2 Web Api. It can be used to retrieve data about a DHIS2 Tracker data and metadata. we can retreive everything from data elements, program attributes, organisation units,program stages, Tracked entity instance, Enrollment and Event items.<br/>

The DHIS2 tracker module or app is an integrated module in DHIS2. The module supports definition of types of entities, which can be tracked through the system, which can be anything from persons to commodities, e.g drug, person, commodities. <br/>


Tracker Web API consists of 3 endpoints that have full CRUD (create, read, update, delete) support to manage Tracked entity instance, Enrollment and Event items. 


### Installation

To get the development version : 

  library(devtools)
  install_github("mayerantoine/rdhis2tracker")


### Dependencies
* tidyverse
* lubridate
* httr
* jsonlite
* getPass
* purrr 
