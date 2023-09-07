#' Perform meta-analysis
#'
#' Perform the meta-analysis, sensitivity analysis, and meta-regression on the chosen clinical endpoint.
#'
#' @param endpoint The clinical endpoint to perform the meta-analysis and meta-regression.
#'
#' @return a [tibble][tibble::tibble-package] with named lists.
#' @export
#' 
#' @importFrom stats update
#' @importFrom meta metabind metacont metainf metareg
#' 
#' @examples
#' if (interactive()) {
#' # Perform meta-analysis on VO2max
#' results <- perform_meta(endpoint = "VO2max")
#' results
#'
#' # Access results of Overall meta-analysis
#' results$meta_analysis$Overall
#'
#' # Acess results of Age meta-regression
#' results$meta_regression$Age
#' }
perform_meta <- function(
  endpoint = c(
    "VO2max",
    "Flow-mediated Dilation",
    "BMI",
    "Body Mass",
    "Body Fat",
    "Systolic Blood Pressure",
    "Diastolic Blood Pressure",
    "HDL",
    "LDL",
    "Triglycerides",
    "Total Cholesterol",
    "C-reactive Protein",
    "Fasting Insulin",
    "Fasting Glucose",
    "HbA1c",
    "HOMA-IR"
  )
) {

  current_endpoint <- match.arg(endpoint)

  cli::cli_rule(center = cli::col_red(" * {current_endpoint} meta-analysis * "))

  data_endpoint <- metabolic::metabolic_meta %>%
    dplyr::filter(endpoint == current_endpoint) %>%
    ## create dummy column to be used later on when plotting the population meta-regression
    dplyr::mutate(population_regression = as.integer(population))

  ## the following is needed simply to show the results on the correct side of the forest plot
  desired_effect <- unique(data_endpoint$desired_effect)

  usethis::ui_done(usethis::ui_value("Overall"))
  usethis::ui_done(usethis::ui_field("      \u2514\u2500 Performing meta-analysis"))

  # overall
  if(desired_effect == "increase") {
    m0 <- metacont(
      n.e = N_HIIE,
      mean.e = Mean_HIIE,
      sd.e = SD_HIIE,
      n.c = N_MICT,
      mean.c = Mean_MICT,
      sd.c = SD_MICT,
      studlab = study,
      data = data_endpoint,
      sm = "SMD",
      method.smd = "Cohen",
      print.byvar = FALSE,
      warn = FALSE
    )
  } else {
    m0 <- metacont(
      n.e = N_MICT,
      mean.e = Mean_MICT,
      sd.e = SD_MICT,
      n.c = N_HIIE,
      mean.c = Mean_HIIE,
      sd.c = SD_HIIE,
      studlab = study,
      data = data_endpoint,
      sm = "SMD",
      method.smd = "Cohen",
      print.byvar = FALSE,
      warn = FALSE
    )
  }

  # sensitivity analysis

  usethis::ui_done(usethis::ui_field("      \u2514\u2500 Performing sensitivity analysis"))

  out_sensitivity <- metainf(x = m0, pooled = "random")

  ## detect whether meta-analysis is being influenced by a single study
  ## if so, remove the study from the overall results

  influence_study <- detect_sensitivity(out_sensitivity)

  if(is.na(influence_study)) {
    usethis::ui_done(usethis::ui_field("               \u2514\u2500 Meta-analysis results are robust! Keep going!"))
  } else {
    usethis::ui_info(usethis::ui_field("               \u2514\u2500 Meta-analysis results are being influenced by a single study: {usethis::ui_value(influence_study)}"))
    usethis::ui_done(usethis::ui_field("               \u2514\u2500 Excluding {usethis::ui_value(influence_study)} from {usethis::ui_value('Overall')} meta-analysis"))

    usethis::ui_done(usethis::ui_field("      \u2514\u2500 Performing meta-analysis again"))
    ## this is actually going to be done at the end of this function so the subgroups still use this study
  }

  # population -----------------------------

  name <- "Population"
  cli::cli_alert_success("Performing meta-analysis and meta-regression on the {.field {name}} subgroup")

  ## meta-analysis
  m1 <- update(object = m0, byvar = population, print.byvar = FALSE, warn = FALSE)
  ## meta-regression
  ### supress warning from metafor package
  ### this can actually be ignored (https://stats.stackexchange.com/questions/223918/multilevel-metaregression-in-r-redundant-predictors-dropped-metafor)
  reg1 <- suppressWarnings(metareg(x = m1))

  # age ------------------------------------

  name <- "Age"
  cli::cli_alert_success("Performing meta-analysis and meta-regression on the {.field {name}} subgroup")

  ## meta-analysis
  m2 <- update(object = m0, byvar = category_age, print.byvar = FALSE, warn = FALSE)
  ## meta-regression
  reg2 <- metareg(x = m2, formula = age)

  # training duration -----------------------

  name <- "Training Duration"
  cli::cli_alert_success("Performing meta-analysis and meta-regression on the {.field {name}} subgroup")

  ## meta-analysis
  m3 <- update(object = m0, byvar = category_duration, print.byvar = FALSE, warn = FALSE)
  ## meta-regression
  reg3 <- metareg(x = m3, formula = duration)

  # men ratio --------------------------------

  name <- "Men Ratio"
  cli::cli_alert_success("Performing meta-analysis and meta-regression on the {.field {name}} subgroup")

  ## meta-analysis
  m4 <- update(object = m0, byvar = category_men_ratio, print.byvar = FALSE, warn = FALSE)
  ## meta-regression
  reg4 <- metareg(x = m4, formula = men_ratio)

  # type of exercise --------------------------

  name <- "Type of Exercise"
  cli::cli_alert_success("Performing meta-analysis and meta-regression on the {.field {name}} subgroup")

  ## meta-analysis
  m5 <- update(object = m0, byvar = type_exercise, print.byvar = FALSE, warn = FALSE)
  ## meta-regression
  reg5 <- metareg(x = m5, formula = type_exercise)

  # baseline -----------------------------------

  name <- "Baseline"
  cli::cli_alert_success("Performing meta-analysis and meta-regression on the {.field {name}} subgroup")

  ## meta-analysis
  m6 <- update(object = m0, byvar = category_bsln, print.byvar = FALSE, warn = FALSE)
  reg6 <- metareg(x = m6, formula = bsln_adjusted)

  if(current_endpoint != "Flow-mediated Dilation") {

    # type of HIIE ----------------------

    name <- "Type of HIIE"
    cli::cli_alert_success("Performing meta-analysis and meta-regression on the {.field {name}} subgroup")

    ## meta-analysis
    m7 <- update(object = m0, byvar = HIIE, print.byvar = FALSE, warn = FALSE)
    ## meta-regression
    reg7 <- metareg(x = m7, formula = HIIE)
  } else {
    m7 <- NA
    reg7 <- NA
  }

  ## perform now again the overall meta-analysis if influenced by a single study
  if(!is.na(influence_study)) {
    ## filter out study
    data_endpoint_robust <- data_endpoint %>%
      dplyr::filter(study != influence_study)

    # overall
    if(desired_effect == "increase") {
      m0 <- metacont(
        n.e = N_HIIE,
        mean.e = Mean_HIIE,
        sd.e = SD_HIIE,
        n.c = N_MICT,
        mean.c = Mean_MICT,
        sd.c = SD_MICT,
        studlab = study,
        data = data_endpoint_robust,
        sm = "SMD",
        method.smd = "Cohen",
        print.byvar = FALSE,
        warn = FALSE
      )
    } else {
      m0 <- metacont(
        n.e = N_MICT,
        mean.e = Mean_MICT,
        sd.e = SD_MICT,
        n.c = N_HIIE,
        mean.c = Mean_HIIE,
        sd.c = SD_HIIE,
        studlab = study,
        data = data_endpoint_robust,
        sm = "SMD",
        method.smd = "Cohen",
        print.byvar = FALSE,
        warn = FALSE
      )
    }
  }

  # return all the models
  out <- dplyr::tibble(
    subgroup = c(
      "Overall",
      "Population",
      "Age",
      "Training Duration",
      "Men Ratio",
      "Type of Exercise",
      "Baseline Values",
      "Type of HIIE"
    ),
    meta_analysis = list(m0, m1, m2, m3, m4, m5, m6, m7),
    sensitivity_analysis = list(out_sensitivity, NA, NA, NA, NA, NA, NA, NA),
    meta_regression = list(NA, reg1, reg2, reg3, reg4, reg5, reg6, reg7)
  )

  names(out$meta_analysis) <- out$subgroup
  names(out$sensitivity_analysis) <- out$subgroup
  names(out$meta_regression) <- out$subgroup

  cli::cli_rule(center = cli::col_blue(" * DONE * "))

  out
}

#' Combine the subgroup meta-analyses
#'
#' Combine the subgroup meta-analyses to ...
#'
#' @param x An object retrieved from [perform_meta][metabolic::perform_meta].
#'
#' @return a [tibble][tibble::tibble-package] with named lists.
#' @export
#'
#' @examples
#' if (interactive()) {
#' # Perform meta-analysis on VO2max
#' results <- perform_meta(endpoint = "VO2max")
#' results
#'
#' # Combine Overall and Subgroups meta-analysis results
#' results_bind <- perform_bind(results$meta_analysis)
#' results_bind
#' }
perform_bind <- function(x) {

  chkclass(x = x, class = "list")

  if(is.na(x[8])) {
    list_meta <- x[1:7]
  } else {
    list_meta <- x
  }

  out <- suppressWarnings(do.call(what = metabind, args = list_meta))

  out$byvar <- dplyr::case_when(
    out$byvar == "meta1" ~ "Overall",
    out$byvar == "population" ~ "Population",
    out$byvar == "category_age" ~ "Age",
    out$byvar == "category_duration" ~ "Training Duration",
    out$byvar == "category_men_ratio" ~ "Men Ratio",
    out$byvar == "type_exercise" ~ "Type of Exercise",
    out$byvar == "category_bsln" ~ "Baseline Values",
    out$byvar == "HIIE" ~ "Type of HIIE"
  )

  out$bylevs <- dplyr::case_when(
    out$bylevs == "meta1" ~ "Overall",
    out$bylevs == "population" ~ "Population",
    out$bylevs == "category_age" ~ "Age",
    out$bylevs == "category_duration" ~ "Training Duration",
    out$bylevs == "category_men_ratio" ~ "Men Ratio",
    out$bylevs == "type_exercise" ~ "Type of Exercise",
    out$bylevs == "category_bsln" ~ "Baseline Values",
    out$bylevs == "HIIE" ~ "Type of HIIE"
  )

  out$studlab[1] <- ""

  out

}
