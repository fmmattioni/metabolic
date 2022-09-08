#' Plot results
#'
#' Plot results from the `perform_meta()` and `perform_bind()` function. Please, see 'Details' and 'Examples'.
#'
#' @param x an object obtained from the meta-analysis results. See 'Details'.
#' @param save A boolean to indicate whether to save the plot to disk.
#' @param path Path to write to. It has to be a character string indicating the path and file name (without the extension). For example, `~/Documents/metabolic_gofer_page_1` will save `metabolic_gofer_page_1.png` to the `Documents` folder.
#' @param format The file extension that you want to save the plot to. Only `.png`, is supported.
#'
#' @return a plot.
#'
#' @details
#' This function can be used to plot the results derived from both `perform_meta()` and `perform_bind()`. It can produce forests and bubble plots, depending on the object passed to the function.
#'
#' @rdname plot_metabolic
#' @export plot_metabolic
#'
#' @importFrom grDevices dev.off png
#' @importFrom graphics abline legend par title axis
#' @importFrom stats lm
#'
#' @examples
#' if(interactive()) {
#' # Perform meta-analysis on VO2max
#' results <- perform_meta(endpoint = "VO2max")
#'
#' # Plot Overall meta-analysis results
#' results$meta_analysis$Overall %>%
#'    plot_metabolic()
#'
#' # Plot Age meta-regression results
#' results$meta_regression$Age %>%
#'    plot_metabolic()
#'
#' # Plot overview of Overall and Subgroups meta-analysis results
#' results_bind <- perform_bind(results$meta_analysis)
#' results_bind %>%
#'    plot_metabolic()
#'
#' # Plot sensitivity analysis results
#' results$sensitivity_analysis$Overall %>%
#'    plot_metabolic()
#' }
plot_metabolic <- function(x, save = FALSE, path, format = ".png") {
  UseMethod("plot_metabolic", x)
}

#' @export
plot_metabolic.meta <- function(x, save = FALSE, path, format = ".png") {

  chkclass(x, class = "meta")

  desired_effect <- unique(x$data$desired_effect)

  if(desired_effect == "increase") {
    out <- function(){
      meta::forest(
        x = x,
        lab.e = "HIIE",
        lab.c = "MICT",
        bottom.lr = FALSE,
        print.byvar = FALSE,
        label.left = "Favours MICT",
        label.right = "Favours HIIE",
        xlab = "Cohen's d Effect Sizes",
        ff.lr = "bold",
        just = "center",
        test.overall = TRUE
      )
    }
  } else {
    out <- function(){
      meta::forest(
        x = x,
        lab.e = "MICT",
        lab.c = "HIIE",
        leftcols = c("studlab", "n.c", "mean.c", "sd.c", "n.e", "mean.e", "sd.e"),
        bottom.lr = FALSE,
        print.byvar = FALSE,
        label.left="Favours MICT",
        label.right="Favours HIIE",
        xlab = "Cohen's d Effect Sizes",
        ff.lr = "bold",
        just = "center",
        test.overall = TRUE
      )
    }
  }

  if(save) {
    if(format != ".png")
      stop("I am sorry, mate. You can only save it as a '.png' file.", call. = FALSE)

    if(!is.character(path))
      stop("You must pass your path as a character string. See ?plot_metabolic for more details.", call. = FALSE)

    path <- paste0(path, format)

    endpoint <- unique(x$data$endpoint)

    ## check whether it is plotting overall or subgroups
    if(purrr::is_empty(x$byvar)) {
      label <- "Overall"

      forest_height <- switch (endpoint,
                               "VO2max" = 12,
                               "Flow-mediated Dilation" = 4,
                               "BMI" = 8,
                               "Body Mass" = 11,
                               "Body Fat" = 8,
                               "Systolic Blood Pressure" = 8,
                               "Diastolic Blood Pressure" = 8,
                               "HDL" = 8,
                               "LDL" = 8,
                               "Triglycerides" = 8,
                               "Total Cholesterol" = 8,
                               "C-reactive Protein" = 4,
                               "Fasting Insulin" = 6,
                               "Fasting Glucose" = 8,
                               "HbA1c" = 6,
                               "HOMA-IR" = 6
      )
    } else {
      label <- switch (x$bylab,
                       population = "Population",
                       category_age = "Age",
                       category_duration = "Training Duration",
                       category_men_ratio = "Men Ratio",
                       type_exercise = "Type of Exercise",
                       category_bsln = "Baseline Values",
                       HIIE = "Type of HIIE"
      )
      forest_height <- switch (endpoint,
                               "VO2max" = 18,
                               "Flow-mediated Dilation" = 9,
                               "BMI" = 12.5,
                               "Body Mass" = 16,
                               "Body Fat" = 13,
                               "Systolic Blood Pressure" = 12,
                               "Diastolic Blood Pressure" = 12,
                               "HDL" = 12,
                               "LDL" = 12,
                               "Triglycerides" = 12,
                               "Total Cholesterol" = 12,
                               "C-reactive Protein" = 7,
                               "Fasting Insulin" = 10,
                               "Fasting Glucose" = 12,
                               "HbA1c" = 9,
                               "HOMA-IR" = 9
      )
    }

    usethis::ui_todo("Saving {usethis::ui_field(endpoint)} - {usethis::ui_value(label)} forest plot to disk...")

    png(filename = path, height = forest_height, width = 13, units = "in", res = 200)
    out()
    invisible(dev.off())

    usethis::ui_done("Succesfully saved {usethis::ui_field(endpoint)} - {usethis::ui_value(label)} forest plot to {usethis::ui_value(path)}")
  }

  out()
}

#' @export
plot_metabolic.metareg <- function(x, save = FALSE, path, format = ".png") {

  chkclass(x, class = "metareg")

  ## get xlab
  xlab_tmp <- as.character(x$.meta$x$call$byvar)
  xlab <- switch (xlab_tmp,
                  population = "Population",
                  category_age = "Age (yr)",
                  category_duration = "Training Duration (weeks)",
                  category_men_ratio = "Men Ratio",
                  type_exercise = "Type of Exercise",
                  category_bsln = "Baseline Values",
                  HIIE = "Type of HIIE"
  )

  if(xlab == "Population") {
    ## re-do subgroup meta-analysis with continuous variable to use in bubble plot
    x <- meta::update.meta(x$.meta$x, byvar = population_regression) %>%
      meta::metareg()

    out <- function() {
      oldpar <- par(mfrow = c(1, 1), no.readonly = TRUE)
      on.exit(par(oldpar))
      meta::bubble(
        x,
        xlab = xlab,
        xaxt = "n",
        main = glue::glue("\u03b2: {round(x$b[2], 3)}\np: {format.pval(round(x$pval[2], 3), digits = 3,eps = 0.001, na.form = NA)}")
      )
      axis(1, at = 1:5, labels = c("Healthy", "Obese", "Cardiac Rehab", "Metabolic Syndrome", "T2D"))
    }
  } else {
    out <- function() {
      oldpar <- par(mfrow = c(1, 1), no.readonly = TRUE)
      on.exit(par(oldpar))
      meta::bubble(
        x,
        xlab = xlab,
        main = glue::glue("\u03b2: {round(x$b[2], 3)}\np: {format.pval(round(x$pval[2], 3), digits = 3,eps = 0.001, na.form = NA)}")
      )
    }
  }

  if(save) {
    if(format != ".png")
      stop("I am sorry, mate. You can only save it as a '.png' file.", call. = FALSE)

    if(!is.character(path))
      stop("You must pass your path as a character string. See ?plot_small_study_effects for more details.", call. = FALSE)

    path <- paste0(path, format)

    usethis::ui_todo("Saving Bubble plot to disk...")


    png(filename = path, width = 10, height = 5, units = "in", res = 200)
    out()
    invisible(dev.off())

    usethis::ui_done("Succesfully saved Bubble plot to {usethis::ui_value(path)}")
  }

  out()

}

#' @export
plot_metabolic.metabind <- function(x, save = FALSE, path, format = ".png") {

  chkclass(x, class = "metabind")

  # get the effect sizes classifications
  x$classd <- dplyr::case_when(
    abs(x$TE) >= 0 & abs(x$TE) < .2 ~ "trivial",
    abs(x$TE) >= .2 & abs(x$TE) < .5 ~ "small",
    abs(x$TE) >= .5 & abs(x$TE) < .8 ~ "medium",
    abs(x$TE) >= .8 ~ "large"
  )

  # format p-value of the effect
  x$pval <- format.pval(round(x$pval, 3), digits = 3, eps = 0.001, na.form = NA)

  out <- function() {
    meta::forest(
      x = x,
      rightcols = c("effect", "ci", "pval", "classd"),
      rightlabs = c("d","95% CI", "p-value", "Effect Size"),
      label.left = "Favours MICT",
      label.right = "Favours HIIE",
      xlab = "Cohen's d Effect Sizes",
      bottom.lr = FALSE,
      ff.lr = "bold",
      colgap = "10mm",
      lwd = 2.5
    )
  }

  if(save) {
    if(format != ".png")
      stop("I am sorry, mate. You can only save it as a '.png' file.", call. = FALSE)

    if(!is.character(path))
      stop("You must pass your path as a character string. See ?plot_metabolic for more details.", call. = FALSE)

    path <- paste0(path, format)

    endpoint <- unique(x$call$Overall$data$endpoint)

    usethis::ui_todo("Saving {usethis::ui_field(endpoint)} - Overall subgroup forest plot to disk...")

    png(filename = path, height = 9, width = 12, units = "in", res = 200)
    out()
    invisible(dev.off())

    usethis::ui_done("Succesfully saved {usethis::ui_field(endpoint)} - Overall subgroup forest plot to {usethis::ui_value(path)}")
  }

  suppressWarnings(out())

}

#' @export
plot_metabolic.metainf <- function(x, save = FALSE, path, format = ".png") {

  chkclass(x, class = "metainf")

  ## I2
  x$I2 <- paste0(formatN(round(100 * x$I2, 1), digits = 1), "%")

  ## pval
  x$pval <- format.pval(round(x$pval, 3), digits = 3,eps = 0.001, na.form = NA)

  ## tau2
  x$tau2 <- formatPT(round(x$tau2, 4), digits = 4)

  out <- function() {
    meta::forest(
      x = x,
      rightcols = c("effect", "ci", "pval", "tau2", "I2"),
      rightlabs = c("d", "95% CI", "p-value", "\u03c4\u00B2", "I\u00B2"),
      label.left="Favours MICT",
      label.right="Favours HIIE",
      xlab = "Cohen's d Effect Sizes",
      bottom.lr = FALSE,
      col.by = "black",
      ff.lr = "bold",
      colgap = "10mm",
      lwd = 2.5
    )
  }

  if(save) {
    if(format != ".png")
      stop("I am sorry, mate. You can only save it as a '.png' file.", call. = FALSE)

    if(!is.character(path))
      stop("You must pass your path as a character string. See ?plot_metabolic for more details.", call. = FALSE)

    path <- paste0(path, format)

    usethis::ui_todo("Saving {usethis::ui_field('sensitivity analysis')} forest plot to disk...")

    n_studies <- length(x$studlab)
    forest_height <- dplyr::case_when(
      n_studies > 40 ~ 11.5,
      dplyr::between(n_studies, 20, 40) ~ 8,
      TRUE ~ 6
    )

    png(filename = path, height = forest_height, width = 12, units = "in", res = 200)
    out()
    invisible(dev.off())

    usethis::ui_done("Succesfully saved {usethis::ui_field('sensitivity analysis')} forest plot to {usethis::ui_value(path)}")
  }

  out()

}

#' Plot small-study effects analysis
#'
#' @param x an object of class meta
#' @param save A boolean to indicate whether to save the plot to disk.
#' @param path Path to write to. It has to be a character string indicating the path and file name (without the extension). For example, `~/Documents/small_study_effects` will save `small_study_effects.png` to the `Documents` folder.
#' @param format The file extension that you want to save the plot to. Only `.png`, is supported.
#'
#' @return a plot.
#'
#' @rdname plot_small_study_effects
#' @export plot_small_study_effects
#'
#' @examples
#' \dontrun{
#'   # Perform meta-analysis on VO2max
#'   results <- perform_meta(endpoint = "VO2max")
#'
#'   # Plot small-study effects results
#'   results$meta_analysis$Overall %>%
#'      plot_small_study_effects()
#' }
plot_small_study_effects <- function(x, save = FALSE, path, format = ".png") {

  ## check whether it is plotting overall or subgroups
  if(!purrr::is_empty(x$byvar))
    stop("I am sorry. You need to pass the 'Overall' results to plot the small-study effects. See ?plot_small_study_effects for more details.",
         call. = FALSE)

  ## contour-enhanced funnel plot
  plot_funnel <- function() {
    meta::funnel(
      x = x,
      comb.random = FALSE,
      pch = 16,
      contour = c(0.9, 0.95, 0.99),
      col.contour = c("darkgray", "gray","lightgray")
    )
    legend(
      "topleft",
      c("0.1 > p > 0.05", "0.05 > p > 0.01", "p < 0.01"),
      fill = c("darkgray", "gray","lightgray"),
      bty = "n",
      inset = c(-0.1, -0.25),
      xpd = TRUE
    )
  }

  ## radial plot
  meta_bias <- meta::metabias(x = x, method = "linreg", k.min = 3)

  reg <- lm(I(x$TE / x$seTE) ~ I(1 / x$seTE))

  bias <- meta_bias$estimate[[1]] %>%
    round(3)

  p_value <- meta_bias$p.value %>%
    round(3)

  plot_bias <- function() {
    meta::radial(x)
    abline(reg)
    title(
      main = glue::glue("bias: {bias}, p: {format.pval(p_value, digits = 3, eps = 0.001, na.form = NA)}"),
      cex.main = 1.25
    )
  }

  if(save) {
    if(format != ".png")
      stop("I am sorry, mate. You can only save it as a '.png' file.", call. = FALSE)

    if(!is.character(path))
      stop("You must pass your path as a character string. See ?plot_small_study_effects for more details.", call. = FALSE)

    path <- paste0(path, format)

    endpoint <- unique(x$data$endpoint)

    usethis::ui_todo("Saving {usethis::ui_field(endpoint)} - small-study effects to disk...")

    png(filename = path, width = 10, height = 5, units = "in", res = 200)
    oldpar <- par(mfrow = c(1, 2), no.readonly = TRUE)
    on.exit(par(oldpar))
    plot_funnel()
    plot_bias()
    invisible(dev.off())

    usethis::ui_done("Succesfully saved {usethis::ui_field(endpoint)} - small-study effects to {usethis::ui_value(path)}")
  }

  oldpar <- par(mfrow = c(1, 2), no.readonly = TRUE)
  on.exit(par(oldpar))
  plot_funnel()
  plot_bias()
}
