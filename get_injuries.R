## source utils and vars ----
source('web_vars.R')
source('parse_funcs.R')

## libs ----
library(dplyr)


## Scrape data ----
df <-
  get_raw_data(
    url = web_url,
    headers = headers,
    params = params,
    cookies = mk_cookie()) %>% 
  get_injuries_pipeline()

df %>% 
  readr::write_csv('injuries.csv')
