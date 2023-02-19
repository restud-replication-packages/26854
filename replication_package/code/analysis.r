library("randomForest")


rm(list = ls())
set.seed(12345)

## set the working directory to ../replication_pacage/
setwd("~/Dropbox/Research/causal_cluster/replication_package/")
load("data/cleaned_data.RData")


subset_data <- list_to_save[[1]]
av_chars <- list_to_save[[2]]
full_data <- merge(subset_data, av_chars)

indiv_reg <- paste(colnames(full_data)[5:11], collapse = "+", sep = "")
agg_reg <-  paste(colnames(full_data)[c(13:20)], collapse =  "+" , sep = "")
formula_ols_full <- paste("Y_2~", paste("W",
paste(indiv_reg, agg_reg, sep = "+"), sep = "+"), sep = "")
formula_ols_w <- paste("W", paste(indiv_reg, agg_reg, sep = "+"), sep = "~")
formula_ols_w_ind <- paste("W", indiv_reg, sep = "~")


formula_ols_ind <- paste("Y_2~", paste("W", indiv_reg, sep = "+"), sep = "")
reg_ind <- lm(formula_ols_ind, data = as.data.frame(full_data))
est_reg_ind <- reg_ind$coefficients[2]
res_reg_ind <- reg_ind$residuals



reg_full <- lm(formula_ols_full, data = as.data.frame(full_data))
res_reg_full <- reg_full$residuals
est_reg <- reg_full$coefficients[2]

p_score_model <- randomForest(x = full_data[, c(5:11, 13:20, 22:28)],
y = full_data[, "W"], importance = FALSE)
p_score <-  predict(p_score_model)
lm_model_w <- lm(formula_ols_w, data = as.data.frame(full_data))
res_w <- lm_model_w$residuals

lm_model_w_ind <- lm(formula_ols_w_ind, data = as.data.frame(full_data))
res_w_ind <- lm_model_w_ind$residuals


data_w_est <- cbind(full_data[, c(1, 3, 4)], res_reg_full, res_w,
res_w_ind, p_score)
m <- length(unique(data_w_est[, "C"]))
est_dr_c <- do.call(rbind, as.list(by(data_w_est, data_w_est[, 1],
function(data) {
    index_subs <- data[, "p_score"] > 0.05 &  data[, "p_score"] < 0.95
    clust_lev_est_1 <- index_subs * data[, 4] * (data[, "W"] / data[, "p_score"]
    - (1 - data[, "W"]) / (1 - data[, "p_score"]))
    clust_lev_est_2 <- index_subs * data[, 2] * (data[, "W"] / data[, "p_score"]
    - (1 - data[, "W"]) / (1 - data[, "p_score"]))
    clust_lev_est_1[!index_subs] <- 0
    clust_lev_est_2[!index_subs] <- 0
    xi_c_1 <- mean(clust_lev_est_1)
    xi_c_2 <- mean(clust_lev_est_2)
    xi_c_3 <- sum(data[, 4] * data[, 5])
    xi_c_4 <- sum(data[, 4] * data[, 6])
    den_est <- mean(index_subs)

   return(c(xi_c_1, xi_c_2, xi_c_3, xi_c_4, den_est))
})))

est_dr <- est_reg + mean(est_dr_c[, 1]) / mean(est_dr_c[, 5])
a_est <- round(mean(est_dr_c[, 5]), 2)
est_ipw <- mean(est_dr_c[, 2]) / mean(est_dr_c[, 5])

var_est_1 <- (1 / m) * var(est_dr_c[, 1]) / (mean(est_dr_c[, 5]))^2
var_est_2 <- (1 / m) * var(est_dr_c[, 2]) / (mean(est_dr_c[, 5]))^2
var_est_3 <- sum(est_dr_c[, 3]^2) / sum(res_w^2)^2
var_est_4 <- sum(est_dr_c[, 4]^2) / sum(res_w_ind^2)^2


est_full <- cbind(est_reg_ind, est_reg, est_ipw, est_dr)
sd_est <- sqrt(cbind(var_est_4, var_est_3, var_est_2, var_est_1))

results_est <- round(rbind(est_full, sd_est), 2)
rownames(results_est) <- c("estimates", "standard errors")

write.csv(results_est, file =  "tables/table_1.txt", quote = FALSE)

p_score_model_imp <- randomForest(x = full_data[, c(5:11, 13:20, 22:28)],
 y = full_data[, "W"], importance = TRUE)

rownames(p_score_model_imp$importance) <- c("temperature", "rain", "snow",
 "weekend", "winter",  "spring", "summer",
"treatment share", "average temperature", "average rain", "average snow",
"weekends share", "winter share", "spring share", "summer share",
"average treatment*temperature ",   "average treatment*rain",
"average treatment*snow",   "average treatment*weekend",
"average treatment*winter", "average treatment*spring",
"average treatment*summer")

pdf(file = "./figures/var_imp.pdf",   width = 10 * 0.75,
height = 9 * 0.75)
varImpPlot(p_score_model_imp, main = "Random Forest Prediction", type = 1)
dev.off()