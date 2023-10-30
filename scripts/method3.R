library(ggplot2)
library(foreach)
library(doParallel)
library(tweedie)

simTweedieTest <- function(N){ 
  t.test(tweedie::rtweedie(N, mu=10000, phi=100, power=1.9), mu=10000)$p.value 
}  

MTweedieTests <- function(N, M, sig){ 
  no_cores <- detectCores() - 1
  registerDoParallel(cores=no_cores)
  
  results <- foreach(m = 1:M, .combine='c', .export='simTweedieTest') %dopar% {
    simTweedieTest(N) < sig
  }
  stopImplicitCluster()
  
  return(mean(results))
} 


df <- expand.grid(N = c(10, 100, 1000, 5000, 10000), 
                  M = 1000, 
                  share_reject = NA) 

for(i in 1:nrow(df)){ 
  df$share_reject[i] <- MTweedieTests(N=df$N[i], M=df$M[i], sig=.05) 
} 

df



