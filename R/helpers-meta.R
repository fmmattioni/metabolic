#' Detect single-study influence
#'
#' Detect whether meta-analysis is being influenced by a single study. If so, remove the study from the overall results.
#'
#' @param x A \code{meta} object.
#' @keywords internal
#'
#' @importFrom utils head tail
detect_sensitivity <- function(x) {
  chkclass(x = x, class = "meta")

  p_values <- head(x$pval, -2)

  studies <- head(x$studlab, -2) %>%
    stringr::str_remove("Omitting ")

  overall_p_value <- tail(x$pval, 1)

  overall_sig <- ifelse(overall_p_value < 0.05, "yes", "no")

  find_studies <- tibble(
    study = studies,
    p_val = p_values,
    overall = overall_sig
  ) %>%
    dplyr::mutate(study_sig = ifelse(p_val < 0.05, "yes", "no"),
                  same_as_overall = overall == study_sig)

  n_studies <- find_studies %>%
    dplyr::count(different = same_as_overall == FALSE) %>%
    dplyr::filter(different == TRUE) %>%
    dplyr::pull(n)

  if(purrr::is_empty(n_studies))
    n_studies <- 0

  if(n_studies == 1L) {
    out <- find_studies %>%
      dplyr::filter(same_as_overall == FALSE) %>%
      dplyr::pull(study)
  } else {
    out <- NA
  }

  out
}
