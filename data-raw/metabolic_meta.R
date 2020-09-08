## code to prepare `metabolic_meta` dataset goes here
library(dplyr)

metabolic_meta <- readr::read_csv("data-raw/meta.csv") %>%
  dplyr::mutate(
    population = factor(population, levels = c(
      "Healthy",
      "Overweight/obese",
      "Cardiac Rehabilitation",
      "Metabolic Syndrome",
      "T2D"
    )),
    category_age = factor(category_age, levels = c(
      "< 30 y",
      "30 - 50 y",
      "> 50 y"
    )),
    category_duration = factor(category_duration, levels = c(
      "< 5 weeks",
      "5 - 10 weeks",
      "> 10 weeks"
    )),
    category_men_ratio = factor(category_men_ratio, levels = c(
      "< 0.5",
      "> 0.5"
    ))
  ) %>%
  ## helper to order the category of baseline values in the correct way to show in results and plots
  dplyr::mutate(helper = dplyr::case_when(
    stringr::str_detect(category_bsln, "<") ~ 1,
    stringr::str_detect(category_bsln, "<|>", negate = TRUE) ~ 2,
    TRUE ~ 3
  )) %>%
  dplyr::arrange(endpoint, helper) %>%
  dplyr::mutate(category_bsln = forcats::as_factor(category_bsln)) %>%
  dplyr::select(-helper) %>%
  dplyr::arrange(study)

usethis::use_data(metabolic_meta, overwrite = TRUE)
