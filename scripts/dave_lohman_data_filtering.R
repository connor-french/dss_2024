# script to process Dave Lohman's raw data into something usable for the class
library(tidyverse)
library(readxl)


d <- read_xlsx("data/raw_data/Lohman_Thai_butterfly_data.xlsx") %>% 
  janitor::clean_names() %>% 
  filter(
    # remove mistaken classifications of canopy
    canopy_understory == "C" | canopy_understory == "U",
    # remove improperly formatted date
    date != "05/37/07"
    ) %>% 
  rename(cloud_cover = cloud_cover_clear_partly_cloudy_overcast) %>% 
  mutate(
    cloud_cover = case_when(
      cloud_cover == "Overcast" ~ "O",
      cloud_cover == "P/C" ~ "PC",
      cloud_cover == "P" ~ "PC",
      cloud_cover == "raining" ~ "R",
      .default = as.character(cloud_cover)
    )
      )

ggplot(d %>% filter(!is.na(percent_humidity), number_specimens > 0), aes(x = percent_humidity, y = number_specimens, color = canopy_understory)) + 
  geom_point() +
  geom_smooth(method = "lm")

ggplot(d, aes(x = rain_since_last_collection_cm, y = number_specimens, color = canopy_understory)) + 
  geom_boxplot()
  

ggplot(d, aes(x = trap_site, y = number_specimens)) +
  geom_boxplot()


understory_only <- d %>% 
  filter(!is.na(percent_humidity),
         canopy_understory == "U")

summary(lm(number_specimens ~ percent_humidity, data = understory_only))

# I forgot to set a seed, so running this again will result in a different dataset
d_filt <- d %>% 
  filter(!is.na(percent_humidity)) %>% 
  select(canopy_understory, temp_c, percent_humidity, cloud_cover, number_specimens) %>% 
  slice_sample(n = 10, by = canopy_understory)

d_filt %>% 
  ggplot(aes(x = percent_humidity, y = number_specimens, color = canopy_understory)) +
  geom_point() +
  geom_smooth(method = "lm")

write_csv(d_filt, "data/w2_thai_butterflies_small.csv")



