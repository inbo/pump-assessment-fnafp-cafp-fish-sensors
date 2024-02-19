run_chi_squared<-function(data,printing,number_of_categories){
  print(printing)
  rownames(data)=do.call(paste,c(data[colnames(data)[-seq(ncol(data)-number_of_categories,ncol(data))]], sep = "_"))
  data[,colnames(data)[-seq(ncol(data)-number_of_categories,ncol(data))]]<-NULL
  chisq.test(data) -> chisq_stats #H0: The chance of being alive or dead is independent from species and/or frequency
  print("H0: The chance of being alive or dead is independent from the considered factors")
  print(chisq_stats)
  print("The value of the chi-squared test statistic")
  print(chisq_stats$statistic)
  print("The observed counts")
  print(chisq_stats$observed)
  print("The expected counts under the null hypothesis")
  print(chisq_stats$expected)
  print("The Pearson residuals, (observed - expected) / sqrt(expected).")
  print(round(chisq_stats$residuals, 3))
  print("The larger the residuals, the larger the difference between expected and observed, the more signficant the dependence, the lower the p-value (should be)")
  corrplot::corrplot(chisq_stats$residuals, is.cor = FALSE, main="plot of the residuals")
  print("Contribution in percentage (%) to the total chi-squared test statistic")
  contrib <- 100*chisq_stats$residuals^2/chisq_stats$statistic
  print(contrib)
  print("Visualisation of the contribution in percentage (%) to the total chi-squared test statistic")
  # corrplot::corrplot(contrib, main="plot of the contribution")
  # Post-hoc test 
  print("Post-hoc tests")
  pairwise.result<-pairwiseNominalIndependence(as.matrix(data),fisher = FALSE,gtest  = FALSE,chisq  = TRUE,method = "bonferroni")
  print(pairwise.result)
  return(pairwise.result)
}