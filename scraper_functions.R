#' Get data from site
#'
#' @param url Site to scrape
#' @param headers HTML headers
#' @param params Query to append to url
#' @param cookies Cookie for site
#'
#' @return Raw HTTP content
#'
#' @noRd
get_raw_data <- function(url, headers, params, cookies) {
  GET(
    url = web_url,
    add_headers(.headers = headers),
    query = params,
    set_cookies(.cookies = cookies),
    config = config(ssl_verifypeer = FALSE)
  )
}

#' Extract content from HTTP or fail gracefully. Pull HTML table from content.
#'
#' @param res HTTP response object
#'
#' @return datatable
#'
#' @noRd
get_content <- function(res) {
  if (res$status_code != 200) {
    cat("Could not access site.", "status code: ", res$status_code)
    break
  } else {
    team_list <- content(res) %>%
      html_table(fill = TRUE, header = FALSE) %>%
      map(as_tibble)
  }

  if (length(team_list) != 30) {
    cat(
      "Missing teams. Data for ",
      length(team_list),
      " teams out of 30."
    )
    break
  }
  team_list
}

#' Extract team names from HTTP response
#'
#' @param res HTTP object
#'
#' @return Character vector
#'
#' @noRd
get_team_names <- function(res) {
  if (res$status_code != 200) {
    cat("Could not access site.", "status code: ", res$status_code)
    break
  } else {
    teams <- content(res) %>%
      rvest::html_nodes("div.sdi-so-title") %>%
      rvest::html_nodes("a") %>%
      rvest::html_text() %>%
      keep(~ stringr::str_detect(.x, ""))
  }

  if (length(teams) != 30) {
    cat(
      "Missing teams. Data for ",
      length(team_list),
      " teams out of 30."
    )
    break
  }
  teams
}

#' Parse raw data to extract injury info
#'
#' @param df dataframe
#' @param team team to filter and clean
#'
#' @return dataframe
#'
#' @noRd
parse_injuries <- function(df, team) {
  df %>%
    filter(X2 != "") %>%
    mutate(
      team = team,
      date = stringr::str_extract(X3, "(\\d{1,2}/\\d{1,2}/\\d{1,2})") %>%
        lubridate::mdy(),
      d = stringr::str_remove(X3, "(\\d{1,2}/\\d{1,2}/\\d{1,2})")
    ) %>%
    tidyr::separate(d, into = c("timeline", "injury"), " - ") %>%
    select(
      team,
      player = X1,
      pos = X2,
      date,
      injury,
      timeline,
      details = X4
    )
}

#' Pass raw data to parse function for each team
#'
#' @param raw dataframe raw injury data
#' @param teams character vector of team names
#'
#' @return dataframe clean table for injury data by team
clean_parsed_df <- function(raw, teams) {
  map2(raw, teams, ~ parse_injuries(.x, .y)) %>%
    bind_rows() %>%
    as_tibble() %>%
    filter(!is.na(injury)) %>%
    arrange(desc(date))
}

#' Pipeline to scrape web page and turn it into a dataframe
#'
#' @param res HTTP response
#'
#' @return dataframe
#'
#' @noRd
get_injuries_pipeline <- function(res) {
  raw_data <- get_content(res)
  teams <- get_team_names(res)
  is_character(teams)
  is_list(raw_data)

  df <- clean_parsed_df(raw_data, teams)
  is_data.frame(df)
  is_equal_to(ncol(df), 7)
  is_greater_than(nrow(df), 30)
  df
}
