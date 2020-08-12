
# site we'll use http://stats.tcpalm.com/baseball/mlb-injuries.aspx

## Email info ----
to <- "you@example.com" # where do you want to send the email to?
from <- "USE A GMAIL ADDRESS" # the "sender's"email. is must gmail.
subj <- mk_subj_line()

## headers ----
headers <- c(
  `Connection` = 'keep-alive',
  `Cache-Control` = 'max-age=0',
  `Upgrade-Insecure-Requests` = '1',
  `User-Agent` = '',
  `Accept` = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
  `Referer` = 'http://stats.tcpalm.com/sports-scores/Baseball-Scores-Matchups.aspx',
  `Accept-Language` = 'en-US,en;q=0.9'
)

## Website payload ----
params = list(`page` = '/data/mlb/injury/injuries.html')

## base url ----
web_url <- 'http://stats.tcpalm.com/baseball/mlb-injuries.aspx'

## CSS for email table ----
css <- '<style type="text/css">
		table {
border-spacing: 0;
cursor: default;
}
table tr * {
padding: 7px;
}

table > thead > tr > th {
border-bottom: 3px solid #525252;
text-transform: lowercase;
}

table > thead > tr > th {
font-size: 14pt;
font-weight: 400;
font-family: "Helvetica", sans-serif;
}

table > tbody > tr:nth-child(odd) {
background-color: #f1f1f1;
}

table > tbody > tr > * {
font-family: "Lucida Console";
font-size: 11pt;
}

table > tbody > tr:hover {
background-color: #FFD670
}
</style>'
