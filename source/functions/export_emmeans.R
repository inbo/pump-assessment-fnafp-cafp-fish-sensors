export.emmeans<-function(data.list,location,file,species){
  file=paste("./data/fish/internal/",location,"/",file,"_",species,".xlsx",sep="")
  if (file.exists(file)){file.remove(file)}
  wb = createWorkbook()
  worksheets = c("CI","Contrasts")
  for (k in 1:2) {
    sheet_name = worksheets[k]
    addWorksheet(wb, sheet_name)
    writeData(wb, sheet_name, data.list[[k]])
  }
  saveWorkbook(wb, file)
}