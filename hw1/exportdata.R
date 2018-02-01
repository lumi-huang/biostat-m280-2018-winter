nVals = seq(100, 500, by=100)
distTypes = c("t1", "t5", "gaussian")

files <- list.files(pattern = "[.]txt$")
dat <- lapply(files, read.table)
dat

