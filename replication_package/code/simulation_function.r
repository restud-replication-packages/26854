simulation_function <- function(data_sim, m) {

    data_sim <- rbind(data_sim)

    index_cluster <- unique(data_sim[, 1])
    index_sample <- sample(index_cluster, size = m, replace = TRUE)
    av_calc <- do.call(rbind, lapply(index_sample, function(cl) {
        index_cl <- data_sim[, 1] == cl
        data_cl <- data_sim[index_cl, ]
        n_c <- dim(data_cl)[1]
        data_cl[, "W"] <- rbinom(n_c, 1, data_cl[, "prob_w"])
        averages <- colMeans(cbind(data_cl[, 3:10], data_cl[, 3] *
        data_cl[, 8:10]))
        names(averages) <- c("av_W", "av_temp", "av_rain", "av_snow",
        "av_ww", "av_winter", "av_spring", "av_summer", "av_W_winter",
        "av_W_spring", "av_W_summer")
        return(cbind(data_cl[, 1:10], outer(rep(1, n_c), averages)))
    }))

    regs <- paste(colnames(av_calc)[3:18], collapse = "+", sep = "")
    formula_ols <- paste("Y_2~", regs, sep = "")
    reg_full <- lm(formula_ols, data = as.data.frame(av_calc))
    res_reg_full <- reg_full$residuals
    est_reg <- reg_full$coefficients[2]

    p_score_model <- randomForest::randomForest(x = av_calc[, -c(1:3)],
    y = av_calc[, "W"])
    p_score <-  predict(p_score_model)

    data_est <- cbind(res_reg_full, p_score, av_calc[, c(1, 3)])
    res_est <- do.call(rbind, as.list(by(data_est, data_est[, 3],
    function(data) {
        index_subs <- data[, 2] > 0.1 &  data[, 2] < 0.9
        clust_lev_est <- index_subs * data[, 1] * (data[, 4] / data[, 2]
        - (1 - data[, 4]) / (1 - data[, 2]))
        clust_lev_est[!index_subs] <- 0
        clust_lev_est_up <- mean(clust_lev_est)
        den_est <- mean(index_subs)
        return(c(clust_lev_est_up, den_est))
    })))

    est_dr <- est_reg + mean(res_est[, 1]) / mean(res_est[, 2])
    sd_est <- sqrt(var(res_est[, 1]) / (mean(res_est[, 2])^2 * m))

    return(c(est_reg, est_dr, sd_est))
}
