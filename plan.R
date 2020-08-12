## Load scripts
source("packages.R") # load libraries
source("email_functions.R") # parsing and email functions
source("scraper_functions.R") # site scraping functions
source("vars.R") # headers, css, urls

## NOTE: YOU NEED TO CALL THIS THE FIRST TIME ---
gm_auth_configure()

## drake pipeline ----
plan <- drake_plan(
  inj = get_raw_data(
    url = web_url,
    headers = headers,
    params = params,
    cookies = mk_cookie()
  ) %>%
    get_injuries_pipeline() %>%
    dplyr::filter(date > Sys.Date() - 2),
  email = send_email_pipeline(
    send_to = to,
    send_from = from,
    subject = subj,
    body = gen_body_content(
      "Update",
      css,
      mk_injury_tbl(inj)
    )
  )
)

## call plan ----
make(plan)
