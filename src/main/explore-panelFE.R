# HFCS  correlated efects mixed hybrid model (Bell & Jones, 2015) pooled waves

library(magrittr)
library(data.table)
library(lme4)
library(plm)

# clean enviroment
rm(list = ls())

path_string <- "output/MEANS/"

countries <- c("AT", "BE", "CY", "FI", "FR", "DE", "GR", "IT", "LU", "MT", "NL", "PT", "SI", "SK", "ES")
outcome <- fread(paste0(path_string, "ren-fin-pro/rentsbi.csv"), header = TRUE) %>%
    unlist() %>%
    as.vector()
outcome5 <- fread(paste0(path_string, "ren-fin-pro/rentsbi5.csv"), header = TRUE) %>%
    unlist() %>%
    as.vector()
w_outcome <- fread(paste0(path_string, "wealthy/rentsbi.csv"), header = TRUE) %>%
    unlist() %>%
    as.vector()
w_outcome5 <- fread(paste0(path_string, "wealthy/rentsbi5.csv"), header = TRUE) %>%
    unlist() %>%
    as.vector()
i_outcome <- fread(paste0(path_string, "highincome/rentsbi.csv"), header = TRUE) %>%
    unlist() %>%
    as.vector()
i_outcome5 <- fread(paste0(path_string, "highincome/rentsbi5.csv"), header = TRUE) %>%
    unlist() %>%
    as.vector()
c_outcome <- fread(paste0(path_string, "class/ren-fin-pro/rentsbi.csv"), header = TRUE) %>%
    unlist() %>%
    as.vector()
c_outcome5 <- fread(paste0(path_string, "class/ren-fin-pro/rentsbi5.csv"), header = TRUE) %>%
    unlist() %>%
    as.vector()
group <- rep(countries, 4)
time <- as.factor(as.vector(cbind(rep(1, 15), rep(2, 15), rep(3, 15), rep(4, 15))))

dataset <- data.table(group, time, outcome, outcome5, w_outcome, w_outcome5, i_outcome, i_outcome5, c_outcome, c_outcome5)
pdataset <- pdata.frame(dataset, index = c("group", "time"))

model <- plm(outcome ~ as.factor(time), data = pdataset, model = "within", effect = "individual")
model5 <- plm(outcome5 ~ as.factor(time), data = pdataset, model = "within", effect = "individual")
w_model <- plm(w_outcome ~ as.factor(time), data = pdataset, model = "within", effect = "individual")
w_model5 <- plm(w_outcome5 ~ as.factor(time), data = pdataset, model = "within", effect = "individual")
i_model <- plm(i_outcome ~ as.factor(time), data = pdataset, model = "within", effect = "individual")
i_model5 <- plm(i_outcome5 ~ as.factor(time), data = pdataset, model = "within", effect = "individual")
c_model <- plm(c_outcome ~ as.factor(time), data = pdataset, model = "within", effect = "individual")
c_model5 <- plm(c_outcome5 ~ as.factor(time), data = pdataset, model = "within", effect = "individual")

cross_model <- plm(outcome ~ as.factor(time) + as.factor(time) * group, data = pdataset, model = "within", effect = "individual")
cross_model5 <- plm(outcome5 ~ as.factor(time) + as.factor(time) * group, data = pdataset, model = "within", effect = "individual")


results <- rbind(
    summary(model)$coefficients,
    summary(model5)$coefficients,
    summary(w_model)$coefficients,
    summary(w_model5)$coefficients,
    summary(i_model)$coefficients,
    summary(i_model5)$coefficients,
    summary(c_model)$coefficients,
    summary(c_model5)$coefficients
)

r_squared <- c(
    rep(summary(model)$r.squared["rsq"], 3),
    rep(summary(model5)$r.squared["rsq"], 3),
    rep(summary(w_model)$r.squared["rsq"], 3),
    rep(summary(w_model5)$r.squared["rsq"], 3),
    rep(summary(i_model)$r.squared["rsq"], 3),
    rep(summary(i_model5)$r.squared["rsq"], 3),
    rep(summary(c_model)$r.squared["rsq"], 3),
    rep(summary(c_model5)$r.squared["rsq"], 3)
)

results <- cbind(results, r_squared)

fwrite(results, "output/MODELS/MACRO/ren-fin/macro-factor.csv")
