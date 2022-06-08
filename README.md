
<!-- README.md is generated from README.Rmd. Please edit that file -->

# daiquiri

<!-- badges: start -->

[![R-CMD-check](https://github.com/phuongquan/daiquiri/workflows/R-CMD-check/badge.svg)](https://github.com/phuongquan/daiquiri/actions)
[![Codecov test
coverage](https://codecov.io/gh/phuongquan/daiquiri/branch/master/graph/badge.svg)](https://app.codecov.io/gh/phuongquan/daiquiri?branch=master)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

The daiquiri package generates data quality reports that enable quick
visual review of temporal shifts in record-level data. Time series plots
showing aggregated values are automatically created for each data field
(column) depending on its contents (e.g. min/max/mean values for numeric
data, no. of distinct values for categorical data), as well as overviews
for missing values, non-conformant values, and duplicated rows.

Essentially, it takes input such as this:

<img src="man/figures/example_data_head.png" width="700" />

And outputs this:

<img src="man/figures/example_data_aggregated_valuespresent.png" width="350" /><img src="man/figures/example_data_allfields_missing_perc.png" width="350" />

The resulting html reports are shareable and can contribute to forming a
transparent record of the entire analysis process. It is designed with
electronic health records in mind, but can be used for any type of
record-level temporal data.

## Why should I use it?

Large routinely-collected datasets are increasingly being used in
research. However, given their data are collected for operational rather
than research purposes, there is a greater-than-usual need for them to
be checked for data quality issues before any analyses are conducted.
Events occurring at the institutional level such as software updates,
new machinery or processes can cause temporal artefacts that, if not
identified and taken into account, can lead to biased results and
incorrect conclusions. For example, the figures below show real data
from a large hospital in the UK.

<img src="man/figures/antibiotics_day_DurationEnteredByPrescriber_missing_perc.png" width="350" /><img src="man/figures/bchem_creatinine_day_Value_mean.png" width="350" />

The first figure shows the percentage of missing values in the
‘Duration’ field of a dataset containing antibiotic prescriptions, and
the second figure shows the mean value of all laboratory tests checking
for levels of ‘creatinine’ in the blood. As you can see, these values
can sometimes change suddenly and unnaturally, and researchers need to
take this into account if comparing or combining the data before and
after these ‘change points’.

While these checks should theoretically be conducted by the researcher
at the initial data analysis stage, in practice it is unclear to what
extent this is actually done, since it is rarely, if ever, reported in
published papers. With the increasing drive towards greater transparency
and reproducibility within the scientific community, this essential yet
often-overlooked part of the analysis process will inevitably begin to
come under greater scrutiny. The daiquiri package helps researchers
conduct this part of the process more thoroughly, consistently and
transparently, hence increasing the quality of their studies as well as
trust in the scientific process.

## Installation

The intention is to make daiquiri available in CRAN but until then, you
can install the latest release by running the following:

``` r
# install dependencies
install.packages(c("data.table", "readr", "ggplot2", "scales", "cowplot", "rmarkdown", "reactable"))

# install daiquiri with pre-built vignettes
install.packages("https://github.com/phuongquan/daiquiri/releases/download/v0.7.0/daiquiri_0.7.0.tar.gz", 
                                 repos = NULL, type = "source")
```

Alternatively, you can install the current development version from
GitHub (though this may be more buggy):

``` r
#install.packages("devtools")
devtools::install_github("phuongquan/daiquiri")
```

## Usage

``` r
library(daiquiri)

rawdata <- read_data(
  system.file("extdata", "example_data.csv", package = "daiquiri"),
  delim = ",",
  col_names = TRUE
)

daiqobj <- create_report(
  rawdata,
  fieldtypes = fieldtypes(
    PrescriptionID = ft_uniqueidentifier(),
    PrescriptionDate = ft_timepoint(),
    AdmissionDate = ft_datetime(includes_time = FALSE),
    Drug = ft_freetext(),
    Dose = ft_numeric(),
    DoseUnit = ft_categorical(),
    PatientID = ft_ignore(),
    Location = ft_categorical(aggregate_by_each_category=TRUE)),
  override_columnnames = FALSE,
  na = c("", "NULL"),
  dataset_shortdesc = "Example data for illustration",
  aggregation_timeunit = "day",
  save_directory = ".",
  save_filename = "example_data_report",
  showprogress = TRUE,
  log_directory = NULL
)
```

More detailed guidance can be found in the walkthrough vignette:

``` r
vignette("daiquiri", package = "daiquiri")
```

## How to cite this package

Please remember to update the version number to match the version you
used.

> Quan TP (2022). daiquiri: Data quality reporting for temporal
> datasets. R package version v0.7.0. Zenodo.
> <https://doi.org/10.5281/zenodo.6334341>. URL:
> <https://github.com/phuongquan/daiquiri>

## Acknowledgements

This work was supported by the National Institute for Health Research
Health Protection Research Unit (NIHR HPRU) in Healthcare Associated
Infections and Antimicrobial Resistance at the University of Oxford in
partnership with Public Health England (PHE) (NIHR200915), and by the
NIHR Oxford Biomedical Research Centre.
