# description: function to aggregate the data per scenario
# input: aggregated data (= output from function stats_data_level1)

stats_data_level2a<-function(data,columns_to_group){
  data_stats_level2 <- data %>% 
    group_by(across(all_of(columns_to_group))) %>%
    mutate_at(vars(contains("Class")),~sum(., na.rm = TRUE)) %>%
    mutate_at(vars(contains("Injury_type")),~sum(., na.rm = TRUE)) %>%
    mutate(number_recaptured = case_when(any(columns_to_group=="Fin_cut")==FALSE ~ sum(number_recaptured),
                                         any(columns_to_group=="Fin_cut")==TRUE ~ mean(number_recaptured))) %>%
    mutate(number_of_released_fish = case_when(any(columns_to_group=="Fin_cut")==FALSE ~ sum(number_of_released_fish),
                                               any(columns_to_group=="Fin_cut")==TRUE ~ mean(number_of_released_fish))) %>%
    mutate(min_state = min(percentage_state_test),
           max_state = max(percentage_state_test),
           number_state_binom = sum(number_state_binom), #Take the sum over all replicates instead of the average
           #number_of_released_fish = mean(number_of_released_fish), #Take the sum over all replicates instead of the average
           percentage_state_test=round((number_state_binom/number_recaptured)*100)) %>% #Percentage is recalculated here: replicates with more individuals will have a larger effect on the average. If this line is left out then each replicate will contribute equally to the average and there will be a small difference between number_state_binom/number_recaptured and percentage_state_test. 15/9/2022: Since there is a mismatch between the theoretical and observed scenario some 'new' samples are created. Check it out here: https://github.com/spbruneel-INBO/Turbine-and-pump-tests-Oude-Kale-and-Groot-Schijn/issues/9#issue-1373632925 
    summarize(across(where(is.numeric), ~ mean(.x, na.rm = TRUE)))
  return(data_stats_level2)
}