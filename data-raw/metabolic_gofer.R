## code to prepare `metabolic_gofer` dataset goes here

metabolic_gofer <- readr::read_csv("data-raw/gofer.csv") %>%
  dplyr::mutate(sample_population = stringr::str_replace(sample_population, "/| ", "\n"))

usethis::use_data(metabolic_gofer, overwrite = TRUE)
