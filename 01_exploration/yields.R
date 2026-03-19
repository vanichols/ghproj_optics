library(optics)
library(tidyverse)
library(emmeans)
library(lme4)
library(lmerTest)



# sexy1 -------------------------------------------------------------------

#--biomass components
b1 <- 
  op_yields |>
  filter(env_key == "0101") |> 
  filter(name %in% c("grain_Mgha",
                     "straw_Mgha")) |> 
  left_join(op_trtkey |> filter(env_key == "0101") |> select(trt_id, herb_id, crop_id) |> distinct())

#--need block for stats model
b2 <- 
  b1 |> 
  left_join(op_plotkey |> select(env_key, plot_id, block_id) |> mutate(plot_id = as.character(plot_id)),
            by = c("plot_id", "env_key"))

#--total biomass
t1 <- 
  b2 |> 
  pivot_wider(names_from = name, values_from = value) |> 
  mutate(tot_Mgha = grain_Mgha + straw_Mgha)



# viz ---------------------------------------------------------------------

b1 |> 
  ggplot(aes(crop_id, value)) +
  geom_point(aes(color = name)) +
  facet_grid(.~herb_id)

#--plot 305 is a bit odd in straw, maybe lodging...
t1 |> 
  filter(straw_Mgha < 3.8)

t1 |> 
  ggplot(aes(crop_id, tot_Mgha)) +
  geom_point() +
  facet_grid(.~herb_id)

#--decent fig
f1 <- 
  b2 |> 
  filter(herb_id == "herbicide") |> 
  group_by(crop_id, name) |> 
  summarise(value = mean(value, na.rm = T)) |> 
  filter(crop_id %in% c("a", "p")) 

g1 <- f1 |> filter(name == "grain_Mgha")

ggplot(data = f1, aes(crop_id, value)) +
  geom_col(aes(fill = name), color = "black") +
  geom_text(data = g1, aes(crop_id, y = 8, label = round(value, 2)), color = "black") 



# quick stats -------------------------------------------------------------

#--total biomass NOT DONE
m1 <- lmer(tot_Mgha ~ crop_id*herb_id + (1|block_id), data = t1)

anova(m1)

em1 <- emmeans(m1, ~crop_id)
pairs(em1)

#--grain
m2 <- lmer(grain_Mgha ~ crop_id*herb_id + (1|block_id), data = t1)

anova(m2)

em2 <- emmeans(m2, ~crop_id)
pairs(em2)
em2

#--straw
m3 <- lmer(straw_Mgha ~ crop_id*herb_id + (1|block_id), data = t1)

anova(m3)

em3 <- emmeans(m3, ~crop_id)
pairs(em3)
