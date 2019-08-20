# Load original BKMR FIT
load(here::here("Supervised/BKMR/saved_model/bkmr_NHANES_gvs_knots100.RData"))

# Example trace plot from original
sel<-seq(50001,100000,by=50)
TracePlot(fit = fit_gvs_knots100, par = "beta", sel=sel)

# Reduce BKMR fit for use in RStudio Cloud
fit_gvs_knots100_cloud <- fit_gvs_knots100
fit_gvs_knots100_cloud$h.hat <- fit_gvs_knots100_cloud$h.hat[sample(nrow(fit_gvs_knots100$h.hat), 25000, replace = FALSE),]

# Example trace plot from subset
sel2<-seq(12501,25000,by=50)
TracePlot(fit = fit_gvs_knots100, par = "beta", sel=sel2)

# the R object has the same name as the full fit bc I didn't want to change a lot of code
fit_gvs_knots100 <- fit_gvs_knots100_cloud

# Save to file
save(fit_gvs_knots100, file="Supervised/BKMR/saved_model/bkmr_NHANES_gvs_knots100_cloud.RData")

