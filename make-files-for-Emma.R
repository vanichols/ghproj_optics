library(optics)
library(tidyverse)


op_trtkeydetails |> 
  filter(env_key == "0101") |> 
  write.table(
    file = "data/for-emma/op_trtkeydetails.csv",
    sep = ";",
    #dec = ",",
    row.names = FALSE,
    col.names = TRUE
  )


op_cropkey |> 
  filter(env_key == "0101") |> 
  write.table(
    file = "data/for-emma/op_cropkey.csv",
    sep = ";",
    #dec = ",",
    row.names = FALSE,
    col.names = TRUE
  )

