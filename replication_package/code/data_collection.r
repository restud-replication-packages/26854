library(readstata13)
rm(list = ls())
set.seed(12345)


## set the working directory to ../replication_pacage/
setwd("~/Dropbox/Research/causal_cluster/replication_package/")
original_data <- read.dta13("data/wtbb_publicdata.dta", generate.factors = TRUE)

int_var <- c("hostid_0", "presenting", "collected",
"incentive", "temperature", "rain", "snow")

is_ww <- original_data[, "weekday"] <= 5 & original_data[, "weekday"] >= 1
is_winter <- original_data[, "month"] <= 2 | original_data[, "month"] >= 12
is_spring <- original_data[, "month"] < 6 & original_data[, "month"] >= 3
is_summer <- original_data[, "month"] < 9 & original_data[, "month"] >= 6


subset_data <- cbind(original_data[, int_var], is_ww, is_winter,
is_spring, is_summer)

colnames(subset_data)[1:4] <- c("C", "Y_1", "Y_2", "W")


split_result <- split(subset_data, f = as.factor(subset_data$C))

av_chars <- round(do.call(rbind, lapply(split_result, function(data) {
    n <- dim(data)[1]
    res_1 <- c(data[1, 1], colMeans(data[, 3:11]), n)
    res_2 <- colMeans(data[, c(5:11)] * data[, 4])
    names(res_1) <- c("C", "av_Y2", "av_W", "av_temp", "av_rain",
    "av_snow", "av_ww", "av_winter", "av_spring", "av_summer", "n_c")
    names(res_2) <- c("av_W_temp", "av_W_rain", "av_W_snow",
    "av_W_ww", "av_W_winter", "av_W_spring", "av_W_summer")

    return(c(res_1, res_2))
})), 3)


list_to_save <- list(subset_data, av_chars)
save(list_to_save, file = "data/cleaned_data.RData")