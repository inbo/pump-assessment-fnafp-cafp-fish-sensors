correct_ROI_manually<-function(data,sensor.select,time.select,stage){
  
  print(paste("for",deparse(substitute(data)),"the time of",sensor.select,"was changed from",data$Time..s.[which(data$sensor==sensor.select)],"seconds to",time.select,"seconds"))
  
  old<-data[which(data$sensor==sensor.select),c("sensor","Time..s.")]; old$type<-"old"
  new<-file.final[which(file.final$sensor==sensor.select & file.final$Time..s.==time.select),c("sensor","Time..s.")]; new$type<-"new"
  old_and_new_temp<-rbind(old,new); old_and_new_temp$stage<-stage
  if (file.exists("./data/internal/Oude_Kale/BDS_TalTech/Manually_changed_ROI.csv")==FALSE){
    write.csv(old_and_new_temp,"./data/internal/Oude_Kale/BDS_TalTech/Manually_changed_ROI.csv",row.names = FALSE)
  }
  if (file.exists("./data/internal/Oude_Kale/BDS_TalTech/Manually_changed_ROI.csv")==TRUE){
    old_and_new<-read.csv("./data/internal/Oude_Kale/BDS_TalTech/Manually_changed_ROI.csv")
    old_and_new<-rbind(old_and_new,old_and_new_temp)
    write.csv(old_and_new,"./data/internal/Oude_Kale/BDS_TalTech/Manually_changed_ROI.csv",row.names = FALSE)
  }
  data[which(data$sensor==sensor.select),]<-file.final[which(file.final$sensor==sensor.select & file.final$Time..s.==time.select),]
  return(data)
}