# Aquire data----
if(!dir.exists(file.path("data", "mp01"))){
  dir.create(file.path("data", "mp01"), showWarnings=FALSE, recursive=TRUE)
}

GLOBAL_TOP_10_FILENAME <- file.path("data", "mp01", "global_top10_alltime.csv")

if(!file.exists(GLOBAL_TOP_10_FILENAME)){
  download.file("https://www.netflix.com/tudum/top10/data/all-weeks-global.tsv", 
                destfile=GLOBAL_TOP_10_FILENAME)
}

COUNTRY_TOP_10_FILENAME <- file.path("data", "mp01", "country_top10_alltime.csv")

if(!file.exists(COUNTRY_TOP_10_FILENAME)){
  download.file("https://www.netflix.com/tudum/top10/data/all-weeks-countries.tsv", 
                destfile=COUNTRY_TOP_10_FILENAME)
}

# Read Data----
library(readr)
library(dplyr)
GLOBAL_TOP_10 <- read_tsv(GLOBAL_TOP_10_FILENAME)
COUNTRY_TOP_10 <- read_tsv(COUNTRY_TOP_10_FILENAME,na="N/A")
# Workflow----

#Original data
View(GLOBAL_TOP_10)
View(COUNTRY_TOP_10)
glimpse(COUNTRY_TOP_10)
# Make Na values proper
GLOBAL_TOP_10 <- GLOBAL_TOP_10 |>
  mutate(season_title = if_else(season_title == "N/A", NA_character_, season_title))

# Initial Data Exploration
library(DT)
GLOBAL_TOP_10 |> 
  slice_sample(n=20) |>
  datatable(options=list(searching=FALSE, info=FALSE))

library(stringr)
format_titles <- function(df){
  colnames(df) <- str_replace_all(colnames(df), "_", " ") |> str_to_title()
  df
}

GLOBAL_TOP_10 |> 
  format_titles() |>
  head(n=20) |>
  datatable(options=list(searching=FALSE, info=FALSE)) |>
  formatRound(c('Weekly Hours Viewed', 'Weekly Views'))

GLOBAL_TOP_10 |> 
  mutate(`runtime_(minutes)` = round(60 * runtime)) |>
  select(-season_title, 
         -runtime) |>
  format_titles() |>
  head(n=20) |>
  datatable(options=list(searching=FALSE, info=FALSE)) |>
  formatRound(c('Weekly Hours Viewed', 'Weekly Views'))


# Workflow for Task 4 ----

n_distinct(COUNTRY_TOP_10$country_name)
n_distinct(COUNTRY_TOP_10$country_iso2)
unique(is.na(COUNTRY_TOP_10$country_iso2))
