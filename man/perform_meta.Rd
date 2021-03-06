% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/meta.R
\name{perform_meta}
\alias{perform_meta}
\title{Perform meta-analysis}
\usage{
perform_meta(
  endpoint = c("VO2max", "Flow-mediated Dilation", "BMI", "Body Mass", "Body Fat",
    "Systolic Blood Pressure", "Diastolic Blood Pressure", "HDL", "LDL", "Triglycerides",
    "Total Cholesterol", "C-reactive Protein", "Fasting Insulin", "Fasting Glucose",
    "HbA1c", "HOMA-IR")
)
}
\arguments{
\item{endpoint}{The clinical endpoint to perform the meta-analysis and meta-regression.}
}
\value{
a \link[tibble:tibble-package]{tibble} with named lists.
}
\description{
Perform the meta-analysis, sensitivity analysis, and meta-regression on the chosen clinical endpoint.
}
\examples{
if (interactive()) {
# Perform meta-analysis on VO2max
results <- perform_meta(endpoint = "VO2max")
results

# Access results of Overall meta-analysis
results$meta_analysis$Overall

# Acess results of Age meta-regression
results$meta_regression$Age
}
}
