# Function to clean OK data
clean_data_OK<-function(data,Controle,outlier.removal=FALSE){
  
  print(dim(data))
  
  #Change column names 1
  data=setnames(data, old = c("Discharge"), new = c("Frequency"),skip_absent=TRUE)
  
  #Remove columns 1
  drop <- c("Test_group","Damage_precise","Euthansia","Photo_code","Remarks")
  data = data[,!(names(data) %in% drop)]
  data$`Controle: ja/nee`<-NULL
  
  #Add columns 1
  data$SampleSize<-NA
  data$Capture_Location<-NA
  data$Location<-"OK"
  data$Pump_type<-"FNAFP"
  data$Individuals_ID=c(1:nrow(data))
  
  data<-data[data$Species != c('baars'),]
  
  #Change column content 1
  data$Fin_cut=paste(data$Fin_cut,data$Date_input)
  
  if(any(str_detect(data$Frequency,":"))==TRUE){
    data[c("Frequency","SampleSize")]<-as.data.frame(str_split_fixed(data$Frequency,":",n=2))
  }
  
  data$Frequency<-data$`Werkelijk toerental`; data$`Werkelijk toerental`<-NULL
  data$Frequency[data$Frequency=="40Hz"]<-"40"  
  data$Frequency[data$Frequency=="47Hz"]<-"47" 
  
  number_of_released_fish<-read_excel("./data/fish/external/processed_in_excel/number_of_individuals_OK.xlsx")[,c("Date_input","Fin_cut","Species","Frequency_theoretical","Controle","number_of_released_fish","Remarks")]
  number_of_released_fish$Frequency_theoretical=as.character(number_of_released_fish$Frequency_theoretical)
  number_of_released_fish$Fin_cut=paste(number_of_released_fish$Fin_cut,number_of_released_fish$Date_input)
  number_of_released_fish=number_of_released_fish[which(number_of_released_fish$Species==unique(data$Species)),]
  number_of_released_fish <- number_of_released_fish %>% group_by(Species, Frequency_theoretical, Controle) %>% mutate(number_of_released_fish_per_scenario=sum(number_of_released_fish))
  print("Missing fin cut")
  print(unique(number_of_released_fish$Fin_cut[!(number_of_released_fish$Fin_cut %in% data$Fin_cut)]))
  print("Fin cut too many")
  print(unique(data$Fin_cut[!(data$Fin_cut %in% number_of_released_fish$Fin_cut)]))
  print(table(number_of_released_fish$Fin_cut,number_of_released_fish$Species))
  number_of_released_fish$Date_input<-NULL
  data <- left_join(data,number_of_released_fish, by=c("Fin_cut","Species"))
  if (Controle=="No"){data<-data[which(data$Controle=="nee"),] }
  if (Controle=="Yes"){data<-data[which(data$Controle=="ja"),] }
  if (Controle=="Both"){}
  
  data$Frequency[which(str_detect(data$Frequency,"47")==TRUE)]=47 #Frequency values with a question mark are considered valid if accompanied with an estimate
  data$Frequency[which(str_detect(data$Frequency,"40")==TRUE)]=40 #Frequency values with a question mark are considered valid if accompanied with an estimate
  
  data$Length <- gsub('ong. ', '',
                      gsub('	+/-', '',
                           gsub('ong ', '', data$Length)))
  data$Length[which(data$Length=="?")]=NA
  
  data$Weight <- gsub('ong. ', '',
                      gsub('ong ', '', data$Weight))
  data$Weight[which(data$Weight=="?")]=NA
  
  data$Length<-as.numeric(data$Length)
  data$Weight<-as.numeric(data$Weight)
  
  #Select data
  data<-data[which(data$Frequency %in% c("40","47","Control")),]
  
  data <- data %>% mutate_at(vars(contains("Class")), as.numeric)
  data <- data %>% mutate_at(vars(contains("Class")), ~replace(., !is.na(.), 1))
  data <- data %>% mutate_at(vars(contains("Class")), ~replace(., is.na(.), 0))
  data <- data %>% mutate(Number_Injuries = rowSums(dplyr::select(., contains("Class"))))
  
  #Change column content 2 
  data$State[data$State=="levend"]<-"Alive"
  data$State[data$State=="dood"]<-"Dead"
  data$State[data$State=="stervend"]<-"Dying"
  data$State[data$State=="Dying"]<-"Dead"
  data$State[which(is.na(data$State)==TRUE)]="Alive"
  
  data$State[which(data$Class_3.1==1 | data$Class_3.2==1 | data$Class_3.3==1 |
                     data$Class_3.4==1 | data$Class_3.5==1 | data$Class_3.6==1 | data$Class_3.7==1 |
                     data$Class_4==1 |
                     data$Remarks=="stervend")]<-"Dead"
  
  #Add columns 2
  data$Pump_type_Frequency = paste(data$Pump_type,data$Frequency)
  data$Pump_type_Frequency_Controle <- paste(data$Frequency,data$Pump_type,data$Controle)
  data$Scenario_rep = paste(data$Pump_type,data$Frequency,data$Species,data$Fin_cut)
  data$Scenario_control = paste(data$Species,data$Date_input)
  data$Species_Fin_cut = paste(data$Species,data$Fin_cut)
  
  data$Injury_type_no=0
  data$Injury_type_no[which(data$Class_1==1)]=1
  data$Injury_type_slight=0
  data$Injury_type_slight[which(data$Class_2.1==1 | data$Class_2.2==1 | data$Class_2.3==1)]=1
  data$Injury_type_severe=0
  data$Injury_type_severe[which(data$Class_3.1==1 | data$Class_3.2==1 | data$Class_3.3==1 | data$Class_3.4==1 | data$Class_3.5==1 | data$Class_3.6==1 | data$Class_3.7==1)]=1
  data$Injury_type_dead=0
  data$Injury_type_dead[which(data$Class_4==1)]=1
  
  data$Injury_type_slight[which(data$Injury_type_severe==1)]=0
  #data$Injury_type_severe[which(data$Injury_type_dead==1)]=1

  # #Imputation of missing values
  model_length<-lm(Length~Weight,data=data)
  data$Length[which(is.na(data$Length)==TRUE)]=predict(model_length,data[which(is.na(data$Length)==TRUE),])
  
  #data[sapply(data, is.character)] <- lapply(data[sapply(data, is.character)], as.factor)
  
  data$rpm<-NA
  data$rpm[which(data$Frequency=="47")]="550"
  data$rpm[which(data$Frequency=="40")]="468"
  data$rpm<-as.factor(data$rpm)
  data$Pump_type_rpm = paste(data$Pump_type," - ",data$rpm," rpm",sep="")

  print(table(data$Frequency_theoretical,data$Frequency))
  
  print(dim(data))
  
  data=setnames(data, old = c("Controle"), new = c("Control"),skip_absent=TRUE)
  data$Control[data$Control=="ja"]<-"control"
  data$Control[data$Control=="nee"]<-"pump"
  
  data$Species[data$Species=="paling"]<-"eel"
  data$Species[data$Species=="blankvoorn"]<-"roach"
  data$Species[data$Species=="brasem"]<-"bream"
  
  #Check for and remove outliers
  if (outlier.removal==TRUE){
    original.length<-nrow(data)
    quartiles <- quantile(data$Length, probs=c(.25, .75), na.rm = TRUE)
    IQR <- IQR(data$Length,na.rm = TRUE)
    Lower <- quartiles[1] - 3*IQR
    Upper <- quartiles[2] + 3*IQR
    data <- subset(data, data$Length > Lower & data$Length < Upper)
    print(paste(original.length-nrow(data)," outliers have been removed",sep=""))
  }
  
  return(data)
}