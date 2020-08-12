library(cronR)
## NOTE: Use the Rstudio Addin instead writing by hand ----

fill_to_run <- here::here('plan.R') # fill to run
cmd <- cron_rscript(fill_to_run) # make cron script


## Run cron job ----
cron_add(cmd, 
         frequency = '0 0/5 * 1/1 * ? *', 
         id='mlb injuries',
         description = 'get mlb injuries')
cron_njobs() # how many jobs are running
cron_clear() # clear job(s)
