## parsing command arguments
for (arg in commandArgs(TRUE)) {
  eval(parse(text = arg))
}

## check if a given integer is prime
isPrime = function(n) {
  if (n <= 3) {
    return (TRUE)
  }
  if (any((n %% 2:floor(sqrt(n))) == 0)) {
    return (FALSE)
  }
  return (TRUE)
}
## estimate mean only using observation with prime indices
estMeanPrimes = function (x) {
  n = length(x)
  ind = sapply(1:n, isPrime)
  return (mean(x[ind]))
}



# simulate data
meansquarederror = function (seed, n, dist, rep){
  set.seed(seed)
  mean1 <- vector()
  mean2 <- vector()
  
  for(i in 1:rep) {
    if (dist == "gaussian"){
      x <- rnorm(n)
      mean1[i] <- mean(x)
      mean2[i] <- estMeanPrimes(x)
    }
    else if (dist == "t1"){
      x <- rt(n, df = 1)
      mean1[i] <- mean(x)
      mean2[i] <- estMeanPrimes(x)
    }
    else if (dist == "t5"){
      x <- rt(n, df = 5)
      mean1[i] <- mean(x)
      mean2[i] <- estMeanPrimes(x)
    }
  }
  
  mse1 <- sum((mean1 - 0)^2) / rep #sample average estimator
  mse2 <- sum((mean2 - 0)^2) / rep #primed-indexed average estimator
  return(c(mse1,mse2))
}
meansquarederror(seed, n, dist, rep)
