#----------------------------------------------------------#
#
#
#                 The FOSSILPOL workflow
#
#           Filter levels and sites by criteria
#
#
#   O. Mottl, S. Flantua, K. Bhatta, V. Felde, A. Seddon
#                         2023
#
#----------------------------------------------------------#

#  Filter out levels and records based on several criteria selected in
#   Config File


#----------------------------------------------------------#
# 1. Set up  -----
#----------------------------------------------------------#

library(here)

# Load configuration
source(
  here::here("R/00_Config_file.R")
)

# set the current environment
current_env <- rlang::current_env()

RUtilpol::output_heading(
  msg = "Start of process of record filtration"
)


#----------------------------------------------------------#
# 2. Load and prepare data -----
#----------------------------------------------------------#

data_harmonised <-
  RUtilpol::get_latest_file(
    file_name = "data_harmonised",
    dir = paste0(
      data_storage_path, # [config_criteria]
      "/Data/Processed/Data_harmonised"
    )
  )


# test the presence of data
RUtilpol::check_if_loaded(
  file_name = "data_harmonised",
  env = current_env
)



#----------------------------------------------------------#
# 2.Filter the data  -----
#----------------------------------------------------------#

data_filtered <-
  RFossilpol::proc_filter_all_data(
    data_source = data_harmonised,
    msg = paste(
      "Please revise the 'regional_age_limits' table in ",
      paste0(
        data_storage_path, # [config_criteria]
        "/Data/Input/Regional_age_limits/."
      ),
      "Then re-run script from '03_Merging_and_geography'"
    ),
    variable_vec = c(
      "levels",
      "raw_counts",
      "counts_harmonised",
      "age_uncertainty"
    ),
    filter_by_pollen_sum = filter_by_pollen_sum, # [config_criteria]
    filter_by_age_limit = filter_by_age_limit, # [config_criteria]
    filter_by_extrapolation = filter_by_extrapolation, # [config_criteria]
    filter_by_interest_region = filter_by_interest_region, # [config_criteria]
    filter_by_number_of_levels = filter_by_number_of_levels, # [config_criteria]
    min_n_grains = min_n_grains, # [config_criteria]
    target_n_grains = target_n_grains, # [config_criteria]
    percentage_samples = percentage_samples, # [config_criteria]
    maximum_age_extrapolation = maximum_age_extrapolation, # [config_criteria]
    min_n_levels = min_n_levels, # [config_criteria]
    use_age_quantiles = use_age_quantiles, # [config_criteria]
    use_bookend_level = use_bookend_level # [config_criteria]
  )


#----------------------------------------------------------#
# 3. Save   -----
#----------------------------------------------------------#

RUtilpol::save_latest_file(
  object_to_save = data_filtered,
  dir = paste0(
    data_storage_path, # [config_criteria]
    "/Data/Processed/Data_filtered/"
  ),
  prefered_format = "rds",
  use_sha = TRUE
)
