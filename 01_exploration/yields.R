library(optics)
library(tidyverse)
library(emmeans)
library(lme4)
library(lmerTest)

d1 <- 
  op_yields |> 
  filter(name %in% c("grain_Mgha",
                     "straw_Mgha")) |> 
  left_join(op_trtkey |> filter(env_key == "0101") |> select(trt_id, herb_id, crop_id) |> distinct())

d2 <- 
  d1 |> 
  pivot_wider(names_from = name, values_from = value) |> 
  mutate(tot_Mgha = grain_Mgha + straw_Mgha)



# viz ---------------------------------------------------------------------

d1 |> 
  ggplot(aes(crop_id, value)) +
  geom_point(aes(color = name)) +
  facet_grid(.~herb_id)

d2 |> 
  ggplot(aes(crop_id, tot_Mgha)) +
  geom_point() +
  facet_grid(.~herb_id)

# quick stats -------------------------------------------------------------

#--total biomass NOT DONE
lmer(tot_Mgha ~ crop_id + herb_id + (), data = d2)
