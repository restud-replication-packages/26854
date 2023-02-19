library("randomForest")
rm(list = ls())
set.seed(12345)

## set the working directory to ../replication_pacage/
setwd("~/Dropbox/Research/causal_cluster/replication_package/")
load("data/cleaned_data.RData")
source("code/simulation_function.r")


data_init <- list_to_save[[1]]
cl_labels <- unique(data_init[, "C"])
indiv_reg <- paste(colnames(data_init)[9:11], collapse = "+", sep = "")
formula_w <- paste("W", paste(indiv_reg, sep = "+"), sep = "~")

p_models <- do.call(rbind, as.list(by(data_init, data_init[, "C"],
function(data) {
    n_c <- dim(data)[1]
    p_score_m <- glm(formula_w, data = as.data.frame(data), family = "binomial")
    coefs <- p_score_m$coefficients
    return(c(data[1, "C"], coefs))
})))

index_cl <- rowMeans(is.na(p_models[, -1])) == 0
p_models_sel <- p_models[index_cl, ]

result_km <- kmeans(p_models_sel[, -1], 20)
tables_centers <- cbind(1:20, round(result_km$centers, 2))
colnames(tables_centers) <- c("U_c", "int", "winter", "spring", "summer")
tables_labels <- cbind(p_models_sel[, 1], result_km$cluster)
colnames(tables_labels) <- c("C", "U_c")
table_full <- merge(tables_labels, tables_centers)

data_merged <- merge(data_init, table_full)

logit_prob_w <- rowSums(data_merged[, c("is_winter", "is_spring", "is_summer")]
* data_merged[, c("winter", "spring", "summer")]) + data_merged[, "int"]
prob_w <- exp(logit_prob_w) / (1 + exp(logit_prob_w))
data_sim <- cbind(data_merged[, c(1, 3:11)], prob_w)

B <- 100
m <- 1200
results <- matrix(0, ncol = 3, nrow = B)

for (b in 1:B) {
    results[b, ] <- simulation_function(data_sim, m)
}

bias_est <- colMeans(results[, 1:2])
sd_est <- sqrt(diag(var(results[, 1:2])))
RMSE <- sqrt(bias_est^2 + sd_est^2)

res_sim <- round(rbind(bias_est, RMSE), 2)
colnames(res_sim) <- c("Linear FE", "DR")
rownames(res_sim) <- c("Bias", "RMSE")
write.csv(res_sim, file =  "tables/table_2.txt", quote = FALSE)


sd_true <- round(sd_est, 2)
av_est_sd <- round(mean(sqrt(results[, 3])), 2)
st_err <- as.matrix(c(sd_true, av_est_sd))
rownames(st_err) <- c("true_fe", "true_rob", "av_est_rob")
colnames(st_err) <- "results"
write.csv(st_err, file =  "tables/st_errors.txt", quote = FALSE)
