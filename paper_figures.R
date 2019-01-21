#### Code for plots for paper
#### Only works with other files!!!
#### Look bad as is, but print well to file
#### 12/13/2018

## Unsupervised

### Heatmap

heatmap <- melted_cormat %>% 
  mutate(Var1 = fct_relevel(Var1, c("PCB 194",
                                    "PCB 187",
                                    "PCB 180",
                                    "PCB 170",
                                    "PCB 153",
                                    "PCB 138",
                                    "PCB 99",
                                    "PCB 74",
                                    "PCB 169",
                                    "PCB 126",
                                    "1,2,3,4,6,7,8-hxcdf",
                                    "1,2,3,6,7,8-hxcdf",
                                    "1,2,3,4,7,8-hxcdf",
                                    "2,3,4,7,8-pncdf",
                                    "1,2,3,4,6,7,8,9-ocdd",
                                    "1,2,3,4,6,7,8-hpcdd",
                                    "1,2,3,6,7,8-hxcdd",
                                    "PCB 118")),
         Var2 = fct_relevel(Var2, c("PCB 194",
                                    "PCB 187",
                                    "PCB 180",
                                    "PCB 170",
                                    "PCB 153",
                                    "PCB 138",
                                    "PCB 99",
                                    "PCB 74",
                                    "PCB 169",
                                    "PCB 126",
                                    "1,2,3,4,6,7,8-hxcdf",
                                    "1,2,3,6,7,8-hxcdf",
                                    "1,2,3,4,7,8-hxcdf",
                                    "2,3,4,7,8-pncdf",
                                    "1,2,3,4,6,7,8,9-ocdd",
                                    "1,2,3,4,6,7,8-hpcdd",
                                    "1,2,3,6,7,8-hxcdd",
                                    "PCB 118"))) %>% 
  mutate(group3.1 = fct_relevel(group3.1, c("mPFD", 
                                            "Non-Ortho PCBs", "Non-Dioxin-like PCBs"))) %>% 
  mutate(group3.2 = fct_relevel(group3.2, c("Non-Dioxin-like PCBs", "Non-Ortho PCBs", "mPFD"))) %>% 
  mutate(group3.1 = fct_recode(group3.1, 
                               "Mono-Ortho PCB 118,\nFurans and Dioxins" =  "mPFD",
                               "Non-Ortho\nPCBs" = "Non-Ortho PCBs")) %>% 
  mutate(group3.2 = fct_recode(group3.2, 
                               "Mono-Ortho PCB 118,\nFurans and Dioxins" = "mPFD",
                               "Non-Ortho\nPCBs" = "Non-Ortho PCBs")) %>% 
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
  facet_grid(group3.2 ~ group3.1, scales = "free", space = "free")

png("./Figures/heatmap.png", width = 1400, height = 1300, res = 90)
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
  mutate(chem = fct_relevel(chem, c("PCB 74",
                                    "PCB 99",
                                    "PCB 138",
                                    "PCB 153",
                                    "PCB 170",
                                    "PCB 180",
                                    "PCB 187",
                                    "PCB 194",
                                    "PCB 126",
                                    "PCB 169",
                                    "PCB 118",
                                    "1,2,3,6,7,8-hxcdd",
                                    "1,2,3,4,6,7,8-hpcdd",
                                    "1,2,3,4,6,7,8,9-ocdd",
                                    "2,3,4,7,8-pncdf",
                                    "1,2,3,4,7,8-hxcdf",
                                    "1,2,3,6,7,8-hxcdf",
                                    "1,2,3,4,6,7,8-hxcdf"))) %>% 
  mutate(Group = fct_recode(Group, 
                            "Mono-Ortho PCB 118,\nFurans and Dioxins" =  "mPFD")) %>% 
  ggplot(aes(x = chem, y = Loading, fill = Group)) + geom_col() +
  facet_wrap(~ PC) + theme_bw(base_size = 20) + 
  theme(legend.position = "bottom", axis.text.x = element_text(angle = 90, hjust = 1),
        strip.background = element_rect(fill = "white")) +
  geom_hline(yintercept = 0, size = 0.2) +
  labs(x = "Congeners",
       y = "Loadings")

png("./Figures/pca_plot.png", width = 1200, height = 1000, res = 100)
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
  mutate(chem = fct_relevel(chem, c("PCB 74",
                                             "PCB 99",
                                             "PCB 138",
                                             "PCB 153",
                                             "PCB 170",
                                             "PCB 180",
                                             "PCB 187",
                                             "PCB 194",
                                             "PCB 126",
                                             "PCB 169",
                                             "PCB 118",
                                             "1,2,3,6,7,8-hxcdd",
                                             "1,2,3,4,6,7,8-hpcdd",
                                             "1,2,3,4,6,7,8,9-ocdd",
                                             "2,3,4,7,8-pncdf",
                                             "1,2,3,4,7,8-hxcdf",
                                             "1,2,3,6,7,8-hxcdf",
                                             "1,2,3,4,6,7,8-hxcdf"))) %>% 
  mutate(Group = fct_recode(Group, 
                               "Mono-Ortho PCB 118,\nFurans and Dioxins" =  "mPFD")) %>% 
  ggplot(aes(x = chem, y = mean, fill = Group)) + geom_col() +
  geom_point(aes(y = pop_mean), size = 2) +
  facet_wrap(~ Cluster) + theme_bw(base_size = 20) + 
  theme(legend.position = "bottom", axis.text.x = element_text(angle = 90, hjust = 1),
        strip.background = element_rect(fill = "white")) +
  geom_hline(yintercept = 0, size = 0.2) +
  labs(x = "Congeners",
       y = "Mean")

png("./Figures/clusters.png", width = 1300, height = 900, res = 100)
plot3
dev.off()

### Hierarchical Clustering

png("./Figures/hier_branches.png", width = 900, height = 800)
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
  mutate(Variable = fct_relevel(Variable, c("PCB 74",
                                    "PCB 99",
                                    "PCB 138",
                                    "PCB 153",
                                    "PCB 170",
                                    "PCB 180",
                                    "PCB 187",
                                    "PCB 194",
                                    "PCB 126", 
                                    "PCB 169",
                                    "PCB 118",
                                    "1,2,3,6,7,8-hxcdd",
                                    "1,2,3,4,6,7,8-hpcdd",
                                    "1,2,3,4,6,7,8,9-ocdd",
                                    "2,3,4,7,8-pncdf",
                                    "1,2,3,4,7,8-hxcdf",
                                    "1,2,3,6,7,8-hxcdf",
                                    "1,2,3,4,6,7,8-hxcdf"))) %>% 
  mutate(Group = fct_recode(Group, "Mono-Ortho PCB 118,\nFurans and Dioxins" =  "mPFD",
                            "Non-Ortho\nPCBs" = "Non-Ortho PCBs")) %>% 
  ggplot(aes(x = Variable, y = Loading, fill = Group)) + geom_col() +
  facet_wrap(~ Factor) + theme_bw(base_size = 25) + 
  theme(legend.position = "bottom", axis.text.x = element_text(angle = 90, hjust = 1),
        strip.background = element_rect(fill = "white")) +
  labs(y = "Loadings", x = "Congeners") +
  geom_hline(yintercept = 0, size = 0.2)

png("./Figures/efa_plot.png", width = 1100, height = 1200, res = 100)
efa_plot
dev.off()

## Variable Selection

vs_plot <- plot_all %>% 
  mutate(variable = fct_relevel(variable, c("PCB 194",
                                            "PCB 187",
                                            "PCB 180",
                                            "PCB 170",
                                            "PCB 153",
                                            "PCB 138",
                                            "PCB 99",
                                            "PCB 74",
                                            "PCB 169",
                                            "PCB 126",
                                            "1,2,3,4,6,7,8-hxcdf",
                                            "1,2,3,6,7,8-hxcdf",
                                            "1,2,3,4,7,8-hxcdf",
                                            "2,3,4,7,8-pncdf",
                                            "1,2,3,4,6,7,8,9-ocdd",
                                            "1,2,3,4,6,7,8-hpcdd",
                                            "1,2,3,6,7,8-hxcdd",
                                            "PCB 118"))) %>%
  mutate(color3 = group3) %>% 
  mutate(color3 = fct_recode(color3, "Mono-Ortho PCB 118,\nFurans and Dioxins" =  "mPFD",
                             "Non-Ortho\nPCBs" = "Non-Ortho PCBs")) %>% 
  mutate(group3 = fct_relevel(group3, c("Non-Dioxin-like PCBs", "Non-Ortho PCBs", "mPFD"))) %>% 
  mutate(group3 = fct_recode(group3, "Mono-Ortho PCB 118,\nFurans and Dioxins" =  "mPFD",
                            "Non-Ortho\nPCBs" = "Non-Ortho PCBs")) %>% 
  ggplot(aes(x = variable, y = beta, color = color3)) + geom_point(size = 2.5) +
  geom_hline(yintercept = 0, color = "grey", linetype = "dashed") + theme_bw(base_size = 18) +
  facet_grid(group3 ~ method, scales="free_y", space = "free_y") + coord_flip() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position = "bottom",
        strip.background = element_rect(fill = "white")) +
  labs(y = "Beta Coefficients",
       x = "Congeners", 
       color = "POP Group")

png("./Figures/vs_plot.png", width = 1000, height = 1200, res = 100)
vs_plot
dev.off()

## BKMR

### Univariable

png("./Figures/bkmr_univar.png", width = 1500, height = 1600, res = 100)
pred.resp.univar %>% 
  mutate(Group = ifelse(variable == "PCB118", "mPFD", 
                  ifelse(grepl("Dioxin", variable), "mPFD",
                   ifelse(grepl("Furan", variable), "mPFD",
                    ifelse(variable == "PCB126", "Non-Ortho PCBs",
                     ifelse(variable == "PCB169", "Non-Ortho PCBs", "Non-Dioxin-like PCBs")))))) %>% 
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
  mutate(variable = fct_relevel(variable, c("PCB 74",
                                    "PCB 99",
                                    "PCB 138",
                                    "PCB 153",
                                    "PCB 170",
                                    "PCB 180",
                                    "PCB 187",
                                    "PCB 194",
                                    "PCB 126", 
                                    "PCB 169",
                                    "PCB 118",
                                    "1,2,3,6,7,8-hxcdd",
                                    "1,2,3,4,6,7,8-hpcdd",
                                    "1,2,3,4,6,7,8,9-ocdd",
                                    "2,3,4,7,8-pncdf",
                                    "1,2,3,4,7,8-hxcdf",
                                    "1,2,3,6,7,8-hxcdf",
                                    "1,2,3,4,6,7,8-hxcdf"))) %>% 
  mutate(Group = fct_recode(Group, "Mono-Ortho PCB 118, Furans and Dioxins" =  "mPFD")) %>% 
  ggplot(aes(z, est, ymin = est - 1.96*se, ymax = est + 1.96*se)) + 
  geom_smooth(aes(color = Group), stat = "identity") + ylab("h(z)") + 
  facet_wrap(~ variable) + theme_bw(base_size = 25) +
  theme(strip.background = element_rect(fill = "white"),
        legend.position = "bottom",
        axis.title = element_text(size = 40)) +
  labs(x = "Congeners", y = "Estimates")
dev.off()

### Bivariable 1 & 2

png("./Figures/bkmr_bivar.png", width = 2000, height = 2000)
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
  mutate(variable1 = fct_relevel(variable1, c("PCB 74",
                                              "PCB 99",
                                              "PCB 138",
                                              "PCB 153",
                                              "PCB 170",
                                              "PCB 180",
                                              "PCB 187",
                                              "PCB 194",
                                              "PCB 126", 
                                              "PCB 169",
                                              "PCB 118",
                                              "1,2,3,6,7,8- hxcdd",
                                              "1,2,3,4,6,7,8- hpcdd",
                                              "1,2,3,4,6,7,8,9- ocdd",
                                              "2,3,4,7,8- pncdf",
                                              "1,2,3,4,7,8- hxcdf",
                                              "1,2,3,6,7,8- hxcdf",
                                              "1,2,3,4,6,7,8- hxcdf")),
         variable2 = fct_relevel(variable2, c("PCB 74",
                                              "PCB 99",
                                              "PCB 138",
                                              "PCB 153",
                                              "PCB 170",
                                              "PCB 180",
                                              "PCB 187",
                                              "PCB 194",
                                              "PCB 126", 
                                              "PCB 169",
                                              "PCB 118",
                                              "1,2,3,6,7,8- hxcdd",
                                              "1,2,3,4,6,7,8- hpcdd",
                                              "1,2,3,4,6,7,8,9- ocdd",
                                              "2,3,4,7,8- pncdf",
                                              "1,2,3,4,7,8- hxcdf",
                                              "1,2,3,6,7,8- hxcdf",
                                              "1,2,3,4,6,7,8- hxcdf"))) %>% 
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

png("./Figures/bkmr_bivar2.png", width = 2000, height = 2000)
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
  mutate(variable1 = fct_relevel(variable1, c("PCB 74",
                                              "PCB 99",
                                              "PCB 138",
                                              "PCB 153",
                                              "PCB 170",
                                              "PCB 180",
                                              "PCB 187",
                                              "PCB 194",
                                              "PCB 126", 
                                              "PCB 169",
                                              "PCB 118",
                                              "1,2,3,6,7,8- hxcdd",
                                              "1,2,3,4,6,7,8- hpcdd",
                                              "1,2,3,4,6,7,8,9- ocdd",
                                              "2,3,4,7,8- pncdf",
                                              "1,2,3,4,7,8- hxcdf",
                                              "1,2,3,6,7,8- hxcdf",
                                              "1,2,3,4,6,7,8- hxcdf")),
         variable2 = fct_relevel(variable2, c("PCB 74",
                                              "PCB 99",
                                              "PCB 138",
                                              "PCB 153",
                                              "PCB 170",
                                              "PCB 180",
                                              "PCB 187",
                                              "PCB 194",
                                              "PCB 126", 
                                              "PCB 169",
                                              "PCB 118",
                                              "1,2,3,6,7,8- hxcdd",
                                              "1,2,3,4,6,7,8- hpcdd",
                                              "1,2,3,4,6,7,8,9- ocdd",
                                              "2,3,4,7,8- pncdf",
                                              "1,2,3,4,7,8- hxcdf",
                                              "1,2,3,6,7,8- hxcdf",
                                              "1,2,3,4,6,7,8- hxcdf"))) %>% 
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

png("./Figures/bkmr_overall.png", width = 1000, height = 1000, res = 100)
ggplot(risks.overall, aes(quantile, est, ymin = est - 1.96*sd, ymax = est + 1.96*sd)) +  
  geom_hline(yintercept=00, linetype="dashed", color="gray") + 
  geom_pointrange(size = 1.1) + theme_bw(base_size = 25) +
  labs(x = "Quantile", y = "Estimates")
dev.off()

### Interaction 1 & 2

png("./Figures/bkmr_int.png", width = 900, height = 1200)
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
  mutate(variable = fct_relevel(variable, c("1,2,3,4,6,7,8-hxcdf",
                                            "1,2,3,6,7,8-hxcdf",
                                            "1,2,3,4,7,8-hxcdf",
                                            "2,3,4,7,8-pncdf",
                                            "1,2,3,4,6,7,8,9-ocdd",
                                            "1,2,3,4,6,7,8-hpcdd",
                                            "1,2,3,6,7,8-hxcdd",
                                            "PCB 118",
                                            "PCB 169",
                                            "PCB 126",
                                            "PCB 194",
                                            "PCB 187",
                                            "PCB 180",
                                            "PCB 170",
                                            "PCB 153",
                                            "PCB 138",
                                            "PCB 99",
                                            "PCB 74"))) %>% 
  ggplot(aes(variable, est, ymin = est - 1.96*sd,  ymax = est + 1.96*sd, col = q.fixed)) + 
  geom_hline(aes(yintercept=0), linetype="dashed", color="gray") +  
  geom_pointrange(position = position_dodge(width = 0.75)) +  coord_flip() + 
  theme_bw(base_size = 25) +
  labs(x = "", y = "Estimate", col = "Fixed Quantile")
dev.off()

png("./Figures/bkmr_int2.png", width = 1000, height = 1200, res = 100)
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
  mutate(variable = fct_relevel(variable, c("1,2,3,4,6,7,8-hxcdf",
                                            "1,2,3,6,7,8-hxcdf",
                                            "1,2,3,4,7,8-hxcdf",
                                            "2,3,4,7,8-pncdf",
                                            "1,2,3,4,6,7,8,9-ocdd",
                                            "1,2,3,4,6,7,8-hpcdd",
                                            "1,2,3,6,7,8-hxcdd",
                                            "PCB 118",
                                            "PCB 169",
                                            "PCB 126",
                                            "PCB 194",
                                            "PCB 187",
                                            "PCB 180",
                                            "PCB 170",
                                            "PCB 153",
                                            "PCB 138",
                                            "PCB 99",
                                            "PCB 74"))) %>% 
  mutate(Group = case_when(variable == "PCB 118" ~ "mPFD",
                           variable == c("PCB 126", "PCB 169") ~ "Non-Ortho PCBs", 
                           grepl("PCB", variable) ~ "Non-Dioxin-like PCBs",
                           grepl(",", variable) ~ "mPFD")) %>% 
  mutate(Group = fct_recode(Group, "Mono-Ortho PCB 118,\nFurans and Dioxins" =  "mPFD",
                            "Non-Dioxin-like\nPCBs" = "Non-Dioxin-like PCBs",
                            "Non-Ortho\nPCBs" = "Non-Ortho PCBs")) %>% 
  ggplot(aes(variable, est, ymin = est - 1.96*sd, ymax = est + 1.96*sd)) + 
  geom_pointrange(aes(color = Group), position = position_dodge(width = 0.75), size = 1.1) + 
  geom_hline(yintercept = 0, lty = 2, col = "gray") + coord_flip() + theme_bw(base_size = 25) +
  labs(x = "", y = "Estimate") + theme(legend.position = "bottom", 
                                       legend.text = element_text(size = 15),
                                       legend.title = element_text(size = 17))
dev.off()

## WQS

png("./Figures/wqs_weights.png", width = 1000, height = 1000, res = 80)
result2$final_weights %>% 
  mutate(Group = ifelse(mix_name == "LBX118LA", "mPFD", 
                  ifelse(grepl("LBX1", mix_name), "Non-Dioxin-like PCBs",
                   ifelse(grepl("LBX0", mix_name), "Non-Dioxin-like PCBs",
                    ifelse(grepl("LBXP", mix_name), "Non-Ortho PCBs",
                     ifelse(grepl("LBXH", mix_name), "Non-Ortho PCBs", "mPFD")))))) %>% 
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
  mutate(Group = fct_recode(Group, "Mono-Ortho PCB 118,\nFurans and Dioxins" =  "mPFD",
                            "Non-Dioxin-like\nPCBs" = "Non-Dioxin-like PCBs",
                            "Non-Ortho\nPCBs" = "Non-Ortho PCBs")) %>% 
  ggplot(aes(x = mix_name, y = mean_weight, fill = Group)) +
  geom_hline(yintercept = 0.06, color = "grey", linetype = "dashed") +
  geom_bar(stat = "identity", color = "black") + theme_bw(base_size = 25) +
  theme(axis.ticks = element_blank(),
        axis.text.x = element_text(color='black'),
        legend.position = "bottom") + coord_flip() + 
  labs(y = "Weights", x = "Congeners")
dev.off()

## WQS reordered

png("./Figures/wqs_weights_reorder.png", width = 1000, height = 1000, res = 80)
result2$final_weights %>% 
  mutate(Group = ifelse(mix_name == "LBX118LA", "mPFD", 
                   ifelse(grepl("LBX1", mix_name), "Non-Dioxin-like PCBs",
                     ifelse(grepl("LBX0", mix_name), "Non-Dioxin-like PCBs",
                       ifelse(grepl("LBXP", mix_name), "Non-Ortho PCBs",
                         ifelse(grepl("LBXH", mix_name), "Non-Ortho PCBs", "mPFD")))))) %>% 
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
                               "PCB 126" = "lbxpcbla")) %>%
  mutate(mix_name = fct_relevel(mix_name, c("1,2,3,4,6,7,8-hxcdf",
                                            "1,2,3,6,7,8-hxcdf",
                                            "1,2,3,4,7,8-hxcdf",
                                            "2,3,4,7,8-pncdf",
                                            "1,2,3,4,6,7,8,9-ocdd",
                                            "1,2,3,4,6,7,8-hpcdd",
                                            "1,2,3,6,7,8-hxcdd",
                                            "PCB 118",
                                            "PCB 169",
                                            "PCB 126",
                                            "PCB 194",
                                            "PCB 187",
                                            "PCB 180",
                                            "PCB 170",
                                            "PCB 153",
                                            "PCB 138",
                                            "PCB 99",
                                            "PCB 74"))) %>% 
  mutate(Group = fct_recode(Group, "Mono-Ortho PCB 118,\nFurans and Dioxins" =  "mPFD",
                            "Non-Dioxin-like\nPCBs" = "Non-Dioxin-like PCBs",
                            "Non-Ortho\nPCBs" = "Non-Ortho PCBs")) %>% 
  ggplot(aes(x = mix_name, y = mean_weight, fill = Group)) +
  geom_hline(yintercept = 0.06, color = "grey", linetype = "dashed") +
  geom_bar(stat = "identity", color = "black") + theme_bw(base_size = 25) +
  theme(axis.ticks = element_blank(),
        axis.text.x = element_text(color='black'),
        legend.position = "bottom") + coord_flip() + 
  labs(y = "Weights", x = "Congeners") 
dev.off()


