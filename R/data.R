#' Dataset for building a GOfER diagram (Graphical Overview for Evidence Reviews)
#'
#' A dataset containing the summary of the studies included in the meta-analysis.
#' This dataset is used to build a GOfER with 'ggplot2' and 'patchwork'.
#'
#' @format A data frame with 115 rows and 33 variables:
#' \describe{
#'   \item{study}{last name of first author and year of publication}
#'   \item{groups}{group allocated in the study, it may be either: HIIT (High-intensity Interval Training), SIT (Sprint Interval Training), or MICT (Moderate-intensity Continuous Training)}
#'   \item{sample_population}{population category from the study, it may be either: Healthy, Overweight/obese, Cardiac Rehabilitation, Metabolic Syndrome, or T2D (Type-2 Diabetes)}
#'   \item{sample_fitness}{the general fitness condition of the sample reported in the study, it may be either: Active, Sedentary, or N/R (Not Reported)}
#'   \item{sample_men_ratio}{the men ratio (total men divided by sample size) reported in the study}
#'   \item{anamnese_smoker}{information whether participants in the sample were smokers, it may either: Y (Yes), N (No), or N/R (Not Reported)}
#'   \item{anamnese_medicines_to_control_BP}{information whether participants in the sample were taking regular medication to control blood pressure, it may either: Y (Yes), N (No), or N/R (Not Reported)}
#'   \item{age}{the age of each group reported in the study, in years}
#'   \item{design_type_of_exercise}{the type of exercise used for exercise training, it may be either running or cycling}
#'   \item{design_sample_size}{the sample size of each group in the study}
#'   \item{design_training_duration}{the training duration, in weeks}
#'   \item{design_training_frequency}{the training frequency for each group used in the study}
#'   \item{design_exercise_intensity}{the prescribed exercise intensity for each group}
#'   \item{hiie_n_reps}{number of repetitions prescribed for the HIIE (High-intensity Interval Exercise) protocol}
#'   \item{hiie_rep_duration}{length of repetitions prescribed for the HIIE (High-intensity Interval Exercise) protocol}
#'   \item{hiie_work_rest_ratio}{the work-rest ratio in the HIIE (High-intensity Interval Exercise) protocol}
#'   \item{compliance}{compliance reported in each group and study}
#'   \item{endpoints_vo2max}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on VO2max (maximal oxygen uptake). If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_fmd}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on Flow-mediated Dilation. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_body_mass}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on Body Mass. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_body_fat}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on Body Fat. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_sbp}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on Systolic Blood Pressure. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_dbp}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on Diastolic Blood Pressure. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_hdl}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on HDL. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_ldl}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on LDL. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_triglycerides}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on Triglycerides. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_total_cholesterol}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on Total Cholesterol. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_insulin}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on Fasting Insulin. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_glucose}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on Fasting Glucose. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_homa}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on HOMA-IR (insulin resistance). If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_bmi}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on BMI (body mass index). If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_crp}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on C-reactive Protein. If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#'   \item{endpoints_hba1c}{information on whether the reported p-value was singificant comparing the effects pre- and post-training on HbA1c (glycated hemoglobin). If Yes, the reported p-value was less than 0.05; if No, the reported p-value was greater than 0.05}
#' }
#' @source \url{https://journals.lww.com/acsm-msse/Abstract/9000/Effectiveness_of_HIIE_versus_MICT_in_Improving.96194.aspx}
"metabolic_gofer"

#' Dataset for reproducing the meta-analysis
#'
#' A dataset containing the processed data from the studies necessary to reproduce the meta-analysis.
#'
#' @format A data frame with 391 rows and 21 variables:
#' \describe{
#'   \item{study}{last name of first author and year of publication}
#'   \item{endpoint}{the clinical endpoint analyzed, it may be either: VO2max (maximal oxygen uptake), Flow-mediated Dilation, BMI (body mass index), Body Mass, Body Fat, Systolic Blood Pressure, Diastolic Blood Pressure, HDL, LDL, Triglycerides, Total Cholesterol, C-reactive Protein, Fasting Insulin, Fasting Glucose, HbA1c (glycated hemoglobin), or HOMA-IR (insulin resistance)}
#'   \item{population}{population category from the study, it may be either: Healthy, Overweight/obese, Cardiac Rehabilitation, Metabolic Syndrome, or T2D}
#'   \item{age}{the median age between the groups in the study, in years}
#'   \item{category_age}{age category based on the age column, it may be either: < 30 y, 30 - 50 y, or > 50 y}
#'   \item{duration}{the training duration, in weeks}
#'   \item{category_duration}{training duration category based on the duration column, it may be either: < 5 weeks, 5 - 10 weeks, or > 10 weeks}
#'   \item{men_ratio}{the men ratio (total men divided by sample size) reported in the study}
#'   \item{category_men_ratio}{men ratio category based on the men_ratio column, it may be either: < 0.5 or > 0.5}
#'   \item{type_exercise}{the type of exercise used for exercise training, it may be either running or cycling}
#'   \item{bsln}{the baseline value reported for the clinical endpoint (the median between groups is used)}
#'   \item{bsln_adjusted}{the adjusted baseline value for the clinical endpoint. Values were adjusted according to their categories described in the paper. For example, VO2max values were adjusted to their age and sex percentile ranks, etc. From these values, the categories are defined in 'category_bsln'}
#'   \item{category_bsln}{the baseline category based on the bsln column}
#'   \item{N_HIIE}{sample size of the HIIE (High-intensity Interval Exercise) group}
#'   \item{Mean_HIIE}{mean difference between pre- and post-training in the HIIE (High-intensity Interval Exercise) group}
#'   \item{SD_HIIE}{standard deviation of the difference between pre- and post-training in the HIIE (High-intensity Interval Exercise) group}
#'   \item{N_MICT}{sample size of the MICT (Moderate-intensity Continuous Training) group}
#'   \item{Mean_MICT}{mean difference between pre- and post-training in the MICT (Moderate-intensity Continuous Training) group}
#'   \item{SD_MICT}{standard deviation of the difference between pre- and post-training in the MICT (Moderate-intensity Continuous Training) group}
#'   \item{HIIE}{the type of HIIE used in the study: it may be either: HIIT (High-intensity Interval Training) or SIT (Sprint Interval Training)}
#'   \item{desired_effect}{the desired effect expected for post-training improvements. This is needed simply to display the effects related to HIIE and MICT on the same side of the forest plot throughout the clinical endpoints}
#' }
#' @source \url{https://journals.lww.com/acsm-msse/Abstract/9000/Effectiveness_of_HIIE_versus_MICT_in_Improving.96194.aspx}
"metabolic_meta"
