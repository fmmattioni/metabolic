
<!-- README.md is generated from README.Rmd. Please edit that file -->

# metabolic <img src='man/figures/logo.png' align="right" height="240" />

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/metabolic)](https://CRAN.R-project.org/package=metabolic)
[![R build
status](https://github.com/fmmattioni/metabolic/workflows/R-CMD-check/badge.svg)](https://github.com/fmmattioni/metabolic/actions)
[![Monthly downloads
badge](https://cranlogs.r-pkg.org/badges/last-month/metabolic?color=blue)](https://CRAN.R-project.org/package=metabolic)
[![Total downloads
badge](https://cranlogs.r-pkg.org/badges/grand-total/metabolic?color=blue)](https://CRAN.R-project.org/package=metabolic)
[![R-CMD-check](https://github.com/fmmattioni/metabolic/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fmmattioni/metabolic/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of `metabolic` is to provide all the data and the tools
necessary to reproduce the meta-analysis published in [Medicine &
Science in Sports &
Exercise](https://journals.lww.com/acsm-msse/Fulltext/2021/03000/Effectiveness_of_HIIE_versus_MICT_in_Improving.12.aspx).

## Installation

You can install the released version of `metabolic` from
[CRAN](https://CRAN.R-project.org/package=metabolic) with:

``` r
install.packages("metabolic")
```

You can install the development version of `metabolic` from from
[GitHub](https://github.com/fmmattioni/metabolic) with:

``` r
# install.packages("remotes")
remotes::install_github("fmmattioni/metabolic")
```

## Datasets

### Dataset to reproduce meta-analyses

``` r
metabolic::metabolic_meta
#> # A tibble: 391 × 21
#>    study       endpoint population   age category_age duration category_duration
#>    <chr>       <chr>    <fct>      <dbl> <fct>           <dbl> <fct>            
#>  1 Abdelbasse… BMI      T2D         54.6 > 50 y              8 5 - 10 weeks     
#>  2 Abdelbasse… HbA1c    T2D         54.6 > 50 y              8 5 - 10 weeks     
#>  3 Abdelbasse… HDL      T2D         54.6 > 50 y              8 5 - 10 weeks     
#>  4 Abdelbasse… HOMA-IR  T2D         54.6 > 50 y              8 5 - 10 weeks     
#>  5 Abdelbasse… LDL      T2D         54.6 > 50 y              8 5 - 10 weeks     
#>  6 Abdelbasse… Total C… T2D         54.6 > 50 y              8 5 - 10 weeks     
#>  7 Abdelbasse… Triglyc… T2D         54.6 > 50 y              8 5 - 10 weeks     
#>  8 Bækkerud 2… Body Ma… Overweigh…  40   30 - 50 y           6 5 - 10 weeks     
#>  9 Bækkerud 2… Flow-me… Overweigh…  40   30 - 50 y           6 5 - 10 weeks     
#> 10 Bækkerud 2… VO2max   Overweigh…  40   30 - 50 y           6 5 - 10 weeks     
#> # ℹ 381 more rows
#> # ℹ 14 more variables: men_ratio <dbl>, category_men_ratio <fct>,
#> #   type_exercise <chr>, bsln <dbl>, bsln_adjusted <dbl>, category_bsln <fct>,
#> #   N_HIIE <dbl>, Mean_HIIE <dbl>, SD_HIIE <dbl>, N_MICT <dbl>,
#> #   Mean_MICT <dbl>, SD_MICT <dbl>, HIIE <chr>, desired_effect <chr>
```

### Dataset to build the GOfER diagram

``` r
metabolic::metabolic_gofer
#> # A tibble: 115 × 33
#>    study            groups sample_population   sample_fitness sample_men_ratio
#>    <chr>            <chr>  <chr>               <chr>                     <dbl>
#>  1 Abdelbasset 2020 HIIT   "T2D"               N/R                        0.63
#>  2 Abdelbasset 2020 MICT   "T2D"               N/R                        0.53
#>  3 Bækkerud 2016    HIIT   "Overweight\nObese" Sedentary                  0.41
#>  4 Bækkerud 2016    MICT   "Overweight\nObese" Sedentary                  0.41
#>  5 Beetham 2019     HIIT   "Overweight\nObese" Active                     0.66
#>  6 Beetham 2019     MICT   "Overweight\nObese" Active                     0.8 
#>  7 Burgomaster 2008 SIT    "Healthy"           Sedentary                  0.5 
#>  8 Burgomaster 2008 MICT   "Healthy"           Sedentary                  0.5 
#>  9 Ciolac 2010      HIIT   "Healthy"           Sedentary                  0   
#> 10 Ciolac 2010      MICT   "Healthy"           Sedentary                  0   
#> # ℹ 105 more rows
#> # ℹ 28 more variables: anamnese_smoker <chr>,
#> #   anamnese_medicines_to_control_BP <chr>, age <dbl>,
#> #   design_type_of_exercise <chr>, design_sample_size <chr>,
#> #   design_training_duration <dbl>, design_training_frequency <chr>,
#> #   design_exercise_intensity <chr>, hiie_n_reps <chr>,
#> #   hiie_rep_duration <chr>, hiie_work_rest_ratio <chr>, compliance <dbl>, …
```

## Reproduce meta-analysis for each clinical endpoint

``` r
library(metabolic)

perform_meta(endpoint = "VO2max")
#> ──────────────────────────  * VO2max meta-analysis *  ──────────────────────────
#> ✔ 'Overall'
#> ✔       └─ Performing meta-analysis
#> ✔       └─ Performing sensitivity analysis
#> ✔                └─ Meta-analysis results are robust! Keep going!
#> ✔ Performing meta-analysis and meta-regression on the Population subgroup
#> 
#> ✔ Performing meta-analysis and meta-regression on the Age subgroup
#> 
#> ✔ Performing meta-analysis and meta-regression on the Training Duration subgroup
#> 
#> ✔ Performing meta-analysis and meta-regression on the Men Ratio subgroup
#> 
#> ✔ Performing meta-analysis and meta-regression on the Type of Exercise subgroup
#> 
#> ✔ Performing meta-analysis and meta-regression on the Baseline subgroup
#> 
#> ✔ Performing meta-analysis and meta-regression on the Type of HIIE subgroup
#> 
#> ──────────────────────────────────  * DONE *  ──────────────────────────────────
#> # A tibble: 8 × 4
#>   subgroup          meta_analysis sensitivity_analysis meta_regression
#>   <chr>             <named list>  <named list>         <named list>   
#> 1 Overall           <metacont>    <metainf>            <lgl [1]>      
#> 2 Population        <metacont>    <lgl [1]>            <metareg>      
#> 3 Age               <metacont>    <lgl [1]>            <metareg>      
#> 4 Training Duration <metacont>    <lgl [1]>            <metareg>      
#> 5 Men Ratio         <metacont>    <lgl [1]>            <metareg>      
#> 6 Type of Exercise  <metacont>    <lgl [1]>            <metareg>      
#> 7 Baseline Values   <metacont>    <lgl [1]>            <metareg>      
#> 8 Type of HIIE      <metacont>    <lgl [1]>            <metareg>
```

## Build a GOfER (Graphical Overview for Evidence Reviews) diagram

<img src="vignettes/img/gofer_page_1.png" width="100%" />

## Citation

``` r
citation("metabolic")
#> To cite metabolic in publications use:
#> 
#>   Maturana M, Felipe, Martus, Peter, Zipfel, Stephan, Nieß, M A (2020).
#>   "Effectiveness of HIIE versus MICT in Improving Cardiometabolic Risk
#>   Factors in Health and Disease: a meta-anaylsis." _Medicine & Science
#>   in Sports & Exercise_, *Published Ahead of Print*.
#>   doi:10.1249/MSS.0000000000002506
#>   <https://doi.org/10.1249/MSS.0000000000002506>,
#>   <https://journals.lww.com/acsm-msse/Fulltext/2021/03000/Effectiveness_of_HIIE_versus_MICT_in_Improving.12.aspx>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Article{,
#>     title = {Effectiveness of HIIE versus MICT in Improving Cardiometabolic Risk Factors in Health and Disease: a meta-anaylsis},
#>     author = {Mattioni Maturana and {Felipe} and {Martus} and {Peter} and {Zipfel} and {Stephan} and {Nieß} and Andreas M},
#>     journal = {Medicine & Science in Sports & Exercise},
#>     volume = {Published Ahead of Print},
#>     year = {2020},
#>     url = {https://journals.lww.com/acsm-msse/Fulltext/2021/03000/Effectiveness_of_HIIE_versus_MICT_in_Improving.12.aspx},
#>     doi = {10.1249/MSS.0000000000002506},
#>   }
```
