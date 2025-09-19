#########################################
# Downloading PLACEs data to            #
# map the social determinants of health #
# for food and housing insecurity for   #
# the ISSUES lab next paper :)          #
# September 9, 2025                     #
# Example                               #
#########################################

# install.packages("RSocrata") etc once
library(RSocrata) # read online data
library(dplyr) # manipulate dataframes
library(utils) # utilities

base <- "https://data.cdc.gov/resource/yjkw-uj5s.json"

# Note there is a geojson endpoint however the geometry is the centroid
# so its better to download the non-spatial data and then get the census tract,
# and then merge the data to the census tract
fields <- c(
  "stateabbr","countyname","countyfips","tractfips",
  "foodinsecu_crudeprev","housinsecu_crudeprev"
)

select_q <- paste(fields, collapse = ",")

# Filter to Franklin County, Ohio (prefer FIPS for precision)
where_q <- "stateabbr = 'OH' AND countyfips = '39049'"

(url <- paste0(
  base, "?$select=", select_q,
  "&$where=", URLencode(where_q, reserved = TRUE)
))

df_franklin <- read.socrata(url) %>%
  mutate(
    foodinsecu_crudeprev = as.numeric(foodinsecu_crudeprev),
    housinsecu_crudeprev = as.numeric(housinsecu_crudeprev)
  )

glimpse(df_franklin)

library(tigris) # connect to census mapping files

# Note we have census tract level data, for Ohio (state fip = 39)
# Franklin County (county FIP = 049) and the general year of the data are 2024

oh_ct <- tracts(state = "Ohio", county = "Franklin", year = 2022)
df_franklin <- df_franklin %>% dplyr::rename(GEOID = tractfips )
oh_ct <- oh_ct %>% left_join(df_franklin)

plot(oh_ct["foodinsecu_crudeprev"], main = "Food Insecurity (%) — Franklin County, OH")

# Mean-impute missing
m_food <- mean(oh_ct$foodinsecu_crudeprev, na.rm = TRUE)
oh_ct$foodinsecu_crudeprev[is.na(oh_ct$foodinsecu_crudeprev)] <- m_food

# Plot
plot(oh_ct["foodinsecu_crudeprev"], main = "Food Insecurity (%) — Franklin County, OH")

library(sf)
st_write(oh_ct, "C:/Users/barboza-salerno.1/Documents/lab/content/resources/datasets/ohio-franklin-sdoh.geojson")
