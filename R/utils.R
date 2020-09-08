## create labels
create_label_endpoints <- function(.dat, .gofer = FALSE) {
  if(.gofer == FALSE) {
    dplyr::mutate(
      .dat,
      endpoint = dplyr::case_when(
        endpoint == "vo2max" ~ "VO2max",
        endpoint == "body_mass" ~ "Body Mass",
        endpoint == "fmd" ~ "Flow-mediated Dilation",
        endpoint == "body_fat" ~ "Body Fat",
        endpoint == "sbp" ~ "Systolic Blood Pressure",
        endpoint == "dbp" ~ "Diastolic Blood Pressure",
        endpoint == "hdl" ~ "HDL",
        endpoint == "ldl" ~ "LDL",
        endpoint == "triglycerides" ~ "Triglycerides",
        endpoint == "total_cholesterol" ~ "Total Cholesterol",
        endpoint == "insulin" ~ "Fasting Insulin",
        endpoint == "glucose" ~ "Fasting Glucose",
        endpoint == "homa" ~ "HOMA-IR",
        endpoint == "crp" ~ "C-reactive Protein",
        endpoint == "hba1c" ~ "HbA1c",
        endpoint == "bmi" ~ "BMI"
      )
    )
  } else {
    .dat %>%
      dplyr::mutate(
        endpoint = dplyr::case_when(
          endpoint == "vo2max" ~ "VO2max",
          endpoint == "fmd" ~ "FMD",
          endpoint == "bmi" ~ "BMI",
          endpoint == "body_mass" ~ "Body\nmass",
          endpoint == "body_fat" ~ "Body\nfat",
          endpoint == "sbp" ~ "SBP",
          endpoint == "dbp" ~ "DBP",
          endpoint == "hdl" ~ "HDL",
          endpoint == "ldl" ~ "LDL",
          endpoint == "triglycerides" ~ "Triglycerides",
          endpoint == "total_cholesterol" ~ "Total\ncholesterol",
          endpoint == "crp" ~ "CRP",
          endpoint == "insulin" ~ "Insulin",
          endpoint == "glucose" ~ "Glucose",
          endpoint == "hba1c" ~ "HbA1c",
          endpoint == "homa" ~ "HOMA-IR"
        )
      ) %>%
      dplyr::mutate(
        endpoint =
          factor(endpoint,
                 levels = c(
                   "VO2max",
                   "FMD",
                   "BMI",
                   "Body\nmass",
                   "Body\nfat",
                   "SBP",
                   "DBP",
                   "HDL",
                   "LDL",
                   "Triglycerides",
                   "Total\ncholesterol",
                   "CRP",
                   "Insulin",
                   "Glucose",
                   "HbA1c",
                   "HOMA-IR")
          )
      )
  }

}

## internal functions from meta
chkclass <- function (x, class, name = NULL) {
  if (is.null(name))
    name <- deparse(substitute(x))
  if (!inherits(x, class))
    stop("Argument '", name, "' must be an object of class \"",
         class, "\".", call. = FALSE)
  invisible(NULL)
}

formatN <- function (x, digits = 2, text.NA = "--", big.mark = "") {
  outdec <- options()$OutDec
  res <- format(ifelse(is.na(x), text.NA, formatC(x, decimal.mark = outdec,
                                                  format = "f", digits = digits, big.mark = big.mark)))
  res <- rmSpace(res, end = TRUE)
  res
}

rmSpace <- function (x, end = FALSE, pat = " ") {
  if (!end) {
    while (any(substring(x, 1, 1) == pat, na.rm = TRUE)) {
      sel <- substring(x, 1, 1) == pat
      x[sel] <- substring(x[sel], 2)
    }
  }
  else {
    last <- nchar(x)
    while (any(substring(x, last, last) == pat, na.rm = TRUE)) {
      sel <- substring(x, last, last) == pat
      x[sel] <- substring(x[sel], 1, last[sel] - 1)
      last <- nchar(x)
    }
  }
  x
}

formatPT <- function (x, lab = FALSE, labval = "p", noblanks = FALSE, digits = 4,
                      zero = TRUE, scientific = FALSE, lab.NA = "--", big.mark = "",
                      JAMA = FALSE) {
  if (is.null(x))
    return("")
  outdec <- options()$OutDec
  n.zeros <- digits - 1
  n.zeros[n.zeros < 0] <- 0
  if (!scientific) {
    if (lab) {
      if (!JAMA)
        res <- format(ifelse(is.na(x) | is.nan(x), paste(labval,
                                                         "=", lab.NA), ifelse(x == 0, paste(labval,
                                                                                            "= 0"), ifelse(x < 1/10^digits, paste0(labval,
                                                                                                                                   " < 0", outdec, paste(rep("0", n.zeros), collapse = ""),
                                                                                                                                   "1"), paste(paste(labval, "="), formatC(round(x,
                                                                                                                                                                                 digits), decimal.mark = outdec, big.mark = big.mark,
                                                                                                                                                                           format = "f", digits = digits))))))
      else res <- format(ifelse(is.na(x) | is.nan(x), paste(labval,
                                                            "=", lab.NA), ifelse(x < 0.001, paste0(labval,
                                                                                                   " < 0", outdec, paste(rep("0", 2), collapse = ""),
                                                                                                   "1"), ifelse(x >= 0.001 & x < 0.01, paste(paste(labval,
                                                                                                                                                   "="), formatC(x, decimal.mark = outdec, big.mark = big.mark,
                                                                                                                                                                 format = "f", digits = 3)), ifelse(x >= 0.01 &
                                                                                                                                                                                                      x <= 0.99, paste(paste(labval, "="), formatC(x,
                                                                                                                                                                                                                                                   decimal.mark = outdec, big.mark = big.mark, format = "f",
                                                                                                                                                                                                                                                   digits = 2)), paste(paste(labval, ">"), formatC(0.99,
                                                                                                                                                                                                                                                                                                   decimal.mark = outdec, big.mark = big.mark, format = "f",
                                                                                                                                                                                                                                                                                                   digits = 2)))))))
    }
    else {
      if (!JAMA)
        res <- format(ifelse(is.na(x) | is.nan(x), lab.NA,
                             ifelse(x == 0, 0, ifelse(x < 1/10^digits, paste0("< 0",
                                                                              outdec, paste(rep("0", n.zeros), collapse = ""),
                                                                              "1"), formatC(round(x, digits), decimal.mark = outdec,
                                                                                            big.mark = big.mark, format = "f", digits = digits)))),
                      justify = "right")
      else res <- format(ifelse(is.na(x) | is.nan(x), lab.NA,
                                ifelse(x < 0.001, paste0("< 0", outdec, paste(rep("0",
                                                                                  2), collapse = ""), "1"), ifelse(x >= 0.001 &
                                                                                                                     x < 0.01, formatC(x, decimal.mark = outdec,
                                                                                                                                       big.mark = big.mark, format = "f", digits = 3),
                                                                                                                   ifelse(x >= 0.01 & x <= 0.99, formatC(x, decimal.mark = outdec,
                                                                                                                                                         big.mark = big.mark, format = "f", digits = 2),
                                                                                                                          paste(">", formatC(0.99, decimal.mark = outdec,
                                                                                                                                             big.mark = big.mark, format = "f", digits = 2)))))),
                         justify = "right")
    }
  }
  else {
    if (lab)
      res <- format(ifelse(is.na(x) | is.nan(x), paste(labval,
                                                       "=", lab.NA), paste(labval, "=", formatC(x, decimal.mark = outdec,
                                                                                                big.mark = big.mark, format = "e", digits = digits))))
    else res <- formatC(x, decimal.mark = outdec, big.mark = big.mark,
                        format = "e", digits = digits)
  }
  if (noblanks)
    res <- gsub(" ", "", res)
  if (!zero)
    res <- gsub("0\\.", "\\.", res)
  res[grep("NaN", res)] <- lab.NA
  res
}
