## this file contains the functions that build the individual
## plots for the final GOfER diagram
## these functions are internal only and will not be exported

helper_plot_grid <- function(.data, n_lines) {
  .data %>%
    # this is a hack to show a white space between the facet and the plot
    # this is needed to be able to have subheadings
    dplyr::add_row(study = NA) %>%
    ggplot2::ggplot() +
    ggfittext::geom_fit_text(ggplot2::aes(x = study, y = 0, label = ""),
                             place = "left",
                             reflow = TRUE,
                             fontface = "plain",
                             position = ggplot2::position_dodge(width = 0.7),
                             show.legend = FALSE,
                             na.rm = TRUE) +
    ggplot2::geom_vline(xintercept = seq(1, n_lines, 1)  - 0.5) +
    ggplot2::theme_void() +
    ggplot2::coord_flip()
}

helper_plot_studies <- function(.data) {
  .data %>%
    # this is a hack to show a white space between the facet and the plot
    # this is needed to be able to have subheadings
    dplyr::add_row(study = NA) %>%
    ggplot2::ggplot() +
    ggfittext::geom_fit_text(ggplot2::aes(x = study, y = 0, label = study),
                             place = "centre",
                             reflow = TRUE,
                             fontface = "plain",
                             show.legend = FALSE,
                             na.rm = TRUE) +
    ggplot2::coord_flip() +
    ggplot2::facet_wrap(~ "Study") +
    theme_gofer()
}

helper_plot_sample <- function(.data) {
  .data %>%
    ggplot2::ggplot() +
    ## Population
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_population, label = sample_population),
                       fontface = "plain",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_population),
                       label = "Population",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ## Fitness
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_fitness, label = sample_fitness),
                       fontface = "plain",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_fitness),
                       label = "Fitness",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ## Men Ratio
    ggplot2::geom_label(ggplot2::aes(x = study, y = dummy_men_ratio, label = sample_men_ratio, fill = fill),
                        colour = "white",
                        size = 4,
                        fontface = "bold",
                        na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_men_ratio),
                       label = "Men\nratio",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::coord_flip() +
    ggplot2::scale_fill_identity() +
    ggplot2::ylim(0, 4) +
    ggplot2::facet_wrap(~ "Sample") +
    theme_gofer()
}

helper_plot_anamnese <- function(.data) {
  .data %>%
    ggplot2::ggplot() +
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_smoker, label = anamnese_smoker),
                       fontface = "plain",
                       position = ggplot2::position_dodge2(width = 1),
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_smoker),
                       label = "Smoker",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_medicines, label = anamnese_medicines_to_control_BP),
                       fontface = "plain",
                       position = ggplot2::position_dodge2(width = 1),
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_medicines),
                       label = "Medicines to\ncontrol BP",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::coord_flip() +
    ggplot2::ylim(0.5, 2.5) +
    ggplot2::facet_wrap(~ "Anamnese") +
    theme_gofer()
}

helper_plot_age <- function(.data, n_lines, strip_background = "#ff6581", margins = c(0, 0, 0, 0.1), line_plot = TRUE) {
  .data %>%
    ggplot2::ggplot(ggplot2::aes(x = study, y = age_median, colour = age_median, label = as.integer(age_median))) +
    ggplot2::geom_segment(ggplot2::aes(x = study, y = 0, xend = study, yend = age_median), colour = "black", na.rm = TRUE) +
    ggplot2::geom_point(size = 9, na.rm = TRUE) +
    ggplot2::geom_text(color = "white", size = 4, fontface = "bold", na.rm = TRUE) +
    ## Hack to delete lines above
    ggplot2::geom_rect(ggplot2::aes(xmin = n_lines - 0.45, xmax = Inf, ymin = -Inf, ymax = Inf), fill = "white", colour = "white") +
    ggplot2::scale_color_gradient(low = "#3a6e7f", high = "#38c2a4") +
    ggplot2::coord_flip() +
    ggplot2::scale_x_discrete(breaks = NULL) +
    ggplot2::ylim(0, 78) +
    ggplot2::labs(y = "Age (yr)") +
    ggplot2::facet_wrap(~ "Age") +
    theme_gofer(strip_background = strip_background, margins = margins, line_plot = line_plot)
}

helper_plot_design <- function(.data, strip_background = "#3d4c66") {
  .data %>%
    ggplot2::ggplot() +
    ## Type of Exercise
    ggimage::geom_image(ggplot2::aes(x = study, y = dummy_type, image = dummy_exercise_icon), size = 0.0275, by = "height", na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_type),
                       label = "Type of\nexercise",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ## Groups
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_groups, label = groups, colour = my_colour),
                       fontface = "bold",
                       position = ggplot2::position_dodge2(width = 1),
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_groups),
                       label = "Groups",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ## Sample Size
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_sample_size, label = design_sample_size),
                       position = ggplot2::position_dodge2(width = 1),
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_sample_size),
                       label = "Sample\nsize",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ## Hack to add Training Duration
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_duration, label=""),
                       fontface = "bold",
                       position = ggplot2::position_dodge2(width = 1),
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ## Training Frequency
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_frequency, label = design_training_frequency),
                       #fontface="bold",
                       position = ggplot2::position_dodge2(width = 1),
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_frequency),
                       label = "Training\nfrequency",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ## Exercise Intensity
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_intensity, label = design_exercise_intensity),
                       #fontface="bold",
                       position = ggplot2::position_dodge2(width = 1),
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_intensity),
                       label = "Exercise\nintensity",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::ylim(0.5, 6.5) +
    ggplot2::coord_flip() +
    ggplot2::scale_color_identity() +
    ggplot2::scale_fill_identity() +
    ggplot2::facet_wrap(~ "Design") +
    theme_gofer(strip_background = strip_background)
}

helper_plot_duration <- function(.data, n_lines, line_plot = TRUE) {
  .data %>%
    ggplot2::ggplot() +
    ggplot2::geom_segment(ggplot2::aes(x = study, y = 0, xend = study, yend = design_training_duration), na.rm = TRUE) +
    ggplot2::geom_point(ggplot2::aes(x = study, y = design_training_duration, colour = design_training_duration),
                        size = 9,
                        na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = study, y = design_training_duration, label = design_training_duration),
                       color = "white",
                       size = 4,
                       fontface = "bold",
                       na.rm = TRUE) +
    ## Hack to delete lines above
    ggplot2::geom_rect(ggplot2::aes(xmin = n_lines - 0.45, xmax = Inf, ymin = -Inf, ymax = Inf),
                       fill = "white",
                       colour = "white") +
    ## Training duration label
    ggplot2::geom_text(ggplot2::aes(x = NA, y = 12),
                       label = "Training\nduration",
                       size = 5,
                       fontface = "bold",
                       colour = "black",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::coord_flip() +
    ggplot2::scale_color_gradient(low = "#ad567c", high = "#ed2d4a") +
    ggplot2::labs(y = "Duration (weeks)") +
    ggplot2::scale_x_discrete(breaks = NULL) +
    ggplot2::ylim(0, 26) +
    theme_gofer(line_plot = line_plot)
}

helper_plot_hiie <- function(.data, strip_background = "#ff4f67") {
  .data %>%
    ggplot2::ggplot() +
    ## N of reps
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_reps, label = hiie_n_reps),
                       #fontface="bold",
                       position = ggplot2::position_dodge2(width = 1),
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_reps),
                       label = "N reps",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ## Reps duration
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_reps_duration, label = hiie_rep_duration),
                       #fontface="bold",
                       position = ggplot2::position_dodge2(width = 1),
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_reps_duration),
                       label = "Rep\nduration (s)",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ## Work-rest ratio
    ggplot2::geom_text(ggplot2::aes(x = study, y = dummy_work_rest_ratio, label = hiie_work_rest_ratio),
                       position = ggplot2::position_dodge2(width = 1),
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = NA, y = dummy_work_rest_ratio),
                       label = "Work-rest\nratio",
                       size = 5,
                       fontface = "bold",
                       show.legend = FALSE,
                       na.rm = TRUE) +
    ggplot2::ylim(0.5, 3.5) +
    ggplot2::coord_flip() +
    ggplot2::facet_wrap(~ "HIIE") +
    theme_gofer(strip_background = strip_background)
}

helper_plot_compliance <- function(.data, n_lines, strip_background = "#a1648e", margins = c(0, 0, 0, 0.1), line_plot = TRUE) {
  .data %>%
    ggplot2::ggplot() +
    ggplot2::geom_linerange(ggplot2::aes(x = study, ymin = 0.5, ymax = compliance),
                            position = ggplot2::position_dodge2(width = 1),
                            na.rm = TRUE) +
    ggplot2::geom_point(ggplot2::aes(x = study, y = compliance, colour = compliance),
                        size = 7,
                        position = ggplot2::position_dodge2(width = 1),
                        na.rm = TRUE) +
    ggplot2::geom_text(ggplot2::aes(x = study, y = compliance, label = label),
                       color = "white",
                       size = 3,
                       fontface = "bold",
                       position = ggplot2::position_dodge2(width = 1),
                       na.rm = TRUE) +
    ggplot2::geom_label(data = dplyr::filter(.data, is.na(label)), ggplot2::aes(x = study, y = 0.75),
                        colour = "black",
                        label = "N/R",
                        size = 4,
                        fontface = "bold",
                        na.rm = TRUE) +
    ## Hack to delete lines in the subheading area
    ggplot2::geom_rect(ggplot2::aes(xmin = n_lines - 0.45, xmax = Inf, ymin = -Inf, ymax = Inf), fill = "white", colour = "white") +
    ggplot2::coord_flip() +
    ggplot2::labs(y = "Compliance (%)") +
    ggplot2::scale_x_discrete(breaks = NULL) +
    ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1), limits = c(0.5, 1.1), breaks = c(0.5, 0.7, 0.9)) +
    ggplot2::facet_wrap(~ "Compliance") +
    theme_gofer(strip_background = strip_background, margins = margins, line_plot = line_plot)
}

helper_plot_endpoints <- function(.data, n_lines) {
  .data %>%
    ggplot2::ggplot() +
    ggplot2::geom_hline(yintercept = 1:16) +
    ggplot2::geom_point(ggplot2::aes(x = study, y = as.numeric(endpoint), fill = sig_from_bsln, group = groups),
                        shape = 21,
                        size = 4,
                        position = ggplot2::position_dodge(width = -1),
                        na.rm = TRUE) +
    ## Hack to delete lines above
    ggplot2::geom_rect(ggplot2::aes(xmin = n_lines - 0.45, xmax = Inf, ymin = -Inf, ymax = Inf), fill = "white") +
    ## Add labels
    ggplot2::geom_text(ggplot2::aes(x = NA, y = as.numeric(endpoint), label = endpoint),
                       size = 4,
                       angle = 45,
                       fontface="bold",
                       na.rm = TRUE) +
    ggplot2::coord_flip() +
    ggplot2::scale_y_continuous(breaks = seq(1, nlevels(.data$endpoint), 1), labels = levels(.data$endpoint)) +
    ggplot2::facet_wrap(~ "Clinical Endpoints") +
    ggplot2::theme(
      panel.background = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      plot.background = ggplot2::element_blank(),
      plot.margin = ggplot2::unit(c(0, 0, 0, 0), "cm"),
      axis.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      strip.background = ggplot2::element_rect(fill = "#3d4c66"),
      strip.text = ggplot2::element_text(size = 15, colour = "white"),
      legend.position = "none"
    )
}
