library(optics)
library(tidyverse)

rm(list = ls())

d1 <- 
  op_plotkey |> 
  filter(env_key == "0101") |> 
  left_join(op_trtkey) |> 
  filter(trt_id %in% c("p", "a")) |> 
  select(env_key, plot_id, trt_id)

plot_half <- c("D", "Y")
  
  
d3 <- crossing(d1, plot_half)


d4 <- 
  d3 |> 
  left_join(op_envkey) |> 
  mutate(ben_sample_nu = 1:n()) |> 
  select(ben_sample_nu, loc_au, loc_id, plot_id, trt_id, plot_half)
  

d4 |> 
  write.table("labels/2026-03-18_samples-for-Ben.csv", sep = ";", row.names = F)
