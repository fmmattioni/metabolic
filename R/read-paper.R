#' Read the paper
#'
#' This function will open the published paper in the journal website for you to read it in your default browser.
#'
#' @export
#'
#' @examples
#' read_paper()
#'
#' @importFrom utils browseURL
read_paper <- function() {
  browseURL(url = "https://journals.lww.com/acsm-msse/Abstract/9000/Effectiveness_of_HIIE_versus_MICT_in_Improving.96194.aspx")
}
