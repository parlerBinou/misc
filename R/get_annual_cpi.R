library(httr)
library(jsonlite)
library(tidyverse)

get_annual_cpi <- function(base_year = 2018,
                           n_periods = 10) {
  # Download annual CPI from Statistics Canada
  # Using Statistics Canada Web Data Service
  # https://www.statcan.gc.ca/eng/developers/wds/user-guide
  
  # Download Vector 41693271:
  # Consumer Price Index, annual average, not seasonally adjusted
  # Canada, All-items
  url <-
    "https://www150.statcan.gc.ca/t1/wds/rest/getDataFromVectorsAndLatestNPeriods"
  req <- POST(url,
              content_type('application/json'),
              body = toJSON(data.frame(
                vectorId = 41693271,
                latestN = n_periods
              )))
  
  response <- content(req)[[1]]
  
  resp_list <- response$object$vectorDataPoint
  as.data.frame(bind_rows(resp_list))
  
  cpi <- as.data.frame(lapply(fromJSON(
    toJSON(response$object$vectorDataPoint)
  ),
  unlist),
  stringsAsFactors = FALSE) %>%
    mutate(REF_DATE = as.integer(str_sub(refPer, 1, 4))) %>%
    select(REF_DATE, value)
  
  # normalize it to base_year value.
  base_value <- cpi %>% filter(REF_DATE == base_year) %>% .$value
  cpi <- cpi %>%
    mutate(normalized = value / base_value)
  
  return(cpi)
}
