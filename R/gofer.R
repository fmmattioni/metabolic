#' Build a GOfER diagram (Graphical Overview for Evidence Reviews)
#'
#' It is recommended to set `save = TRUE` and indicate the `path` to save to, as the plot is not going to look good in the `Plots` panel.
#'
#' @param page A text string to indicate the page you would like to display. This GOfER has two pages (28 studies in page 1 and 28 studies in page 2).
#' @param save A boolean to indicate whether to save the plot to disk.
#' @param path Path to write to. It has to be a character string indicating the path and file name (without the extension). For example, `~/Documents/metabolic_gofer_page_1` will save `metabolic_gofer_page_1.png` to the `Documents` folder.
#' @param format The file extension that you want to save the plot to. Only `.png`, is supported.
#'
#' @return A `patchwork` object
#'
#' @export
#'
#' @examples
#' \dontrun{
#' build_gofer(page = "1", save = TRUE, path = "~/Documents/metabolic_gofer_page_1")
#' }
build_gofer <- function(page = c("1", "2"), save = FALSE,  path,  format = ".png") {

  page <- match.arg(page)

  ## here we get the number of studies + 1 to show the lines in the graph
  ## page 1 = 28 studies
  ## page 2 = 28 studies
  switch (page,
    "1" = n_studies <- 28,
    "2" = n_studies <- 28
  )

  switch (page,
    "1" = n_lines <- n_studies + 1,
    "2" = n_lines <- n_studies + 1
  )

  ## prepare data to show correctly in the graph
  data_prepared <- metabolic::metabolic_gofer %>%
    dplyr::arrange(dplyr::desc(study), dplyr::desc(groups)) %>%
    dplyr::mutate(study = forcats::as_factor(study)) %>%
    tidyr::nest_legacy(-study)

  ## filter data based on the page
  if(page == "1") {
    data_page <- data_prepared %>%
      utils::tail(n_studies)

    cli::cat_line(cli::rule(center = cli::col_red(" * Building GOfER - page 1 * ")))
  } else {
    data_page <- data_prepared %>%
      utils::head(n_studies)

    cli::cat_line(cli::rule(center = cli::col_red(" * Building GOfER - page 2 * ")))
  }

  #################################################################################
  #
  # first step is to prepare the basic grid to show the lines between studies
  #
  # 1) grid
  #
  #################################################################################

  name <- "basic grid"
  cli::cli_alert_success("Building {.field {name}}")

  p_grid <- helper_plot_grid(.data = data_page, n_lines = n_lines)

  #################################################################################
  #
  # now we plot the studies labels
  #
  # 2) study
  #################################################################################

  name <- "Study"
  cli::cli_alert_success("Building {.field {name}}")

  p_studies <- helper_plot_studies(.data = data_page)

  #################################################################################
  #
  # now we plot information on the studies sample
  #
  # 3) sample
  #################################################################################

  name <- "Sample"
  cli::cli_alert_success("Building {.field {name}}")

  ## data preparation
  data_sample <- data_page %>%
    tidyr::unnest_legacy() %>%
    dplyr::select(study, dplyr::starts_with("sample")) %>%
    dplyr::mutate(sample_men_ratio = round(sample_men_ratio, digits = 1),
                  fill = dplyr::case_when(
                    sample_men_ratio > 0.5 ~ "#355c7d",
                    sample_men_ratio == 0.5 ~ "#c06c84",
                    sample_men_ratio < 0.5 ~ "#f67280"
                  ),
                  sample_men_ratio = sprintf(sample_men_ratio, fmt = '%#.1f')) %>%
    dplyr::distinct_all() %>%
    dplyr::arrange(dplyr::desc(study)) %>%
    # this is a hack to show a white space between the facet and the plot
    # this is needed to be able to have subheadings
    dplyr::add_row(study = NA) %>%
    dplyr::mutate(
      dummy_population = 0.5,
      dummy_fitness = 2,
      dummy_men_ratio = 3.5
    )

  p_sample <- helper_plot_sample(.data = data_sample)

  #################################################################################
  #
  # now we plot information on sample anamnese
  #
  # 4) anamnese
  #################################################################################

  name <- "Anamnese"
  cli::cli_alert_success("Building {.field {name}}")

  ## data preparation
  data_anamnese <- data_page %>%
    tidyr::unnest_legacy() %>%
    dplyr::select(study, dplyr::starts_with("anamnese")) %>%
    # this is a hack to show a white space between the facet and the plot
    # this is needed to be able to have subheadings
    dplyr::add_row(study = NA) %>%
    dplyr::mutate(
      dummy_smoker = 1,
      dummy_medicines = 2
    ) %>%
    dplyr::distinct_all()

  p_anamnese <- helper_plot_anamnese(.data = data_anamnese)

  #################################################################################
  #
  # now we plot the median sample age of each study
  #
  # 5) age
  #################################################################################

  name <- "Age"
  cli::cli_alert_success("Building {.field {name}}")

  ## data preparation
  data_age <- data_page %>%
    tidyr::unnest_legacy() %>%
    dplyr::select(study, groups, age) %>%
    dplyr::group_by(study) %>%
    dplyr::summarise(age_median = stats::median(age)) %>%
    # this is a hack to show a white space between the facet and the plot
    # this is needed to be able to have subheadings
    dplyr::add_row(study = NA)

  p_age <- helper_plot_age(.data = data_age, n_lines = n_lines)

  #################################################################################
  #
  # now we plot the design of each study
  #
  # 6) design
  #################################################################################

  name <- "Design"
  cli::cli_alert_success("Building {.field {name}}")

  ## get icons path
  running_icon <- system.file("running.png", package = "metabolic")
  cycling_icon <- system.file("cycling.png", package = "metabolic")

  ## data preparation
  data_design <- data_page %>%
    tidyr::unnest_legacy() %>%
    dplyr::select(study, groups, dplyr::starts_with("design")) %>%
    # this is a hack to show a white space between the facet and the plot
    # this is needed to be able to have subheadings
    dplyr::add_row(study = NA) %>%
    dplyr::mutate(
      groups = factor(groups, levels = c("HIIT", "SIT", "MICT")),
      my_colour = ifelse(groups %in% c("HIIT", "SIT"), "#ee4e4e", "#1f7bb6"),
      dummy_type = 1,
      dummy_groups = 2,
      dummy_sample_size = 3,
      dummy_duration = 4,
      dummy_frequency = 5,
      dummy_intensity = 6,
      dummy_exercise_icon = ifelse(design_type_of_exercise == "Running", running_icon, cycling_icon)
    ) %>%
    dplyr::arrange(study, dplyr::desc(groups))

  p_design <- helper_plot_design(.data = data_design)

  #################################################################################
  #
  # now we plot the training duration of each study
  #
  # 6.1) training duration
  #################################################################################

  ## data preparation
  data_duration <- data_page %>%
    tidyr::unnest_legacy() %>%
    dplyr::select(study, groups, design_training_duration) %>%
    # this is a hack to show a white space between the facet and the plot
    # this is needed to be able to have subheadings
    dplyr::add_row(study = NA)

  p_duration <- helper_plot_duration(.data = data_duration, n_lines = n_lines)

  #################################################################################
  #
  # now we plot information on the HIIE protocol
  #
  # 7) hiie
  #################################################################################

  name <- "HIIE"
  cli::cli_alert_success("Building {.field {name}}")

  ## data preparation
  data_hiie <- data_page %>%
    tidyr::unnest_legacy() %>%
    dplyr::select(study, groups, dplyr::starts_with("hiie")) %>%
    tidyr::drop_na() %>%
    # this is a hack to show a white space between the facet and the plot
    # this is needed to be able to have subheadings
    dplyr::add_row(study = NA) %>%
    dplyr::mutate(
      groups = factor(groups, levels = c("HIIT", "SIT")),
      dummy_reps = 1,
      dummy_reps_duration = 2,
      dummy_work_rest_ratio = 3
    )

  p_hiie <- helper_plot_hiie(.data = data_hiie)

  #################################################################################
  #
  # now we plot information on the study compliance
  #
  # 8) compliance
  #################################################################################

  name <- "Compliance"
  cli::cli_alert_success("Building {.field {name}}")

  ## data preparation
  data_compliance <- data_page %>%
    tidyr::unnest_legacy() %>%
    dplyr::select(study, groups, compliance) %>%
    # this is a hack to show a white space between the facet and the plot
    # this is needed to be able to have subheadings
    dplyr::add_row(study = NA) %>%
    dplyr::mutate(
      groups = factor(groups, levels = c("HIIT", "SIT", "MICT")),
      label = scales::percent(compliance, accuracy = 1, suffix = "")
    )

  p_compliance <- helper_plot_compliance(.data = data_compliance, n_lines = n_lines)

  #################################################################################
  #
  # now we plot information on the clinical endpoints
  #
  # 9) endpoints
  #################################################################################

  name <- "Clinical Endpoints"
  cli::cli_alert_success("Building {.field {name}}")

  ## data preparation
  data_endpoints <- data_page %>%
    tidyr::unnest_legacy() %>%
    dplyr::select(study, groups, dplyr::starts_with("endpoints")) %>%
    tidyr::gather("endpoint", "sig_from_bsln", dplyr::starts_with("endpoints")) %>%
    dplyr::mutate(endpoint = stringr::str_remove(endpoint, "endpoints_")) %>%
    tidyr::drop_na(study, sig_from_bsln) %>%
    dplyr::add_row(study = NA) %>%
    dplyr::mutate(endpoint = forcats::as_factor(endpoint),
                  sig_from_bsln = factor(sig_from_bsln, levels = c("No", "Yes")),
                  groups = factor(groups, levels = c("HIIT", "SIT", "MICT"))) %>%
    dplyr::arrange(endpoint, study, dplyr::desc(groups)) %>%
    create_label_endpoints(.gofer = TRUE)

  p_endpoints <- helper_plot_endpoints(.data = data_endpoints, n_lines = n_lines)

  #################################################################################
  #
  # now we plot information for plot caption
  #
  # 10) caption
  #################################################################################

  ## data preparation
  dat_caption_label <- dplyr::tibble(
    x = 1:3,
    y = 1:3,
    caption_label = c("Y = yes", "N = no", "N/R = not reported")
  ) %>%
    dplyr::mutate(caption_label = forcats::as_factor(caption_label))

  p_caption <-dplyr::tibble(
    x = 1:3,
    y = 1:3,
    fill = c("#F8766D", "#00BFC4", "gray47")
  ) %>%
    ggplot2::ggplot() +
    ggplot2::geom_point(ggplot2::aes(x = x, y = y, fill = fill), shape = 21, size = 4) +
    ggplot2::scale_fill_identity(
      guide = "legend",
      labels = c(
        "= significantly different from baseline (p < 0.05)",
        "= not significantly different from baseline (p > 0.05)",
        "= significance from baseline not reported"
      )
    ) +
    ggplot2::geom_point(data = dat_caption_label, ggplot2::aes(x = x, y = y, shape = caption_label)) +
    ggplot2::geom_rect(ggplot2::aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf), fill = "white") +
    ggplot2::theme_void() +
    ggplot2::labs(fill = "Note:",
                  shape = NULL)+
    ggplot2::theme(legend.position = "bottom",
                   legend.direction = "vertical") +
    ggplot2::guides(shape = ggplot2::guide_legend(override.aes = list(shape='')))

  #################################################################################
  #
  # GRAND FINALE - SOME PATCHWORK MAGIC
  #
  #################################################################################

  name <- "GOfER"
  value <- "patchwork"
  usethis::ui_done("Finishing up {usethis::ui_field(name)} with {usethis::ui_value(value)}")

  ## define layout of plots
  layout <- c(
    patchwork::area(t = 1, l = 17, b = 3, r = 17), # p_caption
    patchwork::area(t = 1, l = 1, b = 3, r = 20), # p_grid
    patchwork::area(t = 1, l = 1, b = 3, r = 1), # p_studies
    patchwork::area(t = 1, l = 2, b = 3, r = 3), # p _sample
    patchwork::area(t = 1, l = 4, b = 3, r = 5), # p_anamnese
    patchwork::area(t = 1, l = 6, b = 3, r = 6), # p _age
    patchwork::area(t = 1, l = 7, b = 3, r = 12), # p_design
    patchwork::area(t = 1, l = 10, b = 3, r = 10), # p_duration
    patchwork::area(t = 1, l = 13, b = 3, r = 14), # p_hiie
    patchwork::area(t = 1, l = 15, b = 3, r = 15), # p_compliance
    patchwork::area(t = 1, l = 16, b = 3, r = 20) # p_endpoints
  )

  p_final <- p_caption +
    p_grid +
    p_studies + p_sample + p_anamnese +
    p_age +
    p_design + p_duration +
    p_hiie +
    p_compliance +
    p_endpoints +
    patchwork::plot_layout(nrow = 1, design = layout, guides = "keep")

  cli::cat_line(cli::rule(center = cli::col_blue(" * DONE * ")))

  if(save) {
    if(format != ".png")
      stop("I am sorry, mate. You can only save it as a '.png' file.", call. = FALSE)

    if(!is.character(path))
      stop("You must pass your path as a character string. See ?build_gofer for more details.", call. = FALSE)

    path <- paste0(path, format)

    usethis::ui_todo("Saving GOfER to disk...")
    ggplot2::ggsave(filename = path, plot = p_final, width = 42, height = 20)

    name <- paste0("GofER - page ", page)
    usethis::ui_done("Succesfully saved {usethis::ui_field(name)} to {usethis::ui_value(path)}")
  }

  suppressWarnings(print(p_final))
}
