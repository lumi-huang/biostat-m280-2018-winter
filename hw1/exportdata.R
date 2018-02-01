setwd("/home/luminghuang/biostat-m280-2018-winter/hw1")
files <- list.files(path = ".", pattern = "*.txt")
dat <- lapply(files, read.table)
table <- matrix(data = unlist(dat), nrow = 3, byrow = FALSE)
table1 <- table[-1,]
modified_table <- rbind(table1[, 1:3], table1[, 4:6], table1[, 7:9], 
                        table1[, 10:12], table[, 13:15])
modified_table1 <- modified_table[-9,]
final_table <- cbind(c("SampAvg", "PrimeAvg"), modified_table1)
final_table <- cbind(c("100", "", "200", "", "300", "", "400", "", "500", ""), 
                     final_table)
colnames(final_table) <- c("n", "Method", "Gaussian", "t1", "t5")
dataframe <- as.data.frame(final_table)
final_dataframe <- dataframe[,c(1,2,4,5,3)]

library(knitr)
kable(final_dataframe, format = "markdown")

