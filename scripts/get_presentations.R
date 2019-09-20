library(dplyr)
library(googlesheets)
library(readr)

pre_df <-
  gs_url(
    "https://docs.google.com/spreadsheets/d/1CNU9vaPXlMWoNgoc2b4yBKqIwz12DyYWr-_z5cYeoL0/edit#gid=0",
    verbose = FALSE
  ) %>%
  gs_read(col_types = cols(
    type = col_character(),
    venue = col_character(),
    subtype = col_character(),
    who = col_character(),
    description = col_character(),
    short_name = col_character(),
    slides = col_character(),
    year = col_integer(),
    invited = col_logical(),
    manual = col_logical(),
    start = col_datetime(format = ""),
    end = col_datetime(format = ""),
    abstract = col_character(),
    date = col_character(),
    long_description = col_character(),
    exurl = col_character()
  )) %>%
  arrange(invited, desc(year)) %>%
  mutate(full_name = paste(short_name, year, sep = '_'))

presentations <- lapply(with(pre_df, split(pre_df, seq(nrow(pre_df)))), as.list) %>%
  purrr::set_names(pre_df$full_name) %>%
  rapply(function(x) ifelse(is.na(x),'',x), how = "replace")

presentations[[1]]
# invited <- presentations %>%
#   dplyr::filter(invited == 1)
# presentations <- split(pre_df, seq(nrow(pre_df))) %>%
#   purrr::set_names(pre_df$full_name)

yaml::write_yaml(
  presentations,
  here::here("data", "presentations.yaml"),
  handlers = list(
    Date = function(x)
      as.character(x)
  )
)
