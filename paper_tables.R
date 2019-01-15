library(tidyverse)
library(janitor)
library(stargazer)
options(scipen = 999)

## Concentration table
studypop <- read_csv("./Data/studypop.csv") %>% 
  clean_names() %>% 
  na.omit()  %>% #remove missing
  dplyr::select(3:10, 17:26) %>% 
  mutate_all(as.numeric) %>% 
  mutate_at(1:8, funs(./1000)) %>% 
  mutate_at(18, funs(./1000))

stargazer(as.data.frame(studypop), type = "text")

## Exposure POP distributions
## % / # below LOD
## Mean / Std dev
## 25th / Median / 75th %

## Mean
mean <- studypop %>%
  mutate_all(as.numeric) %>% 
  summarise_all(funs(list(enframe(mean(.))))) %>% 
  gather() %>% 
  unnest() %>% 
  spread(name, value) %>% 
  rename(mean = `1`)
  
mean

## Std
stdev <- studypop %>%
  mutate_all(as.numeric) %>% 
  summarise_all(funs(list(enframe(sd(.))))) %>% 
  gather() %>% 
  unnest() %>% 
  spread(name, value) %>% 
  rename(sdev = `1`)

stdev

## Quantiles
quant <- studypop %>%
  mutate_all(as.numeric) %>% 
  summarise_all(funs(list(enframe(quantile(., probs=c(0.25,0.5,0.75)))))) %>%
  gather() %>% 
  unnest() %>% 
  spread(name, value)

quant

## Study population for LOD
lod <- read_csv("./Data/studypop_c.csv") %>% 
  clean_names() %>% 
  na.omit() %>% #remove missing
  select(grep("lbd", colnames(.)))

lod <- lod %>% 
  summarise_all(sum) %>% 
  gather(key, num_lod) %>% 
  mutate(per_lod = (1003 - num_lod) / 1003,
         key = as.factor(key)) %>% 
  arrange(key) %>% 
  rename(key2 = key)

lod

## Make table
pop_table <- inner_join(mean, stdev, by = "key") %>% 
  inner_join(., quant, by = "key") %>% 
  cbind(., lod) %>% 
  rename(Q1 = `25%`,
         Median = `50%`,
         Q3 = `75%`) %>% 
  select(key, per_lod, everything(), -num_lod, -key2) %>% 
  mutate(per_lod = per_lod * 100) %>% 
  mutate_at(2:7, funs(round), 1) %>% 
  as.data.frame()

pop_table
  
stargazer(pop_table, summary = F, rownames = F, digits = 1, digits.extra=1)

##########

## Demographics table
## age, age$^2$, sex, race/ethnicity (non-Hispanic white, non-Hispanic black, Mexican American, other)
## educational attainment (less than high school, high school graduate, some college, college or more)
## BMI ($<$ 25, 25-29.9, $\ge$ 30), serum cotinine
## blood cell count and distribution

demo <- read_csv("./Data/studypop_c.csv") %>% 
  clean_names() %>% 
  na.omit()  %>% #remove missing
  select(age_cat, bmi_cat3, edu_cat, race_cat, male, cotinine_cat)

demo_table <- demo %>%
  gather(variable, value, age_cat, bmi_cat3, edu_cat, race_cat,  male, cotinine_cat) %>% 
  group_by(variable, value) %>% 
  summarise (n = n()) %>%
  mutate(percent = 100 * (n / sum(n)))

stargazer(demo_table, summary = F, rownames = F)

##########

##PCA, FCA, and cluster summary table 

summary_kmeans_hc <- read_csv("./Unsupervised/summary_kmeans_hc.csv")
summary_FA <- read_csv("./Unsupervised/FA_betas_confint.csv")
summary_PCA <- read_csv("./Unsupervised/PCA_betas_confint.csv")


bind_rows(summary_kmeans_hc, summary_FA, summary_PCA)




