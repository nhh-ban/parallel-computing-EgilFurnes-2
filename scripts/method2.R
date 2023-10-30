# Assignment 1:  
library(ggplot2)
library(foreach)
library(doParallel)
library(tweedie)
 
simTweedieTest <-  
  function(N){ 
    t.test( 
      tweedie::rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 


# Assignment 2:  
MTweedieTests <-  
  function(N,M,sig){ 
    sum(replicate(M,simTweedieTest(N)) < sig)/M 
  } 


# Assignment 3:  
df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 

results <- foreach(i = 1:nrow(df), .combine = 'rbind') %dopar% {
  data_row <- df[i, ]
  share_reject <- MTweedieTests(data_row$N, data_row$M, .05)
  c(data_row, share_reject)
}

df <- as.data.frame(matrix(unlist(results), nrow = nrow(df), byrow = TRUE))
colnames(df) <- c("N", "M", "share_reject")

stopImplicitCluster()

df

