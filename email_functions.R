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
             'ASP.NET_SessionId' = '',
             'SERVERID' = '',
             '_ga' = '',
             '_gid' = '',
             'gnt_ub' = '',
             'gnt_sb' = '',
             'gnt_eid' = 'control:out-market',
             '__gads' = '',
             's_cc' = 'true',
             'AMCV_CF4957F555EE9B727F000101%40AdobeOrg' = '',
             '_fbp' = '',
             '_gat' = '',
             'CurrentSelectedDate' = '{date}',
             's_sq' = '',
             'utag_main' = '',
             's_ppvl' = '',
             's_ppv' = '',
             'OptanonConsent' = ''
             ",
    date = today
  ) %>% as.character()
}
