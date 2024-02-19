log.model.state<-function(form,data,type,AIC=TRUE,family = 'binomial'){
  if (type=="mixed"){
    print("mixed")
    model=glmer(formula = form, data = data, family = family)
    print(r.squaredGLMM(model))
  }
  if (type=="simple"){
    print("simple")
    if (AIC==TRUE){model=stepAIC(glm(formula = form, data = data, family = family),trace=FALSE)}
    if (AIC==FALSE){model=glm(formula = form, data = data, family = family)}
  }
  print(summary(model))
  return(model)
}