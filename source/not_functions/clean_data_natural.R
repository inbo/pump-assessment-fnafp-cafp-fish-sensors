# Function to clean OK data
clean_data_OK_natural<-function(data,Controle,outlier.removal=FALSE){
  
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
  data$Pump_type<-"CAFP"
  data$Individuals_ID=c(1:nrow(data))
  
  drop_species<-c("baars","bittervoorn","blauwbandgrondel","snoek","paling")
  data<-data[!data$Species %in% drop_species,]
  
  #Change column content 1
  data$Fin_cut=paste(data$Fin_cut,data$Date_input)
  
  
  data<-data[data$Frequency!=1,]
  data$Frequency<-NA
  
  data$Length<-as.numeric(data$Length)
  data$Weight<-as.numeric(data$Weight)
  
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
                     data$Class_4==1)]<-"Dead"
  
  #Add columns 2
  data$Control = "pump"
  data$Pump_type_Frequency = data$Pump_type
  data$Pump_type_Frequency_Controle <- data$Pump_type
  data$Scenario_rep = paste(data$Pump_type,data$Species)
  data$Scenario_control = paste(data$Species,data$Date_input)
  data$Species_Fin_cut = paste(data$Species)
  
  data$Injury_type_no=0
  data$Injury_type_no[which(data$Class_1==1)]=1
  data$Injury_type_slight=0
  data$Injury_type_slight[which(data$Class_2.1==1 | data$Class_2.2==1 | data$Class_2.3==1)]=1
  data$Injury_type_severe=0
  data$Injury_type_severe[which(data$Class_3.1==1 | data$Class_3.2==1 | data$Class_3.3==1 | data$Class_3.4==1 | data$Class_3.5==1 | data$Class_3.6==1 | data$Class_3.7==1)]=1
  data$Injury_type_dead=0
  data$Injury_type_dead[which(data$Class_4==1)]=1
  
  data$Injury_type_slight[which(data$Injury_type_severe==1)]=0

  data$rpm<-NA
  data$rpm<-as.factor(data$rpm)
  data$Pump_type_rpm = data$Pump_type

  print(dim(data))
  
  data$Species[data$Species=="blankvoorn"]<-"roach"

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