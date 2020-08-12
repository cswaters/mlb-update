#' Generate email subject text.
#'
#' @param subj Character vector. The current data is appended after text
#'
#' @return Character vector
mk_subj_line <- function(subj = "MLB injury update for") {
  glue("{subj} {date}", subj = subj, date = get_date()) %>%
    as.character()
}

#' Reformat today's date
#'
#' @noRd
get_date <- function() format(Sys.Date(), "%B, %d")

#' Reformat the time
#'
#' @noRd
get_time <- function() format(Sys.time(), format = "%r")

#' Convert dataframe into the HTML via kable
#'
#' @param df Dataframe
#'
#' @return HTML table
#'
#' @noRd
mk_injury_tbl <- function(df) {
  df %>%
    transmute(date,
      team,
      player = paste0(player, ", ", pos),
      injury,
      timeline,
      details
    ) %>%
    kable() %>%
    collapse_rows(columns = c(1:3)) %>%
    footnote(paste("Generated", get_time()))
}

#' Generate the email body. Needs to be a basic HTML page
#'
#' @param headline H1 tag of email
#' @param css Table css
#' @param tbl HTML table
#'
#' @return HTML page inside a character vector
#'
#' @noRd
gen_body_content <- function(headline, css, tbl) {
  paste0(
    "<!DOCTYPE html><html><head>",
    css,
    "</head><body><div>",
    h1(headline),
    tbl,
    "</div></body></html>"
  )
}

#' Pipeline to send email using `gmailr` functions
#'
#' @param send_to Where the email is going
#' @param send_from The sender. This must be a gmail account.
#' @param subject The email subject line
#' @param body The email body content
#'
#' @return sends email via gmail api
send_email_pipeline <- function(send_to, send_from, subject, body) {
  gm_mime() %>%
    gm_to(send_to) %>% # your email
    gm_from(send_from) %>%
    gm_subject(subject) %>%
    gm_html_body(body) %>%
    send_message()
}

#' Generate a new cookie with today's date
#'
#' @return character
#'
#' @noRd
mk_cookie <- function() {
  today <- format(Sys.Date(), "%m-%d-%Y")
  glue(
    "
             'ASP.NET_SessionId' = 'pvyiqzy4r3u2n4moqdjln1k0',
             'SERVERID' = 'cahfxhstp01',
             '_ga' = 'GA1.2.218768442.1593701573',
             '_gid' = 'GA1.2.586440242.1593701573',
             'gnt_ub' = '68',
             'gnt_sb' = '14',
             'gnt_eid' = 'control:out-market',
             '__gads' = 'ID=cac37400741897ba:T=1593701576:S=ALNI_Ma6itXeWBARrSs6cYcLpXL7Y2sPPg',
             's_cc' = 'true',
             'AMCV_CF4957F555EE9B727F000101%40AdobeOrg' = '1999109931%7CMCMID%7C71673196184519716805613931957866299074%7CMCAID%7CNONE%7CMCAAMLH-1594306384%7C7%7CMCAAMB-1594306388%7Cj8Odv6LonN4r3an7LhD3WZrU1bUpAkFkkiY1ncBR96t2PTI',
             '_fbp' = 'fb.1.1593701589917.1598188292',
             '_gat' = '1',
             'CurrentSelectedDate' = '{date}',
             's_sq' = '%5B%5BB%5D%5D',
             'utag_main' = 'v_id:0173100420dd00005977136ff55803078006207000942$_sn:1$_ss:0$_st:1593703790585$ses_id:1593701572883%3Bexp-session$_pn:6%3Bexp-session',
             's_ppvl' = 'http%253A%2F%2Fstats.tcpalm.com%2Fbaseball%2Fmlb-injuries.aspx%253Fpage%253D%2Fdata%2Fmlb%2Finjury%2Finjuries.html%2C3%2C3%2C360%2C1437%2C344%2C1440%2C900%2C2%2CP',
             's_ppv' = 'http%253A%2F%2Fstats.tcpalm.com%2Fbaseball%2Fmlb-injuries.aspx%253Fpage%253D%2Fdata%2Fmlb%2Finjury%2Finjuries.html%2C3%2C3%2C360%2C1437%2C344%2C1440%2C900%2C2%2CP',
             'OptanonConsent' = 'isIABGlobal=false&datestamp=Thu+Jul+02+2020+10%3A59%3A52+GMT-0400+(Eastern+Daylight+Time)&version=6.1.0&consentId=8469a165-77fb-49b4-8de2-e8a5249850bf&interactionCount=0&landingPath=https%3A%2F%2Fwww.tcpalm.com%2Fservices%2Fcobrand%2Fheader%2F&groups=1%3A1%2C2%3A1%2C3%3A1%2C4%3A1%2C5%3A1&hosts=&legInt='
             ",
    date = today
  ) %>% as.character()
}
