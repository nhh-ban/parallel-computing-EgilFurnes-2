
library(tictoc)

set.seed(123)

# method 1
tic("Let's go with the first one, for the boys")
source("scripts/method1.R")
toc("Done") 
print(df)

# method 2
tic("Let's go, are ya ready for method 2?")
registerDoParallel(cores=detectCores()-1) 
source("scripts/method2.R")
stopImplicitCluster() 
toc("Done")
print(df)

# method 3
tic("Let's go, third time's a charm")
registerDoParallel(cores=detectCores()-1)  
source("scripts/method3.R")
stopImplicitCluster()
toc("Done")
print(df)
