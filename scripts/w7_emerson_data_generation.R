## Generate data for W7 Mark Emerson 
library(tidyverse)
library(here)

set.seed(1234)
ctrl <- rnorm(4, mean = 9.76, sd = 2.27)

set.seed(567892)
maml_dn <- rnorm(4, mean = 2.6, sd = 2)




df <- tibble(
  perc_hes5 = c(ctrl, maml_dn),
  treatment = c(rep("Control", 4), rep("MAML-DN", 4))
)

write_csv(df, here("data", "w7_emerson_data.csv"))
