
# `gmailr` MLB Injury Example

<!-- badges: start -->
<!-- badges: end -->

This project is a demo to show how to use `gmailr` and `cronR`.

## Project Details

There's six R scripts.

1. `vars.R` - Constants like HTML headers, email details, urls, etc.
2. `packages.R` - Libraries to load.
3. `scraper_functions.R` - Functions to access, scrape, and reshape MLB injury data.
4. `email_functions.R` - Functions to create an email using the data from `scraper_functions.R`. The email pipeline uses the `gmailr` package.
5. `plan.R` - Pipeline that puts everything together. The webscraper and email and wrapped inside a `drake` pipeline.
6. `cron_job.R` - Schedule and run a cron job that calls the pipeline `plan.R` script using the `cronR` package.

## Notes

- This set of scripts will not work out of the box. You need to get header and cookie data from the site. The site we're using for the injury data is at the top of the `vars.R` script. Go to that site in a webbrowser and then follow the instruction [on this page](https://curl.trillworks.com/) to extract the header and cookie info. Then paste it into the text input field on the left. Change the language to R. Copy the transformed header and cookie output and paste it in the proper locations. The cookie data goes in the `mk_cookie` function in the `email_functions.R` file. You could just assign it to a variable and use it but if you plan on using the scripts for anything more than a couple of days you need to update the dates in your cookie. The function does that. Replace the header info in the `vars.R` file.
- Don't forget to add your emails (to and from) to the `vars.R` script.
- Don't write your own cron settings use the Rstudio addin that comes with the package.
- `drake` is overkill for a project this small but I use it often and it's worth checking out. [The `drake` book has lots of info on use cases and examples.](https://books.ropensci.org/drake/)
- I try to always call a function from its package instead of loading it in the namespace. Example, `dplyr::select` vs `select`. But I wanted to reduce clutter for anyone looking at how the pipeline works. If I decided to use this in production I'd prepend all third functions with their package.
- `data_for_debugging.csv` is a demo dataset to use if you're troubleshooting `gmailr`.

## Important Packages

- [`cronR`](https://github.com/bnosac/cronR)
- [`gmailr`](https://github.com/r-lib/gmailr)
- [`drake`](https://github.com/ropensci/drake)

## Setting up `gmailr`

- [Instructions on setting up your gmail account to work with `gmailr`](https://www.infoworld.com/article/3398701/how-to-send-email-from-r-and-gmail.html)
-[More auth options](https://gargle.r-lib.org/articles/non-interactive-auth.html#provide-an-oauth-token-directly)

