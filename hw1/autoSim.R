seed <- 280
rep <- 50

distTypes = c("gaussian", "t1", "t5")
nVals = seq(100, 500, by=100)
for (n in nVals) {
  for (dist in distTypes){
    oFile = paste("n", n, "dist", dist, ".txt", sep="")
    arg = paste("seed=", seed, " n=", n, " \'dist=\"", dist, "\"\' rep=", rep, sep="")
    sysCall = paste("nohup Rscript runSim.R ", arg, " > ", oFile)
    system(sysCall)
    print(paste("sysCall=", sysCall, sep=""))
  }
  
}

