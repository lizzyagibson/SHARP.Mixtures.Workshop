
# Workshop on mixtures, Columbia August 2018

# install the packages needed for the workshop
install.packages("gWQS")
# import the packages just installed
library(gWQS)


# define the path
directory_path = "/Users/stefanorenzetti/Documents/Columbia Workshop Mixtures/"
directory_path = "/Users/gennic01/desktop/temp teaching/mailman mixtures workshop 2018/"

# import the dataset
dataset = read.csv(paste0(directory_path, "studypop.csv"))

# define the chemicals to include in the mixture
mixture = c("LBX074LA", "LBX099LA", "LBX118LA", "LBX138LA", "LBX153LA", "LBX170LA", "LBX180LA", "LBX187LA",
            "LBX194LA", "LBXD03LA", "LBXD05LA", "LBXD07LA", "LBXF03LA", "LBXF04LA", "LBXF05LA", "LBXF08LA",
            "LBXHXCLA", "LBXPCBLA")

# log-transform the outcome
dataset$log_TELOMEAN = log(dataset$TELOMEAN)

# fit a first unadjusted model to look at the association between the mixture and the outcome
# TELOMEAN = Mean Telomere Length
results1 = gwqs(log_TELOMEAN ~ NULL, mix_name = mixture, data = dataset, q = 10, validation = 0.6, valid_var = NULL,
                b = 100, b1_pos = FALSE, b1_constr = FALSE, family = "gaussian", seed = 123, wqs2 = FALSE,
                plots = TRUE, tables = TRUE)
summary(results1$fit)
results1$final_weights

# adjusting for covariates:
# blood data: LBXWBCSI LBXLYPCT LBXMOPCT LBXEOPCT LBXBAPCT LBXNEPCT
# demographics: age_cent age_sq race_cat bmi_cat3 ln_lbxcot edu_cat
# positive direction
result2 = gwqs(log_TELOMEAN ~ LBXWBCSI + LBXLYPCT + LBXMOPCT + LBXEOPCT + LBXBAPCT + LBXNEPCT + age_cent + age_sq + 
                 race_cat + bmi_cat3 + ln_lbxcot + edu_cat, mix_name = mixture, data = dataset, q = 10, 
               validation = 0.6, valid_var = NULL, b = 100, b1_pos = TRUE, b1_constr = FALSE, family = "gaussian", 
               seed = 123, wqs2 = FALSE, plots = TRUE, tables = TRUE)
summary(result2$fit)
result2$final_weights

# negative direction
result3 = gwqs(log_TELOMEAN ~ LBXWBCSI + LBXLYPCT + LBXMOPCT + LBXEOPCT + LBXBAPCT + LBXNEPCT + age_cent + age_sq + 
                 race_cat + bmi_cat3 + ln_lbxcot + edu_cat, mix_name = mixture, data = dataset, q = 10, 
               validation = 0.6, valid_var = NULL, b = 100, b1_pos = FALSE, b1_constr = TRUE, family = "gaussian", 
               seed = 123, wqs2 = FALSE, plots = TRUE, tables = TRUE)
summary(result3$fit)
result3$final_weights



# stratified analysis by sex
# create diagonal matrices for females and male having on the diagonal 1 or 0 to select female or males values respectively
M_mat = diag(dataset$male)
female = (dataset$male - 1)*(-1)
F_mat = diag(female)
# create the matrix containing the micture variables
X = as.matrix(dataset[, mixture])
# create a temporary matrix where we substitute NAs with 0s before the matrix multiplication
X_t = X
X_t[is.na(X)] = 0
# create a matrix for females and males selecting the observations that corresponds to each sex
XM = M_mat%*%X_t
XF = F_mat%*%X_t
# put back the NAs in the same position they were in the X matrix
XM[is.na(X)] = NA
XF[is.na(X)] = NA
# create the vectors containing the names of the chemicals for males and females
mixture_m = paste(mixture, "m", sep = "_")
mixture_f = paste(mixture, "f", sep = "_")
# rename the columns of the females and males matrices
colnames(XM) = mixture_m
colnames(XF) = mixture_f
# add the new variables to the dataset
dataset_new = cbind(dataset, XM, XF)

# run the wqs model using the stratified variables in the mixtures
mixture_new = c(mixture_m, mixture_f)
result4 = gwqs(log_TELOMEAN ~ LBXWBCSI + LBXLYPCT + LBXMOPCT + LBXEOPCT + LBXBAPCT + LBXNEPCT + age_cent + age_sq + 
                 race_cat + bmi_cat3 + ln_lbxcot + edu_cat, mix_name = mixture_new, data = dataset_new, q = 10, 
               validation = 0.6, valid_var = NULL, b = 100, b1_pos = TRUE, b1_constr = FALSE, family = "gaussian", 
               seed = 123, wqs2 = FALSE, plots = TRUE, tables = TRUE)

summary(result4$fit)
result4$final_weights




