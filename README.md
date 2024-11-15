# pump-assessment-fnafp-cafp-fish-sensors
Assessment of the mortality and injury of fish passing the Fairbanks Nijhuis Axial Flow Pumps (FNAFPs) and Conventional Axial Flow Pumps (CAFPs) of the Duivelsput pumping station (Vinderhoute, Oude Kale, Belgium). Barotrauma Detection Sensors (BDS) are also analyzed. It is important to go through all Rmd files alphabetically at least ones as some necessary files will be created along the way. 
## Repository structure
* data
   * fish
      * external: the fish data that is used as input for the files is stored here. A distinction is made between:
        * processed_in_excel: corrections made to the data in the file itself.
        * raw: original data, as it was delivered at the start of this repository.
      * internal: The processed data (processing in fish_main.Rmd) is stored here. These data are then used for the different modelling scripts.
   * bds
      * external: the BDS data that is used as input for the files is stored here. The data can be retrieved from: https://doi.org/10.5281/zenodo.14160723. A distinction is made between:
        * Old_Axial_n_6: Data of sensors which were put through the CAFP
        * Pump_40Hz_Control_n_13: Data of sensors which were put right after the FNAFP operating at low rpm and functioned as control measurements
        * Pump_40Hz_n_64: Data of sensors which were put through the FNAFP operating at low rpm
        * Pump_47Hz_Control_n_15: Data of sensors which were put right after the FNAFP operating at high rpm and functioned as control measurements
        * Pump_47Hz_n_51: Data of sensors which were put through the FNAFP operating at high rpm
      * internal: The processed data (processing in bds_main.Rmd) is stored here. These data are then used for the analysis script (bds_analysis) and visualisation script (bds_visualisation.Rmd).
* figures
  * additional: figures not used in the manuscript
  * manuscript: figures used in the manuscript
* source
  * functions: all self-made functions are stored here
    * correct_ROI_manually.R: In case a Region of Interest (ROI) for a certain BDS is incorrect, change it manually.                      
    * export_emmeans.R:                            
    * log_model_state.R:                          
    * plot_histogram_length_weight_distribution.R: 
    * read_excel_allsheets.R:                      
    * rmse.R:                                      
    * round_df.R:                                  
    * run_chi_squared.R:                           
    * source_rmd.R:                                
    * stats_data_level1.R: Aggregation function to yield number of recaptured fish per scenario and fin cut                        
    * stats_data_level2a.R: Aggregation function to yield number of recaptured fish per scenario   
  * not_functions: all scripts that are not functions are stored here
    * add_missing_folders.R: create necessary folders if they do not exist already
    * clean_data_forced.R: clean the FNAFP data
    * clean_data_natural.R: clean the CAFP data
    * libraries.R: all used libraries are given here
* gitignore: determines which files to pull and push from and to github
* a1_fish_main.Rmd: Clean fish data and exploratory analysis
* a2_fish_np_models_FNAFP.Rmd: Non-parametric models to assess:
  * whether there are any differences in length distributions between scenarios
  * whether there are any differences in mortality and number of injuries between scenarios
* a3_fish_dt_CAFP.Rmd: Decision trees to assess the effect of different factors on the probability of being injured and being alive
  * for FNAFP and CAFP for roach.
* a3_fish_dt_FNAFP.Rmd: Decision trees to assess the effect of different factors on the probability of being injured and being alive
  * for FNAFP for roach, bream and eel.
* a4_fish_logistic_models_CAFP.Rmd: Logistic models to assess the effect of different factors on the probability of being alive
  * for FNAFP and CAFP for roach.
* a4_fish_logistic_models_FNAFP.Rmd: Logistic models to assess the effect of different factors on the probability of being alive
  * for FNAFP for roach, bream and eel.
* a4_fish_multinomial_CAFP.Rmd: Multinomial models to assess the effect of different factors on the probability of being injured
  * for FNAFP and CAFP for roach.
* a4_fish_multinomial_FNAFP.Rmd: Multinomial models to assess the effect of different factors on the probability of being injured
  * for FNAFP for roach, bream and eel.
* a5_fish_power_analysis_FNAFP.Rmd: Power analysis to determine sample size based on mortality analysis for FNAFP
* b1_bds_main.Rmd: Clean BDS timeseries and exploratory analysis
  * Metadata BDS: https://biorobotics.pages.taltech.ee/bds/en/description/
* b2_bds_analysis.Rmd: Analysis BDS timeseries
* b3_bds_visualisation.Rmd: Visualisation BDS timeseries
* b4_bds_shear_stress.Rmd: Calculation of shear stress
 

