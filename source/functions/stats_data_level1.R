# description: function to aggregate the data per scenario and per fin cut
# input: cleaned, not-aggregated data
stats_data_level1<-function(data){
  data_stats_level1 <- data %>% 
    dplyr::select(-Individuals_ID) %>%
    group_by(Species, Pump_type, Frequency, Frequency_theoretical, rpm, Control, Fin_cut) %>%
    mutate(number_recaptured = n()) %>% 
    ungroup() %>%
    group_by(Species, Pump_type, Frequency, Frequency_theoretical, rpm, Fin_cut, Control, State) %>%
    mutate(number_state_binom = n(),number_recaptured=mean(number_recaptured)) %>%
    mutate_at(vars(contains("Class")),~sum(.)) %>%
    mutate_at(vars(contains("Injury_type")),~sum(.)) %>%
    #mutate_at(vars(contains('Class')), .funs = list(perc = ~./number_state_binom)) %>%
    mutate(percentage_state_test=round((number_state_binom/number_recaptured)*100)) %>%
    summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) %>%
    ungroup() %>%
    group_by(Species, Pump_type, Frequency, Frequency_theoretical, rpm, Control) %>%
    complete(Fin_cut, State=c("Alive","Dead"), fill = list(percentage_state_test = 0, number_state_binom = 0)) %>%
    fill(number_recaptured, .direction = "downup") %>%
    fill(number_of_released_fish, .direction = "downup") 
  #rename_with(~gsub("Class_","",.x),starts_with("Class_"))
  return(data_stats_level1)
}