plot.histogram.length.weight.distribution<-function(data,cols_to_summarize,type,summarystats=TRUE){
  data_length_rpm <- data %>% 
    group_by(Species,rpm,Pump_type,Control) %>% 
    summarize(number_recaptured=n(),
              across(cols_to_summarize,
                     list(mean=mean, 
                          min =min, 
                          max=max, 
                          Ind.600mm = ~sum(.x>600),
                          Ind.700mm = ~sum(.x>700))))
  #print(data_length_rpm)
  
  if (any(data$Control=="pump")) {detect.language="English"} else {detect.language="Dutch"}
  
  data$Pump_type_rpm_Control <- paste(data$rpm,data$Pump_type,data$Control)
  data_length_rpm$Pump_type_rpm_Control <- paste(data_length_rpm$rpm,data_length_rpm$Pump_type,data_length_rpm$Control)
  
  data$Pump_type_rpm <- paste(data$rpm,"rpm",data$Pump_type)
  data_length_rpm$Pump_type_rpm <- paste(data_length_rpm$rpm,"rpm",data_length_rpm$Pump_type)
  
  
  if(length(unique(data$Control))==2){
    if (detect.language=="English"){
      data$Control <- relevel(as.factor(data$Control), "pump")
      data_length_rpm$Control <- relevel(as.factor(data_length_rpm$Control),"pump" )
    }
    else {
    #Dutch names controls
    #data <- data %>% 
     # mutate(Control = ifelse(Control == "pump","pomp","controle"))
    
    #data_length_rpm <- data_length_rpm %>% 
     # mutate(Control = ifelse(Control == "pump","pomp","controle")) 
    
    data$Control <- relevel(as.factor(data$Control), "pomp")
    data_length_rpm$Control <- relevel(as.factor(data_length_rpm$Control),"pomp" )
    }
  }
  
  #Dutch Species names
  #data <- data %>% 
   # mutate(Species = ifelse(Species == "eel","Paling","Blankvoorn"))
  
  #data_length_rpm <- data_length_rpm %>% 
   # mutate(Species = ifelse(Species == "eel","Paling","Blankvoorn"))  
  
  
  for (i in unique(data_length_rpm$Species)){
    if (type=="hist"){
      #Histogram Length rpm distribution
      g<-ggplot(data[data$Species == i,], aes_string(x=cols_to_summarize, fill="Pump_type_rpm_Control")) +
        geom_histogram(alpha = 0.75, position = "identity") +
        geom_vline(data = data_length_rpm[data_length_rpm$Species == i,], aes_string(xintercept=paste(cols_to_summarize,"_mean",sep=""), color="Pump_type_rpm_Control"), linetype="dashed") +
        labs(x=cols_to_summarize, y = "Aantal") + theme_bw() +
        scale_fill_discrete(name = "Scenario", labels = paste(data_length_rpm$rpm[data_length_rpm$Species == i],"rpm",data_length_rpm$Pump_type[data_length_rpm$Species == i],data_length_rpm$Control[data_length_rpm$Species == i])) +
        scale_color_discrete(name = "Scenario", labels = paste(data_length_rpm$rpm[data_length_rpm$Species == i],"rpm",data_length_rpm$Pump_type[data_length_rpm$Species == i],data_length_rpm$Control[data_length_rpm$Species == i])) + ggtitle(i)
      #scale_x_continuous(breaks = seq(500, 800, by = 20)) +
      #scale_y_continuous(breaks = seq(0, 30, by = 5)) 
      print(g)
    }
    if (type=="dens"){
      #Histogram Length rpm distribution
      g<-ggplot(data[data$Species == i,], aes_string(x=cols_to_summarize, fill="Pump_type_rpm_Control")) +
        geom_density(alpha=0.5) +
        geom_vline(data = data_length_rpm[data_length_rpm$Species == i,], aes_string(xintercept=paste(cols_to_summarize,"_mean",sep=""), color="Pump_type_rpm_Control"), linetype="dashed") +
        labs(x=cols_to_summarize, y = "Density") + theme_bw() +
        scale_fill_discrete(name = "Scenario", labels = paste(data_length_rpm$rpm[data_length_rpm$Species == i],"rpm",data_length_rpm$Pump_type[data_length_rpm$Species == i],data_length_rpm$Control[data_length_rpm$Species == i])) +
        scale_color_discrete(name = "Scenario", labels = paste(data_length_rpm$rpm[data_length_rpm$Species == i],"rpm",data_length_rpm$Pump_type[data_length_rpm$Species == i],data_length_rpm$Control[data_length_rpm$Species == i])) + ggtitle(i)
      #scale_x_continuous(breaks = seq(500, 800, by = 20)) +
      #scale_y_continuous(breaks = seq(0, 30, by = 5)) 
      print(g)
    }
    if (type=="hist_facet"){
      g<-ggplot(data[data$Species == i,], aes_string(x=cols_to_summarize, fill="Control")) +
        geom_histogram(alpha = 0.6, position = "identity") +
        geom_vline(data = data_length_rpm[data_length_rpm$Species == i,], aes_string(xintercept=paste(cols_to_summarize,"_mean",sep=""), color="Control"), linetype="dashed") +
        labs(x=cols_to_summarize, y = "Density", title = i) +
        scale_fill_discrete(name = "Controle", labels = data_length_rpm$Control[data_length_rpm$Species == i]) +
        scale_fill_manual(values = c("#B96455","#7DBFE7"))+
        scale_color_discrete(name = "Controle", labels = data_length_rpm$Control[data_length_rpm$Species == i]) +
        scale_color_manual(values = c("#B96455","#7DBFE7"))+
        facet_wrap(vars(Pump_type_rpm))+
        theme_bw()
      
      
      #Dutch names
      #g<-g + xlab("Lengte")+ ylab("Aantal")
      
      #scale_x_continuous(breaks = seq(500, 800, by = 20)) +
      #scale_y_continuous(breaks = seq(0, 30, by = 5)) 
      print(g)
    }
    if (type=="dens_facet"){
      g<-ggplot(data[data$Species == i,], aes_string(x=cols_to_summarize, fill="Control")) +
        geom_density(color = "black", alpha = 0.5, size = 0.5)+
        geom_vline(data = data_length_rpm[data_length_rpm$Species == i,], aes_string(xintercept=paste(cols_to_summarize,"_mean",sep=""), color="Control"), linetype="dashed") +
        labs(x=cols_to_summarize, y = "Density", title = i) +
        scale_fill_discrete(name = "Controle", labels = data_length_rpm$Control[data_length_rpm$Species == i]) +
        scale_fill_manual(values = c("#B96455","#7DBFE7"))+
        scale_color_discrete(name = "Controle", labels = data_length_rpm$Control[data_length_rpm$Species == i]) +
        scale_color_manual(values = c("#B96455","#7DBFE7"))+
        facet_wrap(vars(Pump_type_rpm))+
        theme_bw()
      
        #Dutch names
        #g<-g + xlab("Lengte")+ ylab("Densiteit")

        
      #scale_x_continuous(breaks = seq(500, 800, by = 20)) +
      #scale_y_continuous(breaks = seq(0, 30, by = 5)) 
      print(g)
    }
  }
  if (summarystats==TRUE){return(data_length_rpm)}
}