#' Build HTML report
#'
#' Build an HTML report with all the results from the chosen clinical endpoint
#'
#' @param endpoint The clinical endpoint to build the HTML report.
#' @param path Path to write to. It has to be a character string indicating the path and file name (without the extension). For example, `~/Documents/metabolic_report` will save `metabolic_report.html` to the `Documents` folder.
#' @param format The file extension that you want to build the report with. Only `.html`, is supported.
#'
#' @return an HTML file.
#' @export
#'
#' @examples
#' if(interactive()) {
#' # Build an HTML report on VO2max
#' build_report(endpoint = "VO2max", path = tempfile())
#' }
build_report <- function(
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
  ),
  path,
  format = ".html"
) {
  endpoint <- match.arg(endpoint)

  path <- paste0(path, format)

  ## render html file based on template
  rmarkdown::render(
    input = system.file("endpoint-report-level-1.Rmd", package = "metabolic"),
    output_file = path,
    params = list(endpoint = endpoint)
  )

  ## this will open the file once rendered
  system2("open", path)
}
