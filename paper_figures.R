#### Code for plots for paper
#### Only works with other files!!!
#### Look bad as is, but print well to file
#### 12/13/2018

## Unsupervised

### Heatmap

heatmap <- melted_cormat %>% 
  mutate(group3.1 = fct_relevel(group3.1, c("TEQ", "Non-Ortho PCB", "Non-Dioxin-like PCB"))) %>% 
  ggplot(aes(Var1, Var2, fill = Correlation)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(0,1), space = "Lab", 
                       name = "Correlation ") +
  scale_x_discrete(expand = c(0, 0)) + 
  scale_y_discrete(expand = c(0, 0)) + theme_bw(base_size = 20) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        panel.spacing = unit(0, "lines"),
        panel.border = element_rect(colour = "black", size=0.7),
        strip.placement = "outside", 
        strip.background = element_rect(fill = "white")) +
  labs(x = "", y = "") +
  facet_grid(group3.2 ~ group3.1, scales = "free", space = "free",
             labeller = labeller(group3.1 = label_wrap_gen(5),
                                 group3.2 = label_wrap_gen(5)))

png("./Unsupervised/heatmap.png", width = 1400, height = 1300, res = 90)
heatmap
dev.off()

### PCA

pca_plot <- plot_loadings_pca %>% 
  filter(PC %in% c("PC1", "PC2", "PC3")) %>% 
  mutate(PC = as.factor(PC),
         PC = fct_recode(PC, "PC 1" = "PC1",
                         "PC 2" = "PC2",
                         "PC 3" = "PC3")) %>% 
  mutate(chem = fct_recode(chem, "PCB 74" = "lbx074la.l2",
                           "PCB 99" = "lbx099la.l2",
                           "PCB 118" = "lbx118la.l2",
                           "PCB 138" = "lbx138la.l2",
                           "PCB 153" = "lbx153la.l2",
                           "PCB 170" = "lbx170la.l2",
                           "PCB 180" = "lbx180la.l2",
                           "PCB 187" = "lbx187la.l2",
                           "PCB 194" = "lbx194la.l2",
                           "1,2,3,6,7,8-hxcdd" = "lbxd03la.l2",
                           "1,2,3,4,6,7,8-hpcdd" = "lbxd05la.l2",
                           "1,2,3,4,6,7,8,9-ocdd" =  "lbxd07la.l2",
                           "2,3,4,7,8-pncdf" =  "lbxf03la.l2",
                           "1,2,3,4,7,8-hxcdf" =  "lbxf04la.l2",
                           "1,2,3,6,7,8-hxcdf" =  "lbxf05la.l2",
                           "1,2,3,4,6,7,8-hxcdf" =  "lbxf08la.l2",
                           "PCB 169" =  "lbxhxcla.l2",
                           "PCB 126" = "lbxpcbla.l2")) %>% 
  ggplot(aes(x = chem, y = Loading, fill = Group)) + geom_col() +
  facet_wrap(~ PC) + theme_bw(base_size = 20) + 
  theme(legend.position = "bottom", axis.text.x = element_text(angle = 90, hjust = 1),
        strip.background = element_rect(fill = "white")) +
  geom_hline(yintercept = 0, size = 0.2) +
  labs(x = "Chemicals",
       y = "Loadings")

png("./Unsupervised/pca_plot.png", width = 1100, height = 800)
pca_plot
dev.off()

### K-means Clustering

plot3 <- plot_chem_means %>% as.tibble() %>% rename(pop_mean = `colMeans(log.x)`) %>% 
  right_join(., plot_means_km3, by = c("Group", "chem")) %>% 
  mutate(Cluster = as.factor(Cluster),
         Cluster = fct_recode(Cluster, "Cluster 1" = "1",
                              "Cluster 2" = "2",
                              "Cluster 3" = "3")) %>% 
  mutate(chem = fct_recode(chem, "PCB 74" = "lbx074la.l2",
                           "PCB 99" = "lbx099la.l2",
                           "PCB 118" = "lbx118la.l2",
                           "PCB 138" = "lbx138la.l2",
                           "PCB 153" = "lbx153la.l2",
                           "PCB 170" = "lbx170la.l2",
                           "PCB 180" = "lbx180la.l2",
                           "PCB 187" = "lbx187la.l2",
                           "PCB 194" = "lbx194la.l2",
                           "1,2,3,6,7,8-hxcdd" = "lbxd03la.l2",
                           "1,2,3,4,6,7,8-hpcdd" = "lbxd05la.l2",
                           "1,2,3,4,6,7,8,9-ocdd" =  "lbxd07la.l2",
                           "2,3,4,7,8-pncdf" =  "lbxf03la.l2",
                           "1,2,3,4,7,8-hxcdf" =  "lbxf04la.l2",
                           "1,2,3,6,7,8-hxcdf" =  "lbxf05la.l2",
                           "1,2,3,4,6,7,8-hxcdf" =  "lbxf08la.l2",
                           "PCB 169" =  "lbxhxcla.l2",
                           "PCB 126" = "lbxpcbla.l2")) %>% 
  ggplot(aes(x = chem, y = mean, fill = Group)) + geom_col() +
  geom_point(aes(y = pop_mean), size = 1) +
  facet_wrap(~ Cluster) + theme_bw(base_size = 20) + 
  theme(legend.position = "bottom", axis.text.x = element_text(angle = 90, hjust = 1),
        plot.caption = element_text(size = 11, hjust = 0),
        strip.background = element_rect(fill = "white")) +
  geom_hline(yintercept = 0, size = 0.2) +
  labs(x = "Chemicals",
       y = "Mean")

png("./Unsupervised/clusters.png", width = 1100, height = 800)
plot3
dev.off()

### Hierarchical Clustering

png("./Unsupervised/hier_branches.png", width = 900, height = 800)
dendro.complete %>% color_branches(k = 3) %>% 
  plot(main = "Complete Linkage", ylab = "Height", leaflab = "none")
abline(h = 11.25, lty = 3)
dev.off()

### Factor Analysis

efa_plot <- plot_loadings %>% 
  mutate(Factor = as.factor(Factor),
         Factor = fct_recode(Factor, "Factor 1" = "MR1",
                             "Factor 2" = "MR2",
                             "Factor 3" = "MR3",
                             "Factor 4" = "MR4")) %>% 
  mutate(Variable = fct_recode(Variable, "PCB 74" = "lbx074la",
                               "PCB 99" = "lbx099la",
                               "PCB 118" = "lbx118la",
                               "PCB 138" = "lbx138la",
                               "PCB 153" = "lbx153la",
                               "PCB 170" = "lbx170la",
                               "PCB 180" = "lbx180la",
                               "PCB 187" = "lbx187la",
                               "PCB 194" = "lbx194la",
                               "1,2,3,6,7,8-hxcdd" = "lbxd03la",
                               "1,2,3,4,6,7,8-hpcdd" = "lbxd05la",
                               "1,2,3,4,6,7,8,9-ocdd" =  "lbxd07la",
                               "2,3,4,7,8-pncdf" =  "lbxf03la",
                               "1,2,3,4,7,8-hxcdf" =  "lbxf04la",
                               "1,2,3,6,7,8-hxcdf" =  "lbxf05la",
                               "1,2,3,4,6,7,8-hxcdf" =  "lbxf08la",
                               "PCB 169" =  "lbxhxcla",
                               "PCB 126" = "lbxpcbla")) %>% 
  ggplot(aes(x = Variable, y = Loading, fill = Group)) + geom_col() +
  facet_wrap(~ Factor) + theme_bw(base_size = 25) + 
  theme(legend.position = "bottom", axis.text.x = element_text(angle = 90, hjust = 1),
        strip.background = element_rect(fill = "white")) +
  geom_hline(yintercept = 0, size = 0.2)

png("./Unsupervised/efa_plot.png", width = 1000, height = 1000)
efa_plot
dev.off()

## Variable Selection

vs_plot <- plot_all %>% 
  ggplot(aes(x = variable, y = beta)) + geom_point(aes(color = group3), size = 2.5) +
  geom_hline(yintercept = 0, color = "grey", linetype = "dashed") + theme_bw(base_size = 18) +
  facet_grid(group3 ~ method, scales="free_y", space = "free_y",
             labeller = labeller(group3 = label_wrap_gen(5))) + coord_flip() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position = "bottom",
        strip.background = element_rect(fill = "white")) +
  labs(y = "Beta Coefficients",
       x = "Variables", 
       color = "POP Group")

png("./Variable Selection/vs_plot.png", width = 900, height = 1000, res = 90)
vs_plot
dev.off()

## BKMR

### Univariable

png("./BKMR/bkmr_univar.png", width = 1300, height = 1300, res = 80)
pred.resp.univar %>% 
  mutate(Group = ifelse(variable == "PCB118", "TEQ", 
                  ifelse(grepl("Dioxin", variable), "TEQ",
                   ifelse(grepl("Furan", variable), "TEQ",
                    ifelse(variable == "PCB126", "Non-Ortho PCB",
                     ifelse(variable == "PCB169", "Non-Ortho PCB", "Non-Dioxin-like PCBs")))))) %>% 
  mutate(variable = fct_recode(variable, "PCB 74" = "PCB74",
                               "PCB 99" = "PCB99",
                               "PCB 118" = "PCB118",
                               "PCB 138" = "PCB138",
                               "PCB 153" = "PCB153",
                               "PCB 170" = "PCB170",
                               "PCB 180" = "PCB180",
                               "PCB 187" = "PCB187",
                               "PCB 194" = "PCB194",
                               "1,2,3,6,7,8-hxcdd" = "Dioxin1",
                               "1,2,3,4,6,7,8-hpcdd" = "Dioxin2",
                               "1,2,3,4,6,7,8,9-ocdd" =  "Dioxin3",
                               "2,3,4,7,8-pncdf" =  "Furan1",
                               "1,2,3,4,7,8-hxcdf" =  "Furan2",
                               "1,2,3,6,7,8-hxcdf" =  "Furan3",
                               "1,2,3,4,6,7,8-hxcdf" =  "Furan4",
                               "PCB 169" =  "PCB169",
                               "PCB 126" = "PCB126")) %>% 
  ggplot(aes(z, est, ymin = est - 1.96*se, ymax = est + 1.96*se)) + 
  geom_smooth(aes(color = Group), stat = "identity") + ylab("h(z)") + 
  facet_wrap(~ variable) + theme_bw(base_size = 25) +
  theme(strip.background = element_rect(fill = "white"),
        legend.position = "bottom",
        axis.title = element_text(size = 30)) +
  labs(x = "Exposure", y = "Estimate")
dev.off()

### Bivariable 1 & 2

png("./BKMR/bkmr_bivar.png", width = 2000, height = 2000)
pred.resp.bivar %>% 
  mutate(variable1 = fct_recode(variable1, "PCB 74" = "PCB74",
                                "PCB 99" = "PCB99",
                                "PCB 118" = "PCB118",
                                "PCB 138" = "PCB138",
                                "PCB 153" = "PCB153",
                                "PCB 170" = "PCB170",
                                "PCB 180" = "PCB180",
                                "PCB 187" = "PCB187",
                                "PCB 194" = "PCB194",
                                "1,2,3,6,7,8- hxcdd" = "Dioxin1",
                                "1,2,3,4,6,7,8- hpcdd" = "Dioxin2",
                                "1,2,3,4,6,7,8,9- ocdd" =  "Dioxin3",
                                "2,3,4,7,8- pncdf" =  "Furan1",
                                "1,2,3,4,7,8- hxcdf" =  "Furan2",
                                "1,2,3,6,7,8- hxcdf" =  "Furan3",
                                "1,2,3,4,6,7,8- hxcdf" =  "Furan4",
                                "PCB 169" =  "PCB169",
                                "PCB 126" = "PCB126"),
         variable2 = fct_recode(variable2, "PCB 74" = "PCB74",
                                "PCB 99" = "PCB99",
                                "PCB 118" = "PCB118",
                                "PCB 138" = "PCB138",
                                "PCB 153" = "PCB153",
                                "PCB 170" = "PCB170",
                                "PCB 180" = "PCB180",
                                "PCB 187" = "PCB187",
                                "PCB 194" = "PCB194",
                                "1,2,3,6,7,8- hxcdd" = "Dioxin1",
                                "1,2,3,4,6,7,8- hpcdd" = "Dioxin2",
                                "1,2,3,4,6,7,8,9- ocdd" =  "Dioxin3",
                                "2,3,4,7,8- pncdf" =  "Furan1",
                                "1,2,3,4,7,8- hxcdf" =  "Furan2",
                                "1,2,3,6,7,8- hxcdf" =  "Furan3",
                                "1,2,3,4,6,7,8- hxcdf" =  "Furan4",
                                "PCB 169" =  "PCB169",
                                "PCB 126" = "PCB126")) %>% 
  ggplot(aes(z1, z2, fill = est)) + 
  geom_raster() + 
  facet_grid(variable2 ~ variable1, scales = "free", space = "free",
             labeller = labeller(variable1 = label_wrap_gen(5),
                                 variable2 = label_wrap_gen(5))) +
  scale_fill_gradientn(colours=c("#0000FFFF","#FFFFFFFF","#FF0000FF")) +
  xlab("Exposure 1") +
  ylab("Exposure 2") + labs(fill = "Estimate") +
  ggtitle("h(Exposure 1, Exposure 2)") + theme_bw(base_size = 20) +
  theme(strip.background = element_rect(fill = "white"),
        panel.spacing = unit(0.05, "lines"))
dev.off()

png("./BKMR/bkmr_bivar2.png", width = 2000, height = 2000)
pred.resp.bivar.levels %>% 
  mutate(variable1 = fct_recode(variable1, "PCB 74" = "PCB74",
                                "PCB 99" = "PCB99",
                                "PCB 118" = "PCB118",
                                "PCB 138" = "PCB138",
                                "PCB 153" = "PCB153",
                                "PCB 170" = "PCB170",
                                "PCB 180" = "PCB180",
                                "PCB 187" = "PCB187",
                                "PCB 194" = "PCB194",
                                "1,2,3,6,7,8- hxcdd" = "Dioxin1",
                                "1,2,3,4,6,7,8- hpcdd" = "Dioxin2",
                                "1,2,3,4,6,7,8,9- ocdd" =  "Dioxin3",
                                "2,3,4,7,8- pncdf" =  "Furan1",
                                "1,2,3,4,7,8- hxcdf" =  "Furan2",
                                "1,2,3,6,7,8- hxcdf" =  "Furan3",
                                "1,2,3,4,6,7,8- hxcdf" =  "Furan4",
                                "PCB 169" =  "PCB169",
                                "PCB 126" = "PCB126"),
         variable2 = fct_recode(variable2, "PCB 74" = "PCB74",
                                "PCB 99" = "PCB99",
                                "PCB 118" = "PCB118",
                                "PCB 138" = "PCB138",
                                "PCB 153" = "PCB153",
                                "PCB 170" = "PCB170",
                                "PCB 180" = "PCB180",
                                "PCB 187" = "PCB187",
                                "PCB 194" = "PCB194",
                                "1,2,3,6,7,8- hxcdd" = "Dioxin1",
                                "1,2,3,4,6,7,8- hpcdd" = "Dioxin2",
                                "1,2,3,4,6,7,8,9- ocdd" =  "Dioxin3",
                                "2,3,4,7,8- pncdf" =  "Furan1",
                                "1,2,3,4,7,8- hxcdf" =  "Furan2",
                                "1,2,3,6,7,8- hxcdf" =  "Furan3",
                                "1,2,3,4,6,7,8- hxcdf" =  "Furan4",
                                "PCB 169" =  "PCB169",
                                "PCB 126" = "PCB126")) %>% 
  ggplot(aes(z1, est)) + 
  geom_smooth(aes(col = quantile), stat = "identity") + 
  facet_grid(variable2 ~ variable1, scales = "free", space = "free",
             labeller = labeller(variable1 = label_wrap_gen(5),
                                 variable2 = label_wrap_gen(5))) +
  ggtitle("h(Exposure 1 | Quantiles of Exposure 2)") +
  xlab("Exposure 1") + theme_bw(base_size = 20) + labs(col = "Quantile", y = "Estimate") +
  theme(strip.background = element_rect(fill = "white"),
        panel.spacing = unit(0.05, "lines"))
dev.off()

### Overall

png("./BKMR/bkmr_overall.png", width = 1000, height = 1000)
ggplot(risks.overall, aes(quantile, est, ymin = est - 1.96*sd, ymax = est + 1.96*sd)) +  
  geom_hline(yintercept=00, linetype="dashed", color="gray") + 
  geom_pointrange() + theme_bw(base_size = 25) +
  labs(x = "Quantile", y = "Estimate")
dev.off()

### Interaction 1 & 2

png("./BKMR/bkmr_int.png", width = 900, height = 1200)
risks.singvar %>% mutate(variable = fct_recode(variable, "PCB 74" = "PCB74",
                                               "PCB 99" = "PCB99",
                                               "PCB 118" = "PCB118",
                                               "PCB 138" = "PCB138",
                                               "PCB 153" = "PCB153",
                                               "PCB 170" = "PCB170",
                                               "PCB 180" = "PCB180",
                                               "PCB 187" = "PCB187",
                                               "PCB 194" = "PCB194",
                                               "1,2,3,6,7,8-hxcdd" = "Dioxin1",
                                               "1,2,3,4,6,7,8-hpcdd" = "Dioxin2",
                                               "1,2,3,4,6,7,8,9-ocdd" =  "Dioxin3",
                                               "2,3,4,7,8-pncdf" =  "Furan1",
                                               "1,2,3,4,7,8-hxcdf" =  "Furan2",
                                               "1,2,3,6,7,8-hxcdf" =  "Furan3",
                                               "1,2,3,4,6,7,8-hxcdf" =  "Furan4",
                                               "PCB 169" =  "PCB169",
                                               "PCB 126" = "PCB126")) %>% 
  ggplot(aes(variable, est, ymin = est - 1.96*sd,  ymax = est + 1.96*sd, col = q.fixed)) + 
  geom_hline(aes(yintercept=0), linetype="dashed", color="gray") +  
  geom_pointrange(position = position_dodge(width = 0.75)) +  coord_flip() + 
  theme_bw(base_size = 25) +
  labs(x = "", y = "Estimate", col = "Fixed Quantile")
dev.off()

png("./BKMR/bkmr_int2.png", width = 900, height = 1200)
risks.int %>% mutate(variable = fct_recode(variable, "PCB 74" = "PCB74",
                                           "PCB 99" = "PCB99",
                                           "PCB 118" = "PCB118",
                                           "PCB 138" = "PCB138",
                                           "PCB 153" = "PCB153",
                                           "PCB 170" = "PCB170",
                                           "PCB 180" = "PCB180",
                                           "PCB 187" = "PCB187",
                                           "PCB 194" = "PCB194",
                                           "1,2,3,6,7,8-hxcdd" = "Dioxin1",
                                           "1,2,3,4,6,7,8-hpcdd" = "Dioxin2",
                                           "1,2,3,4,6,7,8,9-ocdd" =  "Dioxin3",
                                           "2,3,4,7,8-pncdf" =  "Furan1",
                                           "1,2,3,4,7,8-hxcdf" =  "Furan2",
                                           "1,2,3,6,7,8-hxcdf" =  "Furan3",
                                           "1,2,3,4,6,7,8-hxcdf" =  "Furan4",
                                           "PCB 169" =  "PCB169",
                                           "PCB 126" = "PCB126")) %>% 
  ggplot(aes(variable, est, ymin = est - 1.96*sd, ymax = est + 1.96*sd)) + 
  geom_pointrange(position = position_dodge(width = 0.75)) + 
  geom_hline(yintercept = 0, lty = 2, col = "gray") + coord_flip() + theme_bw(base_size = 25) +
  labs(x = "", y = "Estimate")
dev.off()

## WQS

png("./WQS/wqs_weights.png", width = 1000, height = 1000, res = 80)
result2$final_weights %>% 
  mutate(Group = ifelse(mix_name == "LBX118LA", "TEQ", 
                  ifelse(grepl("LBX1", mix_name), "Non-Dioxin-like PCB",
                   ifelse(grepl("LBX0", mix_name), "Non-Dioxin-like PCB",
                    ifelse(grepl("LBXP", mix_name), "Non-Ortho PCB",
                     ifelse(grepl("LBXH", mix_name), "Non-Ortho PCB", "TEQ")))))) %>% 
  mutate(mix_name = tolower(mix_name),
         mix_name = fct_recode(mix_name, "PCB 74" = "lbx074la",
                               "PCB 99" = "lbx099la",
                               "PCB 118" = "lbx118la",
                               "PCB 138" = "lbx138la",
                               "PCB 153" = "lbx153la",
                               "PCB 170" = "lbx170la",
                               "PCB 180" = "lbx180la",
                               "PCB 187" = "lbx187la",
                               "PCB 194" = "lbx194la",
                               "1,2,3,6,7,8-hxcdd" = "lbxd03la",
                               "1,2,3,4,6,7,8-hpcdd" = "lbxd05la",
                               "1,2,3,4,6,7,8,9-ocdd" =  "lbxd07la",
                               "2,3,4,7,8-pncdf" =  "lbxf03la",
                               "1,2,3,4,7,8-hxcdf" =  "lbxf04la",
                               "1,2,3,6,7,8-hxcdf" =  "lbxf05la",
                               "1,2,3,4,6,7,8-hxcdf" =  "lbxf08la",
                               "PCB 169" =  "lbxhxcla",
                               "PCB 126" = "lbxpcbla"),
         mix_name = fct_reorder(mix_name, mean_weight)) %>% 
  ggplot(aes(x = mix_name, y = mean_weight, fill = Group)) +
  geom_bar(stat = "identity", color = "black") + theme_bw(base_size = 25) +
  theme(axis.ticks = element_blank(),
        axis.text.x = element_text(color='black'),
        legend.position = "bottom") + coord_flip() + 
  labs(y = "Weights", x = "")
dev.off()

### Heatmap

melted_cormat %>% as.tibble() %>% 
  arrange(desc(Correlation)) %>%
  filter(group3.1 == "Non-Dioxin-like PCB" & group3.2 == "Non-Dioxin-like PCB") %>% 
  View()

library(Hmisc)
rcorr(corrtest, type = "spearman")

