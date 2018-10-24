# Rdhis2tracker
An R Client for DHIS2 Tracker Web API

__Author:__ Mayer Antoine <br/>
__Status:__ in development


### Description
This is a client library for the DHIS2 Web Api. 

The DHIS2 tracker module or app is an integrated module in [DHIS2](https://www.dhis2.org/). The module supports definition of types of entities, which can be tracked through the system, entities can be anything from persons to commodities, e.g drug, person, commodities. <br/>

The R client can be used to retrieve data and metadata about a DHIS2 Tracker instance. we can retreive everything from data elements, program attributes, organisation units,program stages, tracked entity instances, enrollments and Events items.<br/>


Tracker Web API consists of 3 endpoints that have full CRUD (create, read, update, delete) support to manage Tracked entity instance, Enrollment and Event items. <br/>


### Installation

To get the development version :  <br/>

```
  library(devtools)
  install_github("mayerantoine/rdhis2tracker")
```

### Dependencies
* tidyverse
* lubridate
* httr
* jsonlite
* getPass
* purrr 
