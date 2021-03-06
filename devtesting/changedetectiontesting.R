# interactive testing during development

# set up conditions for testing
# Restart R: Ctrl-Shift-F10
rm(list = ls())
devtools::load_all(".", reset = TRUE)

# create log file
log_initialise("./devtesting/testoutput")

# test against example dataset
testfile <- "./inst/extdata/example_data.csv"
testdf <- read_data(testfile)
testfile_fieldtypes <- fieldtypes(PrescriptionID = ft_uniqueidentifier()
																	,PrescriptionDate = ft_timepoint()
																	,AdmissionDate = ft_datetime(includes_time = FALSE)
																	,Drug = ft_freetext()
																	,Dose = ft_numeric()
																	,DoseUnit = ft_categorical()
																	,PatientID = ft_ignore()
																	,Location = ft_categorical(aggregate_by_each_category=TRUE))

daiqobj <- create_report(testdf,
													fieldtypes = testfile_fieldtypes,
													override_columnnames = FALSE,
													na = c("","NULL"),
													aggregation_timeunit = "day",
													save_directory = "./devtesting/testoutput",
													save_filename = NULL,
													showprogress = TRUE,
													log_directory = "./devtesting/testoutput")

testsourcedata <- prepare_data(testdf, fieldtypes = testfile_fieldtypes, na=c("","NULL"), showprogress=TRUE)
testdata_byday <- aggregate_data(testsourcedata, aggregation_timeunit = "day", showprogress = TRUE)
report_data(testsourcedata, testdata_byday)


# complete test set
testdf <- read_data(test_path("testdata", "completetestset.csv"))
testsourcedata <- prepare_data(testdf,
															 fieldtypes = fieldtypes( col_timepoint_err = ft_ignore(),
															 												 col_timepoint = ft_timepoint(),
															 												 col_date_time_err = ft_ignore(),
															 												 col_date_time = ft_datetime(),
															 												 col_date_only_err = ft_ignore(),
															 												 col_date_only = ft_datetime(includes_time = FALSE),
															 												 col_date_uk_err = ft_ignore(),
															 												 col_date_uk = ft_datetime(includes_time = FALSE, format = "%d/%m/%Y"),
															 												 col_id_num_err = ft_ignore(),
															 												 col_id_num = ft_uniqueidentifier(),
															 												 col_id_string_err = ft_ignore(),
															 												 col_id_string = ft_uniqueidentifier(),
															 												 col_numeric_clean_err = ft_ignore(),
															 												 col_numeric_clean = ft_numeric(),
															 												 col_numeric_dirty_err = ft_ignore(),
															 												 col_numeric_dirty = ft_numeric(),
															 												 col_categorical_small_err = ft_ignore(),
															 												 col_categorical_small = ft_categorical(aggregate_by_each_category = TRUE),
															 												 col_categorical_large_err = ft_ignore(),
															 												 col_categorical_large = ft_categorical(),
															 												 col_freetext_err = ft_ignore(),
															 												 col_freetext = ft_freetext(),
															 												 col_simple_err = ft_ignore(),
															 												 col_simple = ft_simple()),
															 dataset_shortdesc = "completetestset",
															 showprogress = FALSE
)


# test modification of df passed into function
df <- data.frame(a=1:5, b = "hi")
testmodset <- function(df){
	dt <- setDT(df)
	dt
}
tracemem(df)
res <- testmod(df)
class(df)
tracemem(df)
class(res)
tracemem(res)

df <- data.frame(a=1:5, b = "hi")
testmodas <- function(df){
	dt <- as.data.table(df)
	dt
}
tracemem(df)
res <- testmodas(df)
class(df)
tracemem(df)
class(res)
tracemem(res)

