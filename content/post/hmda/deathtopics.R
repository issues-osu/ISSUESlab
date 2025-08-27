# 1. Load libraries
library(dplyr)
library(stringr)
library(textclean)         # replace_contraction(), replace_url(), replace_emoji()
library(textstem)         # lemmatize_strings()
library(quanteda)         # corpus(), tokens(), dfm(), dfm_tfidf(), docfreq(), ndoc()
library(topicmodels)      # LDA(), perplexity()
library(tidytext)         # tidy()
library(broom)            # tidy() for topicmodels
library(wordcloud)        # wordcloud()
library(RColorBrewer)     # brewer.pal()
library(tidyverse)
library(cluster)
library(sf)
library(factoextra)
library(gridExtra)
library(kableExtra)
library(stringr)
library(tidytext)
library(yardstick)
library(rsample)
library(glmnet)
library(broom)
library(tmap)
library(tigris)
library(tidycensus)
library(tibble)
library(tidyverse)

################################

clt_tracts <- 
  get_acs(geography = "tract", 
          variables = c("B25026_001E","B02001_002E",
                        "B15001_050E","B15001_009E",
                        "B19013_001E","B25058_001E",
                        "B06012_002E"), 
          year=2020, state=17, county=031, 
          geometry=TRUE, output="wide") %>%
  st_transform('ESRI:102728') %>%
  rename(TotalPop = B25026_001E, 
         Whites = B02001_002E,
         FemaleBachelors = B15001_050E, 
         MaleBachelors = B15001_009E,
         MedHHInc = B19013_001E, 
         MedRent = B25058_001E,
         TotalPoverty = B06012_002E) %>%
  dplyr::select(-NAME, -starts_with("B")) %>%
  mutate(pctWhite = ifelse(TotalPop > 0, Whites / TotalPop,0),
         pctBachelors = ifelse(TotalPop > 0, ((FemaleBachelors + MaleBachelors) / TotalPop),0),
         pctPoverty = ifelse(TotalPop > 0, TotalPoverty / TotalPop, 0),
         year = "2020") %>%
  dplyr::select(-Whites, -FemaleBachelors, -MaleBachelors, -TotalPoverty) 

hmda<- read.csv('C:/Users/barboza-salerno.1/Documents/lab/static/media/tract_change_summary.csv')
min16 <- read.csv("C:/Users/barboza-salerno.1/Downloads/min16.csv") %>% rename(GEOID = FIPS, min16 = EP_MINRTY) %>% mutate(GEOID = as.character(GEOID))
min22 <- read.csv("C:/Users/barboza-salerno.1/Downloads/min22.csv") %>% rename(GEOID = FIPS, min22 = EP_MINRTY) %>% mutate(GEOID = as.character(GEOID))
hmda$GEOID <- as.character(hmda$census_tract)
test1<- inner_join(min16, min22, by = c("GEOID" = "GEOID"))
test2<- inner_join(test1, hmda, by = c("GEOID" = "GEOID"))
cltdata<- inner_join(clt_tracts, test2, by = c("GEOID" = "GEOID"))
cltdata$chmin <- cltdata$min22 - cltdata$min16

cltdata <- cltdata %>% 
  mutate_if(is.character,as.numeric) %>% 
  dplyr::select( c("GEOID","pct_black_2018","pct_white_2018","pct_hispanic_2018","med_income_2018","delta_black","delta_white","delta_income","delta_hispanic", "pctPoverty", "min22" )) %>% 
  st_drop_geometry(.) %>%
  na.omit(.)

summary_stats <- cltdata %>%
  summarise(across(
    .cols = where(is.numeric),
    .fns = list(
      mean = ~mean(.x, na.rm = TRUE),
      sd = ~sd(.x, na.rm = TRUE),
      min = ~min(.x, na.rm = TRUE),
      max = ~max(.x, na.rm = TRUE)
    ),
    .names = "{.col}_{.fn}"
  ))

# View the result
print(summary_stats)

data_scaled<- scale(cltdata[2:8])
distance <- get_dist(data_scaled)
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07")) ##Not all that useful, but gives a sense of what we are going to try to cluster in the next steps.
set.seed(123)
k2 <- kmeans(data_scaled, centers = 2, nstart = 25)
k3 <- kmeans(data_scaled, centers = 3, nstart = 25)
k4 <- kmeans(data_scaled, centers = 4, nstart = 25)
k5 <- kmeans(data_scaled, centers = 5, nstart = 25)
k6 <- kmeans(data_scaled, centers = 6, nstart = 25)
k7 <- kmeans(data_scaled, centers = 7, nstart = 25)
k8 <- kmeans(data_scaled, centers = 8, nstart = 25)
k9 <- kmeans(data_scaled, centers = 9, nstart = 25)

p1 <- fviz_cluster(k2, geom = "point", data = data_scaled) + ggtitle("k = 2")
p2 <- fviz_cluster(k3, geom = "point",  data = data_scaled) + ggtitle("k = 3")
p3 <- fviz_cluster(k4, geom = "point",  data = data_scaled) + ggtitle("k = 4")
p4 <- fviz_cluster(k5, geom = "point",  data = data_scaled) + ggtitle("k = 5")
p5 <- fviz_cluster(k6, geom = "point",  data = data_scaled) + ggtitle("k = 6")
p6 <- fviz_cluster(k7, geom = "point",  data = data_scaled) + ggtitle("k = 7")
p7 <- fviz_cluster(k8, geom = "point",  data = data_scaled) + ggtitle("k = 8")
p8 <- fviz_cluster(k9, geom = "point",  data = data_scaled) + ggtitle("k = 9")

grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, nrow = 3)

fviz_nbclust(data_scaled, kmeans, method = "wss")

fviz_nbclust(data_scaled, kmeans, method = "silhouette")

set.seed(123)
gap_stat <- clusGap(
  data_scaled,
  FUN = function(x, k) kmeans(x, centers = k, nstart = 25, iter.max = 100),
  K.max = 10,
  B = 50
)
fviz_gap_stat(gap_stat)


cltclusters<- cltdata %>%
  mutate(cluster5 = k5$cluster) %>%
  group_by(cluster5) %>%
  summarise_all("mean") %>%
  dplyr::select(-c("GEOID"))
kable(x=cltclusters)%>%kable_classic()

cltdata <- cltdata %>%
  mutate(cluster5 = k5$cluster)
cltdata$GEOID<-as.character(as.numeric(cltdata$GEOID))

joined<-left_join(clt_tracts, cltdata, by = "GEOID")

joined_clean <- joined %>%
  filter(!st_is_empty(geometry))  # removes the 1 empty geometry

# Now plot
tm_shape(joined_clean) +
  tm_polygons(col = "cluster5", style = "cat", palette = "Set3", title = "Cluster Group")
####################################################


# 2. Read & combine cause fields
me_data <- read.csv(
  "C:/Users/barboza-salerno.1/Downloads/Medical_Examiner_Case_Archive_20250712.csv",
  stringsAsFactors = FALSE
) %>%
  mutate(across(
    c(Primary.Cause, Primary.Cause.Line.A, Primary.Cause.Line.B,
      Primary.Cause.Line.C, Secondary.Cause),
    ~ na_if(str_trim(.x), "") %>% na_if("NA")
  )) %>%
  rowwise() %>%
  mutate(
    cause_text_raw = {
      parts <- na.omit(c_across(c(
        Primary.Cause, Primary.Cause.Line.A, Primary.Cause.Line.B,
        Primary.Cause.Line.C, Secondary.Cause
      )))
      paste(unique(parts), collapse = " | ")
    }
  ) %>% ungroup()

me_sf <- me_data %>%
  filter(!is.na(longitude) & !is.na(latitude)) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)  # assuming WGS84

# STEP 2: Transform ME data to match CRS of census tracts
me_sf_transformed <- st_transform(me_sf, crs = st_crs(joined))

# STEP 3: Spatial join — assign each ME record to a tract
me_with_tract <- st_join(me_sf_transformed, joined)

# 3. Thorough cleaning & lemmatization
me_with_tract <- me_with_tract %>%
  mutate(
    cause_clean = cause_text_raw %>%
      replace_contraction() %>%
      replace_url() %>%
      replace_emoji() %>%
      str_to_lower() %>%
      str_replace_all("\\|", " ") %>% 
      str_remove_all("\\b(residential|scene|address)\\b") %>%
      str_replace_all("[[:digit:]]+", " ") %>%
      str_replace_all("[[:punct:]]+", " ") %>%
      str_squish() %>%
      lemmatize_strings()
  )

me_with_tract <- me_with_tract %>%
  mutate(
    cause_clean = str_replace_all(
      cause_clean,
      regex("\\bwind\\b", ignore_case = TRUE),
      "wound"
    )
  )
# 4. Prepare documents with doc_id
# Assign doc_id to all rows with non-empty cleaned text
me_with_tract <- me_with_tract %>%
  filter(cause_clean != "") %>%
  mutate(doc_id = row_number())



remove_list <- c(
  "anpp", "combined", "complicated", "complications", "disease","wound",  "lower", "multiple", "complicating", "complication", "comlications", "organic", "probable",
  "disease","acute","chronic","multiple","complication","other", "anpp", "use",
  "due", "leave", "close", "low", "recent", "object", "fix", "unknown", "issue", "natural", "undetermined", "unwitnessed"
)

words<- me_with_tract %>% unnest_tokens(word, cause_clean) %>% anti_join(stop_words) %>% 
  filter(!word %in% remove_list)%>% 
  filter(!grepl('[0-9]', word))%>%filter(!cluster5 == 0)%>%st_drop_geometry(.)

library(dplyr)
library(stringr)

words <- words %>%
  mutate(
    word = case_when(
      # Collapse variations into "cardiovascular disease"
      word %in% c("cardiovascular", "atherosclerotic", "arteriosclerotic") ~ "cardiovascular disease",
      
      str_detect(word, regex("cardiovascular", ignore_case = TRUE)) ~ "cardiovascular disease",
      # Collapse to "diabetes mellitus"
      word %in% c("diabetes", "mellitus", "diabetes mellitus") ~ "diabetes mellitus",
      
      # Standardize to "despropionyl fentanyl"
      word %in% c("despropionyl", "fentanyl despropionyl", "despropionyl fentanyl") ~ "despropionyl fentanyl",
      
      # Standardize to "combined drug toxicity"
      word %in% c("combine", "combine drug", "drug", "toxicity") ~ "combined drug toxicity",
      
      word %in% c("despropionyl", "fentanyl") ~ "despropionyl fentanyl",
      
      word %in% c("blunt", "force", "blunt force", "force injury") ~ "blunt force injury",
      
      # Standardize to "motor vehicle"
      word %in% c("vehicle", "motor", "motor vehicle", "vehicle strike", "collision", "motor vehicle") ~ "vehicle collision",
      
      word %in% c("pulmonary", "obstructive") ~ "obstructive pulmonary",
      
      word %in% c("strike", "pedestrian") ~ "pedestrian strike",
      # Leave all others unchanged
      TRUE ~ word
    )
  )

# Step 1: Find Case.Numbers that have both "substance" and "abuse"
# Identify all Case.Numbers where "substance" appears
cases_with_substance <- words %>%
  filter(word == "substance") %>%
  pull(Case.Number) %>%
  unique()

# Replace "substance" with "substance_abuse" in those cases only
words <- words %>%
  mutate(word = if_else(word == "substance" & Case.Number %in% cases_with_substance,
                        "substance_abuse",
                        word))



#Remove words that only occurs less than 5 times
words$nn <- ave(words$word,words$word, FUN=length)
words$nn <- as.numeric(words$nn)
words<- words[ -which( words$nn <5), ]

words$word <- dplyr::case_when(
  words$word %in% c("obese", "obesity") ~ "obesity",
  words$word %in% c("ethanol", "ethanolism") ~ "ethanol",
  words$word %in% c("cardiovascular", "cardiomyopathy", "coronary", "atherosclerosis") ~ "cardiovascular",
  words$word %in% c("blunt", "blunt force injury") ~ "blunt_injury",
  TRUE ~ words$word
)

words_by_neighborhood <- words %>%
  count(cluster5, word, sort = TRUE) %>%
  ungroup()

words_by_neighborhood %>%
  filter(n >= 25) %>%
  arrange(desc(n)) %>%
  group_by(cluster5) %>%
  top_n(25, n) %>%
  ungroup() %>%
  mutate(word = fct_reorder(word, n)) %>%
  ggplot(aes(word, n, fill = factor(cluster5))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ cluster5, scales = "free", ncol = 3) +
  coord_flip() +
  labs(x = NULL, y = "Words by Cluster")


# 1. Define proper cluster labels for 7 clusters
cluster.lab <- c(
  '1' = "Latino Working-Class",
  '2' = "Disinvested Black Neighborhood",
  '3' = "Affluent White Enclaves",
  '4' = "White-Latino Transition",
  '5' = "Lower-Income Black"
)

# 2. Make sure your cluster column is named cluster7 and is a factor
words_by_neighborhood$cluster5 <- factor(words_by_neighborhood$cluster5)

# 3. Prepare plotting list
names <- levels(words_by_neighborhood$cluster5)
plist <- list()

# 4. Loop through each cluster and generate plots
for (i in seq_along(names)) {
  d <- subset(words_by_neighborhood, cluster5 == names[i])
  d <- subset(d, n >= 5)
  d <- head(d[order(-d$n), ], 20)  # Top 20 most frequent
  d$word <- factor(d$word, levels = d$word[order(d$n)])
  
  p1 <- ggplot(d, aes(x = word, y = n, fill = cluster5)) + 
    labs(y = NULL, x = NULL, fill = NULL) +
    geom_bar(stat = "identity") +
    facet_wrap(~cluster5, scales = "free", labeller = as_labeller(cluster.lab)) +
    coord_flip() +
    guides(fill = FALSE) +
    theme_bw() +
    theme(
      strip.background = element_blank(),
      panel.grid.major = element_line(colour = "grey80"),
      panel.border = element_blank(),
      axis.ticks = element_line(size = 0),
      panel.grid.minor.y = element_blank(),
      panel.grid.major.y = element_blank(),
      legend.position = "bottom"
    )
  
  plist[[names[i]]] <- p1
}

# 5. Display all plots in a grid (adjust ncol to your layout)
do.call("grid.arrange", c(plist, ncol = 3))


cluster_tf_idf <- words_by_neighborhood %>%
  bind_tf_idf(word, cluster5, n)

cluster_tf_idf %>%
  group_by(cluster5) %>%
  slice_max(tf_idf, n = 10) %>%
  ungroup() %>%
  ggplot(aes(tf_idf, fct_reorder(word, tf_idf), fill = cluster5)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~cluster5, ncol = 2, scales = "free", labeller = as_labeller(cluster.lab)) +
  labs(x = "tf-idf", y = NULL)


#Make binomial variables for each cluster (could be put in an elegant loop but...)


me_with_tract<-st_drop_geometry(me_with_tract)


# Create dummy variables for clusters 1 through 7
for (i in 1:5) {
  me_with_tract[[paste0("cluster", i)]] <- ifelse(me_with_tract$cluster5 == i, 1, 0)
  words[[paste0("cluster", i)]] <- ifelse(words$cluster5 == i, 1, 0)
}

data_split <- me_with_tract %>% dplyr::select(Case.Number)
data_split <- initial_split(data_split)
train_data <- training(data_split)
test_data <- testing(data_split)

#transform training data from tidy data structure to a sparse matrix
sparse_words <- words %>%
  count(Case.Number, word) %>%
  inner_join(train_data) %>%
  cast_sparse(Case.Number, word, n)

class(sparse_words)
dim(sparse_words)

word_rownames <- rownames(sparse_words)

data_joined <- data_frame(Case.Number = word_rownames) %>%
  left_join(me_with_tract %>%
              dplyr::select(Case.Number, cluster1, cluster2, cluster3, cluster4, cluster5))

doc_ids <- rownames(sparse_words)

# Align the cluster labels to the order of sparse_words
data_aligned <- data_joined %>%
  filter(Case.Number %in% doc_ids) %>%
  arrange(match(Case.Number, doc_ids))

# Confirm alignment
stopifnot(identical(data_aligned$Case.Number, doc_ids))


is_cluster <- as.numeric(data_aligned$cluster2 == 1)

model <- cv.glmnet(sparse_words, is_cluster,
                   family = "binomial", intercept = TRUE
                   #parallel = TRUE, keep = TRUE
)

weights <- ifelse(data_joined$cluster2 == 1, 1, 0.25)
model<- cv.glmnet(sparse_words, is_cluster, family = "binomial", weights = weights)
#Pull out coefficients
coefs <- model$glmnet.fit %>%
  tidy() %>%
  filter(lambda == model$lambda.min)

#Plot coefficients 
coefs %>%
  group_by(estimate > 0) %>%
  top_n(15, abs(estimate)) %>%
  ungroup() %>%
  ggplot(aes(fct_reorder(term, estimate), estimate, fill = estimate > 0)) +
  geom_col(alpha = 0.8, show.legend = FALSE) +
  coord_flip() + theme(axis.text=element_text(size=11)) +
  labs(
    x = NULL,
    title = "15 largest/smallest coefficients")

####################################################

intercept <- coefs %>%
  filter(term == "(Intercept)") %>%
  pull(estimate)

classifications <- words %>%
  inner_join(test_data) %>%
  inner_join(coefs, by = c("word" = "term")) %>%
  group_by(Case.Number) %>%
  summarize(score = sum(estimate)) %>%
  mutate(probability = plogis(intercept + score))

comment_classes <- classifications %>%
  left_join(me_with_tract %>%
              dplyr::select(cluster2, Case.Number), by = "Case.Number") %>% #change here to clusterX 
  mutate(cluster2 = as.factor(cluster2)) #change here to clusterX 



## Confusion matrix
# at 0.8 threshold
library(yardstick)
library(dplyr)

comment_classes <- comment_classes %>%
  mutate(
    prediction = case_when(
      probability > 0.5 ~ "1",
      TRUE ~ "0"
    ),
    prediction = as.factor(prediction),
    cluster2 = as.factor(cluster2)  # or cluster2 if that's your target
  )

library(glmnet)
library(dplyr)
library(ggplot2)
library(forcats)
library(broom)

for (cluster_num in 1:5) {
  
  cluster_name <- paste0("cluster", cluster_num)
  cat("\n------------------", cluster_name, "------------------\n")
  
  # Step 1: Define binary outcome and weights
  is_cluster <- data_joined[[cluster_name]] == 1
  weights <- ifelse(is_cluster, 1, 0.25)
  
  # Step 2: Fit weighted logistic regression with cross-validation
  model <- cv.glmnet(sparse_words, is_cluster, family = "binomial", weights = weights)
  
  # Step 3: Extract coefficients
  coefs <- broom::tidy(model$glmnet.fit) %>%
    filter(lambda == model$lambda.min)
  
  # Step 4: Plot top coefficients
  coefs %>%
    filter(term != "(Intercept)") %>%
    group_by(estimate > 0) %>%
    top_n(15, abs(estimate)) %>%
    ungroup() %>%
    ggplot(aes(fct_reorder(term, estimate), estimate, fill = estimate > 0)) +
    geom_col(show.legend = FALSE, alpha = 0.8) +
    coord_flip() +
    theme_minimal() +
    labs(title = paste("Top Coefficients for", cluster_name), x = NULL, y = "Estimate")
  
  # Step 5: Predict using coefficients
  intercept <- coefs %>% filter(term == "(Intercept)") %>% pull(estimate)
  beta_coefs <- coefs %>% filter(term != "(Intercept)") %>%
    rename(word = term)
  
  classifications <- words %>%
    inner_join(beta_coefs, by = "word") %>%
    group_by(Case.Number) %>%
    summarize(score = sum(estimate), .groups = "drop") %>%
    mutate(probability = plogis(intercept + score))
  
  # Step 6: Attach ground truth and create predictions
  comment_classes <- classifications %>%
    left_join(me_with_tract %>% select(Case.Number, !!sym(cluster_name)), by = "Case.Number") %>%
    rename(truth = !!sym(cluster_name)) %>%
    mutate(
      prediction = if_else(probability > 0.7, 1, 0)
    )
  
  # Step 7: Evaluation metrics
  TP <- sum(comment_classes$truth == 1 & comment_classes$prediction == 1)
  TN <- sum(comment_classes$truth == 0 & comment_classes$prediction == 0)
  FP <- sum(comment_classes$truth == 0 & comment_classes$prediction == 1)
  FN <- sum(comment_classes$truth == 1 & comment_classes$prediction == 0)
  
  accuracy <- (TP + TN) / (TP + TN + FP + FN)
  sensitivity <- TP / (TP + FN)
  specificity <- TN / (TN + FP)
  precision <- ifelse((TP + FP) == 0, NA, TP / (TP + FP))
  f1 <- ifelse(is.na(precision) | (sensitivity + precision) == 0, NA,
               2 * (precision * sensitivity) / (precision + sensitivity))
  
  # Print metrics
  cat("Accuracy:   ", round(accuracy, 3), "\n")
  cat("Sensitivity:", round(sensitivity, 3), "\n")
  cat("Specificity:", round(specificity, 3), "\n")
  cat("Precision:  ", round(precision, 3), "\n")
  cat("F1 Score:   ", round(f1, 3), "\n")
}

library(Matrix)
library(dplyr)
library(tidyr)
library(glmnet)
library(broom)
library(ggplot2)
library(forcats)

library(dplyr)
library(tidyr)
library(Matrix)
library(glmnet)
library(broom)
library(ggplot2)
library(forcats)
library(text2vec)

# --- Step 1: Sparse matrix of word counts ---
sparse_words <- words %>%
  count(Case.Number, word) %>%
  inner_join(train_data, by = "Case.Number") %>%
  cast_sparse(Case.Number, word, n)

# --- Step 2: Prepare covariates ---
# Ensure covariates include Case.Number and match sparse matrix
covariate_vars <- c("Case.Number", "MedHHInc", "Age", "Gender")  # adjust as needed

covariate_data <- me_with_tract %>%
  dplyr::select(all_of(covariate_vars)) %>%
  drop_na()  # drop missing rows

# --- Step 3: Align rows of sparse matrix and covariates ---
common_ids <- intersect(rownames(sparse_words), covariate_data$Case.Number)

sparse_words_clean <- sparse_words[common_ids, ]
covariate_data_clean <- covariate_data %>%
  filter(Case.Number %in% common_ids) %>%
  arrange(match(Case.Number, common_ids))

# --- Step 4: Create covariate matrix ---
X_covariates <- model.matrix(~ ., data = covariate_data_clean %>% select(-Case.Number))[ , -1]

# --- Step 5: Combine text + covariates ---
X_full <- cbind(sparse_words_clean, X_covariates)

# --- Step 6: Define outcome and weights ---
data_aligned <- me_with_tract %>%
  filter(Case.Number %in% rownames(X_full)) %>%
  arrange(match(Case.Number, rownames(X_full)))

# Replace 'cluster2' with your desired binary outcome variable
is_cluster <- data_aligned$cluster2 == 1
weights <- ifelse(is_cluster, 1, 0.25)

# --- Step 7: Fit glmnet model ---
model <- cv.glmnet(X_full, is_cluster, family = "binomial", weights = weights)

# --- Step 8: Extract coefficients at optimal lambda ---
coefs <- tidy(model$glmnet.fit) %>%
  filter(lambda == model$lambda.min)

# --- Step 9: Plot top coefficients ---
coefs %>%
  filter(term != "(Intercept)") %>%
  group_by(estimate > 0) %>%
  slice_max(order_by = abs(estimate), n = 15) %>%
  ungroup() %>%
  ggplot(aes(fct_reorder(term, estimate), estimate, fill = estimate > 0)) +
  geom_col(alpha = 0.8, show.legend = FALSE) +
  coord_flip() +
  theme_minimal(base_size = 12) +
  labs(
    title = "Top 15 Positive and Negative Coefficients",
    x = NULL,
    y = "Coefficient Estimate"
  )
library(yardstick)
library(dplyr)
library(tibble)

# --- Define cluster mapping ---
cluster_labels <- c(
  cluster1 = "Latino Working-Class",
  cluster2 = "Disinvested Black Neighborhood",
  cluster3 = "Affluent White Enclaves",
  cluster4 = "White-Latino Transition",
  cluster5 = "Lower-Income Black"
)




# --- Initialize list to store model results ---
results_list <- list()

for (cluster_col in names(cluster_labels)) {
  
  # --- Define outcome ---
  data_aligned <- data_joined %>%
    filter(Case.Number %in% rownames(X_full)) %>%
    arrange(match(Case.Number, rownames(X_full)))
  
  is_cluster <- data_aligned[[cluster_col]] == 1
  weights <- ifelse(is_cluster, 1, 0.25)
  
  # --- Fit model ---
  model <- cv.glmnet(X_full, is_cluster, family = "binomial", weights = weights)
  
  # --- Extract coefficients ---
  coefs <- broom::tidy(model$glmnet.fit) %>% 
    filter(lambda == model$lambda.min)
  
  intercept <- coefs %>% filter(term == "(Intercept)") %>% pull(estimate)
  beta_coefs <- coefs %>% filter(term != "(Intercept)")
  
  matched_beta <- beta_coefs %>%
    filter(term %in% colnames(X_full)) %>%
    arrange(match(term, colnames(X_full)))
  
  X_mat <- X_full[, matched_beta$term]
  score <- as.numeric(X_mat %*% matched_beta$estimate) + intercept
  probability <- plogis(score)
  prediction_vec <- ifelse(probability > 0.7, 1, 0)
  
  # --- Create eval_data ---
  eval_data <- data.frame(
    Case.Number = rownames(X_full),
    truth = factor(is_cluster, levels = c(FALSE, TRUE), labels = c(0, 1)),
    prediction = factor(prediction_vec, levels = c(0, 1))
  )
  
  # --- Compute metrics ---
  acc  <- accuracy(eval_data, truth = truth, estimate = prediction)$.estimate
  sens <- sensitivity(eval_data, truth = truth, estimate = prediction)$.estimate
  spec <- specificity(eval_data, truth = truth, estimate = prediction)$.estimate
  prec <- precision(eval_data, truth = truth, estimate = prediction)$.estimate
  f1   <- f_meas(eval_data, truth = truth, estimate = prediction)$.estimate
  
  # --- Store results ---
  results_list[[cluster_col]] <- tibble(
    cluster = cluster_col,
    label = cluster_labels[[cluster_col]],
    Accuracy = round(acc, 3),
    Sensitivity = round(sens, 3),
    Specificity = round(spec, 3),
    Precision = round(prec, 3),
    F1_Score = round(f1, 3)
  )
}

# Combine into results table
results_all <- bind_rows(results_list)
print(results_all)
##########################################################
##############################################################
################################
# 1. Load libraries (deduplicated & ordered for clarity)
library(tidyverse)        # includes dplyr, ggplot2, stringr, tibble, readr, tidyr, etc.
library(sf)
library(tigris)
library(tidycensus)
library(cluster)
library(factoextra)
library(gridExtra)
library(kableExtra)
library(textclean)        # replace_contraction(), replace_url(), replace_emoji()
library(textstem)         # lemmatize_strings()
library(quanteda)         # corpus(), tokens(), dfm(), dfm_tfidf(), docfreq(), ndoc()
library(topicmodels)      # LDA(), perplexity()
library(tidytext)         # tidy()
library(broom)            # tidy() for topicmodels and glmnet
library(wordcloud)        # wordcloud()
library(RColorBrewer)     # brewer.pal()
library(yardstick)
library(rsample)
library(glmnet)
library(tmap)

clt_tracts <- get_acs(
  geography = "tract", 
  variables = c("B25026_001E","B02001_002E", "B15001_050E","B15001_009E",
                "B19013_001E","B25058_001E", "B06012_002E"), 
  year = 2020, state = 17, county = 031, 
  geometry = TRUE, output = "wide"
) %>%
  st_transform('ESRI:102728') %>%
  rename(
    TotalPop = B25026_001E, 
    Whites = B02001_002E,
    FemaleBachelors = B15001_050E, 
    MaleBachelors = B15001_009E,
    MedHHInc = B19013_001E, 
    MedRent = B25058_001E,
    TotalPoverty = B06012_002E
  ) %>%
  mutate(
    pctWhite     = if_else(TotalPop > 0, Whites / TotalPop, 0),
    pctBachelors = if_else(TotalPop > 0, (FemaleBachelors + MaleBachelors) / TotalPop, 0),
    pctPoverty   = if_else(TotalPop > 0, TotalPoverty / TotalPop, 0),
    year         = "2020"
  ) %>%
  dplyr::select(GEOID, MedHHInc, MedRent, pctWhite, pctBachelors, pctPoverty)

# Load and clean tract-level external data
hmda <- read_csv('C:/Users/barboza-salerno.1/Documents/lab/static/media/tract_change_summary.csv') %>%
  mutate(GEOID = as.character(census_tract))

min16 <- read_csv("C:/Users/barboza-salerno.1/Downloads/min16.csv") %>%
  rename(GEOID = FIPS, min16 = EP_MINRTY) %>%
  mutate(GEOID = as.character(GEOID))

min22 <- read_csv("C:/Users/barboza-salerno.1/Downloads/min22.csv") %>%
  rename(GEOID = FIPS, min22 = EP_MINRTY) %>%
  mutate(GEOID = as.character(GEOID))

# Join all together
cltdata <- list(min16, min22, hmda) %>%
  reduce(inner_join, by = "GEOID") %>%
  inner_join(clt_tracts, by = "GEOID") %>%
  mutate(chmin = min22 - min16)

cltdata <- cltdata %>%
  mutate(across(where(is.character), as.numeric)) %>%
  dplyr::select(
    GEOID, pct_black_2018, pct_white_2018, pct_hispanic_2018,
    med_income_2018, delta_black, delta_white, delta_income,
    delta_hispanic, pctPoverty, min22
  ) %>%
  st_drop_geometry() %>%
  drop_na()

# Scale features
data_scaled <- scale(cltdata[2:8])

# Visualize distance matrix
distance <- get_dist(data_scaled)
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

# Run k-means clustering for k = 2 to 9
set.seed(123)
k_list <- map(2:9, ~kmeans(data_scaled, centers = .x, nstart = 25))
names(k_list) <- paste0("k", 2:9)

# Create plots for each k
p_list <- map2(k_list, names(k_list), ~
                 fviz_cluster(.x, data = data_scaled, geom = "point") + ggtitle(.y)
)

# Display plots in grid
do.call(grid.arrange, c(p_list, nrow = 3))

fviz_nbclust(data_scaled, kmeans, method = "wss")
fviz_nbclust(data_scaled, kmeans, method = "silhouette")

set.seed(123)
gap_stat <- clusGap(
  data_scaled,
  FUN = function(x, k) kmeans(x, centers = k, nstart = 25, iter.max = 100),
  K.max = 10,
  B = 50
)
fviz_gap_stat(gap_stat)

cltdata <- cltdata %>%
  mutate(cluster5 = k_list[["k5"]]$cluster)

cltclusters <- cltdata %>%
  group_by(cluster5) %>%
  summarise(across(everything(), mean), .groups = "drop") %>%
  dplyr::select(-GEOID)

kable(cltclusters) %>% kable_classic()

cltdata <- cltdata %>%
  mutate(GEOID = as.character(as.numeric(GEOID)))  # ensure type match

joined <- left_join(clt_tracts, cltdata, by = "GEOID")

joined_clean <- joined %>%
  filter(!st_is_empty(geometry))

library(tmap)
library(showtext)
library(sf)

# Load Google font for consistent, crisp rendering
font_add_google("Roboto", "roboto")
showtext_auto()

# Set global font family for tmap
tmap_options(fontfamily = "roboto")

cluster_labels <- c(
  "1" = "Latino Working-Class",
  "2" = "Disinvested Black Neighborhood",
  "3" = "Affluent White Enclaves",
  "4" = "White-Latino Transition",
  "5" = "Lower-Income Black"
)
joined_clean$cluster_label <- factor(
  as.character(joined_clean$cluster5),
  levels = names(cluster_labels),
  labels = cluster_labels
)

cb_palette <- c(
  "#88CCEE",  # Latino Working-Class (blue)
  "#CC6677",  # Disinvested Black Neighborhood (reddish)
  "#DDCC77",  # Affluent White Enclaves (yellow)
  "#117733",  # White-Latino Transition (green)
  "#332288"   # Lower-Income Black (dark blue)
)

tmap_mode("plot")  # static mode for publication-quality map

map <- tm_shape(joined_clean) +
  tm_polygons(
    col = "cluster_label",
    palette = cb_palette,
    title = "Neighborhood Cluster",
    border.col = "gray40",
    lwd = 0.3,
    colorNA = "white",   
    textNA = "Missing"
  ) +
  tm_layout(
    title = "Cook County Neighborhood Typology",
    title.size = 2.0,
    legend.title.size = 1.8,
    legend.text.size = 1.5,
    legend.outside = TRUE,
    legend.outside.position = "right",
    frame = FALSE,
    bg.color = "white",
    inner.margins = c(0.02, 0.02, 0.02, 0.02)
  )

print(map)

tmap_save(map, "Cook_County_Neighborhood_Typology.png", width = 10, height = 8, dpi = 300)


############################################################

table(joined_clean$cluster5)
# 2. Read & combine cause fields
me_data <- read.csv(
  "C:/Users/barboza-salerno.1/Downloads/Medical_Examiner_Case_Archive_20250712.csv",
  stringsAsFactors = FALSE
) %>%
  mutate(across(
    c(Primary.Cause, Primary.Cause.Line.A, Primary.Cause.Line.B,
      Primary.Cause.Line.C, Secondary.Cause),
    ~ na_if(str_trim(.x), "") %>% na_if("NA")
  )) %>%
  rowwise() %>%
  mutate(
    cause_text_raw = {
      parts <- na.omit(c_across(c(
        Primary.Cause, Primary.Cause.Line.A, Primary.Cause.Line.B,
        Primary.Cause.Line.C, Secondary.Cause
      )))
      paste(unique(parts), collapse = " | ")
    }
  ) %>% ungroup()

me_sf <- me_data %>%
  filter(!is.na(longitude) & !is.na(latitude)) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

me_with_tract <- me_sf %>%
  st_transform(crs = st_crs(joined)) %>%
  st_join(joined)

me_with_tract <- me_with_tract %>%
  mutate(
    cause_clean = cause_text_raw %>%
      replace_contraction() %>%
      replace_url() %>%
      replace_emoji() %>%
      str_to_lower() %>%
      str_replace_all("\\|", " ") %>%
      str_remove_all("\\b(residential|scene|address)\\b") %>%
      str_replace_all("[[:digit:]]+", " ") %>%
      str_replace_all("[[:punct:]]+", " ") %>%
      str_squish() %>%
      lemmatize_strings() %>%
      str_replace_all("\\bwind\\b", "wound")
  ) %>%
  filter(cause_clean != "") %>%
  mutate(doc_id = row_number())

remove_list <- c(
  "anpp", "combined", "complicated", "complications", "disease", "wound", "lower", "multiple",
  "complicating", "complication", "comlications", "organic", "probable", "acute", "chronic",
  "other", "use", "due", "leave", "close", "low", "recent", "object", "fix", "unknown", "dc", "death",
  "issue", "natural", "undetermined", "unwitnessed"
)

words <- me_with_tract %>%
  unnest_tokens(word, cause_clean) %>%
  anti_join(stop_words, by = "word") %>%
  filter(!word %in% remove_list, !str_detect(word, "\\d"), cluster5 != 0) %>%
  st_drop_geometry()

words <- words %>%
  mutate(word = case_when(
    word %in% c("cardiovascular", "atherosclerotic", "arteriosclerotic") ~ "cardiovascular disease",
    str_detect(word, regex("cardiovascular", ignore_case = TRUE)) ~ "cardiovascular disease",
    word %in% c("diabetes", "mellitus") ~ "diabetes mellitus",
    word %in% c("despropionyl", "fentanyl despropionyl") ~ "despropionyl fentanyl",
    word %in% c("combine", "drug", "toxicity") ~ "combined drug toxicity",
    word %in% c("blunt", "force", "force injury") ~ "blunt force injury",
    word %in% c("motor", "vehicle", "collision", "vehicle strike") ~ "vehicle collision",
    word %in% c("pulmonary", "obstructive") ~ "obstructive pulmonary",
    word %in% c("strike", "pedestrian") ~ "pedestrian strike",
    TRUE ~ word
  ))

words <- words %>%
  mutate(Case.Number = as.character(Case.Number))

cases_with_substance <- words %>%
  filter(word == "substance") %>%
  pull(Case.Number) %>%
  unique()

words <- words %>%
  mutate(word = if_else(word == "substance" & Case.Number %in% cases_with_substance,
                        "substance_abuse", word))
words <- words %>%
  group_by(word) %>%
  filter(n() >= 5) %>%
  ungroup() %>%
  mutate(word = case_when(
    word %in% c("obese", "obesity") ~ "obesity",
    word %in% c("ethanol", "ethanolism") ~ "ethanol",
    word %in% c("cardiovascular", "cardiomyopathy", "coronary", "atherosclerosis") ~ "cardiovascular",
    word %in% c("blunt", "blunt force injury") ~ "blunt_injury",
    TRUE ~ word
  ))
words_by_neighborhood <- words %>%
  count(cluster5, word, sort = TRUE) %>%
  ungroup()

library(forcats)   

# Define labels
# --- Define cluster mapping ---
cluster.lab <- c(
  cluster1 = "Latino Working-Class",
  cluster2 = "Disinvested Black Neighborhood",
  cluster3 = "Affluent White Enclaves",
  cluster4 = "White-Latino Transition",
  cluster5 = "Lower-Income Black"
)

cluster_labels <- setNames(cluster.lab, as.character(1:5))

words_by_neighborhood %>%
  filter(n >= 10) %>%
  group_by(cluster5) %>%
  slice_max(n, n = 10) %>%
  ungroup() %>%
  mutate(
    word = fct_reorder(word, n),
    cluster5_label = factor(as.character(cluster5), 
                            levels = names(cluster_labels), 
                            labels = cluster_labels)
  ) %>%
  ggplot(aes(word, n, fill = cluster5_label)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ cluster5_label, scales = "free", ncol = 3) +
  coord_flip() +
  labs(x = NULL, y = "Words by Cluster") +
  theme_minimal(base_size = 14) +
  theme(
    strip.text = element_text(size = 18, face = "bold", color = "black"),
    axis.text.y = element_text(size = 18, color = "black"),    # y axis text (word labels)
    axis.text.x = element_text(size = 18, color = "black"),    # x axis text (counts)
    axis.title.y = element_text(size = 18),
    axis.title.x = element_text(size = 18),
    plot.margin = margin(1, 1, 1, 2, "cm")
  )



# Ensure cluster5 is a factor
words_by_neighborhood <- words_by_neighborhood %>%
  mutate(cluster5 = paste0("cluster", cluster5))


# Generate list of plots
plist <- words_by_neighborhood %>%
  group_by(cluster5) %>%
  filter(n >= 5) %>%
  slice_max(n, n = 20) %>%
  ungroup() %>%
  mutate(word = fct_reorder(word, n)) %>%
  group_split(cluster5) %>%
  map(~ {
    ggplot(.x, aes(x = word, y = n, fill = cluster5)) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~cluster5, scales = "free", labeller = as_labeller(cluster.lab)) +
      coord_flip() +
      labs(x = NULL, y = NULL) +
      theme_bw() +
      theme(
        strip.background = element_blank(),
        panel.grid.major = element_line(colour = "grey80"),
        panel.border = element_blank(),
        axis.ticks = element_line(size = 0),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        legend.position = "bottom"
      )
  })

# Display in grid
do.call(grid.arrange, c(plist, ncol = 3))

cluster_tf_idf <- words_by_neighborhood %>%
  bind_tf_idf(word, cluster5, n)

cluster_tf_idf %>%
  group_by(cluster5) %>%
  slice_max(tf_idf, n = 10) %>%
  ungroup() %>%
  mutate(word = fct_reorder(word, tf_idf)) %>%
  ggplot(aes(tf_idf, word, fill = cluster5)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(
    ~cluster5,
    ncol = 2,
    scales = "free",
    labeller = as_labeller(cluster.lab)
  ) +
  labs(x = "tf-idf", y = NULL) +
  theme_minimal(base_size = 16) +  # Slightly larger base font size
  theme(
    strip.text = element_text(size = 18, face = "bold"),
    axis.text.x = element_text(size = 14, color = "black"),
    axis.text.y = element_text(size = 14, color = "black"),
    axis.title.x = element_text(size = 16, face = "bold", margin = margin(t = 10)),
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5)
  )


# Drop geometry for modeling
me_with_tract <- st_drop_geometry(me_with_tract)

table(me_with_tract$cluster5)

for (i in 1:5) {
  colname <- paste0("cluster", i)
  
  me_with_tract[[colname]] <- ifelse(me_with_tract$cluster5 == i, 1, 0)
  words[[colname]]         <- ifelse(words$cluster5 == i, 1, 0)
}
table(me_with_tract$cluster1)
table(me_with_tract$cluster2)
table(me_with_tract$cluster3)
table(me_with_tract$cluster4)
table(me_with_tract$cluster5)


library(glmnet)
library(broom)
library(dplyr)

# 1. Train/test split
data_split <- initial_split(me_with_tract %>% select(Case.Number))
train_data <- training(data_split)
test_data <- testing(data_split)

# 2. Sparse matrix for training cases
sparse_words <- words %>%
  count(Case.Number, word) %>%
  inner_join(train_data, by = "Case.Number") %>%
  cast_sparse(Case.Number, word, n)

# 3. Align data
data_joined <- tibble(Case.Number = rownames(sparse_words)) %>%
  left_join(me_with_tract %>% select(Case.Number, starts_with("cluster")), by = "Case.Number")

doc_ids <- rownames(sparse_words)

data_aligned <- data_joined %>%
  filter(Case.Number %in% doc_ids) %>%
  arrange(match(Case.Number, doc_ids))

stopifnot(identical(data_aligned$Case.Number, doc_ids))

# Store coefficients for each cluster
coefs_list <- list()

for (i in 1:5) {
  cat("Fitting model for cluster", i, "\n")
  
  cluster_var <- paste0("cluster", i)
  is_cluster <- as.numeric(data_aligned[[cluster_var]] == 1)
  weights <- ifelse(is_cluster == 1, 1, 0.25)
  
  set.seed(1000 + i)  # Ensure reproducibility
  model <- cv.glmnet(sparse_words, is_cluster, family = "binomial", weights = weights)
  
  coefs <- broom::tidy(model$glmnet.fit) %>%
    filter(lambda == model$lambda.min, term != "(Intercept)")
  
  coefs_list[[i]] <- coefs
}

library(ggplot2)
library(forcats)

for (i in 1:5) {
  coefs <- coefs_list[[i]]
  
  if (nrow(coefs) == 0) next
  
  p <- coefs %>%
    group_by(estimate > 0) %>%
    slice_max(order_by = abs(estimate), n = min(15, nrow(.))) %>%
    ungroup() %>%
    ggplot(aes(fct_reorder(term, estimate), estimate, fill = estimate > 0)) +
    geom_col(alpha = 0.8, show.legend = FALSE) +
    coord_flip() +
    labs(
      x = NULL,
      y = "Coefficient",
      title = paste("Top Coefficients Predicting Cluster", i)
    ) +
    theme_minimal(base_size = 14) +
    theme(
      strip.text = element_text(size = 18, face = "bold", color = "black"),
      axis.text.y = element_text(size = 16, color = "black"),
      axis.text.x = element_text(size = 16, color = "black"),
      axis.title.y = element_text(size = 16),
      axis.title.x = element_text(size = 16),
      plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
      plot.margin = margin(1, 1, 1, 2, "cm")
    )
  
  print(p)
}

library(fmsb)
par(mfrow = c(2, 3), mar = c(1, 2, 2, 1))  # 2 rows, 3 columns

for (i in 1:5) {
  cat("Radar chart for cluster", i, "\n")
  coefs <- coefs_list[[i]]
  
  if (is.null(coefs) || nrow(coefs) < 3) next
  
  top_terms <- coefs %>%
    slice_max(order_by = abs(estimate), n = min(15, nrow(coefs))) %>%
    mutate(term = as.character(term))  # Avoid factor-related pivot_wider issues
  
  radar_data <- top_terms %>%
    select(term, estimate) %>%
    pivot_wider(names_from = term, values_from = estimate, values_fill = 0)
  
  if (ncol(radar_data) < 3) next  # radarchart needs at least 3 variables
  
  max_row <- apply(radar_data, 2, function(x) max(1.2, max(abs(x)) * 1.2))
  min_row <- apply(radar_data, 2, function(x) -max(1.2, max(abs(x)) * 1.2))
  radar_ready <- bind_rows(max_row, min_row, radar_data)
  
  radarchart(
    radar_ready,
    axistype = 1,
    pcol = "blue",
    pfcol = scales::alpha("blue", 0.4),
    plwd = 3,
    cglcol = "grey",
    cglty = 1,
    axislabcol = "black",
    caxislabels = seq(-1, 1, 0.5),
    vlcex = 1.3
  )
  
  title(main = paste("Cluster", i), cex.main = 1.8)
}

# --- Step 1: Sparse matrix of word counts ---
sparse_words <- words %>%
  count(Case.Number, word) %>%
  inner_join(train_data, by = "Case.Number") %>%
  cast_sparse(Case.Number, word, n)

me_with_tract <- me_with_tract %>%
  mutate(
    MedHHInc_scaled = scale(MedHHInc)[, 1],
    Age_scaled = scale(Age)[, 1]
  )


# --- Step 2: Prepare covariates ---
# Ensure covariates include Case.Number and match sparse matrix
covariate_vars <- c("Case.Number", "MedHHInc_scaled", "Age", "Gender")  # adjust as needed

covariate_data <- me_with_tract %>%
  dplyr::select(all_of(covariate_vars)) %>%
  drop_na()  # drop missing rows

# --- Step 3: Align rows of sparse matrix and covariates ---
common_ids <- intersect(rownames(sparse_words), covariate_data$Case.Number)

sparse_words_clean <- sparse_words[common_ids, ]
covariate_data_clean <- covariate_data %>%
  filter(Case.Number %in% common_ids) %>%
  arrange(match(Case.Number, common_ids))

# --- Step 4: Create covariate matrix ---
X_covariates <- model.matrix(~ ., data = covariate_data_clean %>% select(-Case.Number))[ , -1]

# --- Step 5: Combine text + covariates ---
X_full <- cbind(sparse_words_clean, X_covariates)

# --- Step 6: Define outcome and weights ---
data_aligned <- me_with_tract %>%
  filter(Case.Number %in% rownames(X_full)) %>%
  arrange(match(Case.Number, rownames(X_full)))

# Replace 'cluster2' with your desired binary outcome variable
is_cluster <- data_aligned$cluster5 == 1
weights <- ifelse(is_cluster, 1, 0.25)

# --- Step 7: Fit glmnet model ---
model <- cv.glmnet(X_full, is_cluster, family = "binomial", weights = weights)

# --- Step 8: Extract coefficients at optimal lambda ---
coefs <- tidy(model$glmnet.fit) %>%
  filter(lambda == model$lambda.min)

# --- Step 9: Plot top coefficients ---
coefs %>%
  filter(term != "(Intercept)") %>%
  group_by(estimate > 0) %>%
  slice_max(order_by = abs(estimate), n = 15) %>%
  ungroup() %>%
  ggplot(aes(fct_reorder(term, estimate), estimate, fill = estimate > 0)) +
  geom_col(alpha = 0.8, show.legend = FALSE) +
  coord_flip() +
  theme_minimal(base_size = 12) +
  labs(
    title = "Top 15 Positive and Negative Coefficients",
    x = NULL,
    y = "Coefficient Estimate"
  )


# --- Define cluster mapping ---
cluster_labels <- c(
  cluster1 = "Latino Working-Class",
  cluster2 = "Disinvested Black Neighborhood",
  cluster3 = "Affluent White Enclaves",
  cluster4 = "White-Latino Transition",
  cluster5 = "Lower-Income Black"
)




# --- Initialize list to store model results ---
results_list <- list()

for (cluster_col in names(cluster_labels)) {
  
  # --- Define outcome ---
  data_aligned <- data_joined %>%
    filter(Case.Number %in% rownames(X_full)) %>%
    arrange(match(Case.Number, rownames(X_full)))
  
  is_cluster <- data_aligned[[cluster_col]] == 1
  weights <- ifelse(is_cluster, 1, 0.25)
  
  # --- Fit model ---
  model <- cv.glmnet(X_full, is_cluster, family = "binomial", weights = weights)
  
  # --- Extract coefficients ---
  coefs <- broom::tidy(model$glmnet.fit) %>% 
    filter(lambda == model$lambda.min)
  
  intercept <- coefs %>% filter(term == "(Intercept)") %>% pull(estimate)
  beta_coefs <- coefs %>% filter(term != "(Intercept)")
  
  matched_beta <- beta_coefs %>%
    filter(term %in% colnames(X_full)) %>%
    arrange(match(term, colnames(X_full)))
  
  X_mat <- X_full[, matched_beta$term]
  score <- as.numeric(X_mat %*% matched_beta$estimate) + intercept
  probability <- plogis(score)
  prediction_vec <- ifelse(probability > 0.7, 1, 0)
  
  # --- Create eval_data ---
  eval_data <- data.frame(
    Case.Number = rownames(X_full),
    truth = factor(is_cluster, levels = c(FALSE, TRUE), labels = c(0, 1)),
    prediction = factor(prediction_vec, levels = c(0, 1))
  )
  
  # --- Compute metrics ---
  acc  <- accuracy(eval_data, truth = truth, estimate = prediction)$.estimate
  sens <- sensitivity(eval_data, truth = truth, estimate = prediction)$.estimate
  spec <- specificity(eval_data, truth = truth, estimate = prediction)$.estimate
  prec <- precision(eval_data, truth = truth, estimate = prediction)$.estimate
  f1   <- f_meas(eval_data, truth = truth, estimate = prediction)$.estimate
  
  # --- Store results ---
  results_list[[cluster_col]] <- tibble(
    cluster = cluster_col,
    label = cluster_labels[[cluster_col]],
    Accuracy = round(acc, 3),
    Sensitivity = round(sens, 3),
    Specificity = round(spec, 3),
    Precision = round(prec, 3),
    F1_Score = round(f1, 3)
  )
}

# Combine into results table
results_all <- bind_rows(results_list)
print(results_all)

###############################################this is correct
library(glmnet)
library(broom)
library(yardstick)
library(dplyr)
library(tibble)

# Ensure X_full and data_aligned are properly defined
stopifnot(identical(rownames(X_full), data_aligned$Case.Number))

# Define cluster labels
cluster_labels <- c(
  cluster1 = "Latino Working-Class",
  cluster2 = "Disinvested Black Neighborhood",
  cluster3 = "Affluent White Enclaves",
  cluster4 = "White-Latino Transition",
  cluster5 = "Lower-Income Black"
)

# Initialize results container
results_list <- list()

# Loop over each binary cluster outcome
for (cluster_col in names(cluster_labels)) {
  
  cat("\n====================", cluster_col, "====================\n")
  
  # --- STEP 1: Define binary outcome + weights ---
  is_cluster <- as.numeric(data_aligned[[cluster_col]] == 1)
  weights <- ifelse(is_cluster == 1, 1, 0.25)
  
  # --- STEP 2: Run penalized logistic regression ---
  model <- cv.glmnet(X_full, is_cluster, family = "binomial", weights = weights)
  
  # --- STEP 3: Extract coefficients ---
  coefs <- tidy(model$glmnet.fit) %>%
    filter(lambda == model$lambda.min)
  
  intercept <- coefs %>% filter(term == "(Intercept)") %>% pull(estimate)
  beta_coefs <- coefs %>% filter(term != "(Intercept)")
  
  # --- STEP 4: Predict using linear combination of selected features ---
  matched_beta <- beta_coefs %>%
    filter(term %in% colnames(X_full)) %>%
    arrange(match(term, colnames(X_full)))
  
  X_mat <- X_full[, matched_beta$term, drop = FALSE]
  score <- as.numeric(X_mat %*% matched_beta$estimate) + intercept
  probability <- plogis(score)
  prediction_vec <- ifelse(probability > 0.5, 1, 0)
  
  # --- STEP 5: Evaluation data frame ---
  eval_data <- tibble(
    Case.Number = rownames(X_full),
    truth = factor(is_cluster, levels = c(0, 1)),
    prediction = factor(prediction_vec, levels = c(0, 1))
  )
  
  # --- STEP 6: Evaluation metrics ---
  acc  <- accuracy(eval_data, truth = truth, estimate = prediction)$.estimate
  sens <- sensitivity(eval_data, truth = truth, estimate = prediction)$.estimate
  spec <- specificity(eval_data, truth = truth, estimate = prediction)$.estimate
  prec <- precision(eval_data, truth = truth, estimate = prediction)$.estimate
  f1   <- f_meas(eval_data, truth = truth, estimate = prediction)$.estimate
  
  # --- STEP 7: Save results ---
  results_list[[cluster_col]] <- tibble(
    cluster = cluster_col,
    label = cluster_labels[[cluster_col]],
    Accuracy = round(acc, 3),
    Sensitivity = round(sens, 3),
    Specificity = round(spec, 3),
    Precision = round(prec, 3),
    F1_Score = round(f1, 3)
  )
}

# --- STEP 8: Combine all model results ---
results_all <- bind_rows(results_list)

# --- STEP 9: View or save ---
print(results_all)

####################### isolate
# STEP 1: Get Case.Numbers with valid word data
X_text <- sparse_words_clean
case_ids <- rownames(X_text)  # These are Case.Number

# STEP 2: Filter me_with_tract for those cases
data_aligned <- me_with_tract %>%
  mutate(Case.Number = as.character(Case.Number)) %>%
  filter(Case.Number %in% case_ids) %>%
  arrange(match(Case.Number, case_ids))

# STEP 3: Build covariate matrix
X_cov <- model.matrix(~ ., data = data_aligned %>% 
                        select(MedHHInc_scaled, Age_scaled, Gender))[, -1]
rownames(X_cov) <- data_aligned$Case.Number

# STEP 4: Combine X_text + X_cov
X_text <- X_text[data_aligned$Case.Number, ]
X_cov <- X_cov[data_aligned$Case.Number, ]
X_full <- cbind(X_text, X_cov)

# Final alignment check
stopifnot(identical(rownames(X_text), data_aligned$Case.Number))
stopifnot(identical(rownames(X_cov), data_aligned$Case.Number))
stopifnot(identical(rownames(X_full), data_aligned$Case.Number))
evaluate_model <- function(X_matrix, y_vector, weights) {
  model <- cv.glmnet(X_matrix, y_vector, family = "binomial", weights = weights)
  
  coefs <- tidy(model$glmnet.fit) %>%
    filter(lambda == model$lambda.min)
  intercept <- coefs %>% filter(term == "(Intercept)") %>% pull(estimate)
  beta_coefs <- coefs %>% filter(term != "(Intercept)")
  
  matched_beta <- beta_coefs %>%
    filter(term %in% colnames(X_matrix)) %>%
    arrange(match(term, colnames(X_matrix)))
  
  X_mat <- X_matrix[, matched_beta$term, drop = FALSE]
  score <- as.numeric(X_mat %*% matched_beta$estimate) + intercept
  probability <- plogis(score)
  prediction_vec <- ifelse(probability > 0.5, 1, 0)
  
  eval_data <- tibble(
    truth = factor(y_vector, levels = c(0, 1)),
    prediction = factor(prediction_vec, levels = c(0, 1))
  )
  
  tibble(
    Accuracy = accuracy(eval_data, truth, prediction)$.estimate,
    Sensitivity = sensitivity(eval_data, truth, prediction)$.estimate,
    Specificity = specificity(eval_data, truth, prediction)$.estimate,
    Precision = precision(eval_data, truth, prediction)$.estimate,
    F1_Score = f_meas(eval_data, truth, prediction)$.estimate
  )
}
results_list <- list()

for (cluster_col in names(cluster_labels)) {
  
  y <- as.numeric(data_aligned[[cluster_col]] == 1)
  weights <- ifelse(y == 1, 1, 0.25)
  
  text_res <- evaluate_model(X_text, y, weights) %>%
    mutate(Features = "Text Only", Cluster = cluster_col)
  
  cov_res <- evaluate_model(X_cov, y, weights) %>%
    mutate(Features = "Covariates Only", Cluster = cluster_col)
  
  full_res <- evaluate_model(X_full, y, weights) %>%
    mutate(Features = "Text + Covariates", Cluster = cluster_col)
  
  results_list[[cluster_col]] <- bind_rows(text_res, cov_res, full_res)
}

model_comparison <- bind_rows(results_list) %>%
  left_join(tibble(Cluster = names(cluster_labels), Label = cluster_labels), by = "Cluster")

print(model_comparison)

for (i in 1:5) {
  cat("Processing cluster", i, "\n")
  
  # Define outcome
  cluster_var <- paste0("cluster", i)
  is_cluster <- as.numeric(data_aligned[[cluster_var]] == 1)
  weights <- ifelse(data_aligned[[cluster_var]] == 1, 1, 0.25)
  
  # Fit model
  model <- cv.glmnet(sparse_words, is_cluster, family = "binomial", weights = weights)
  
  # Extract coefficients
  coefs <- broom::tidy(model$glmnet.fit) %>%
    filter(lambda == model$lambda.min)
  
  # Plot top coefficients
  p <- coefs %>%
    filter(term != "(Intercept)") %>%
    group_by(estimate > 0) %>%
    top_n(15, abs(estimate)) %>%
    ungroup() %>%
    ggplot(aes(fct_reorder(term, estimate), estimate, fill = estimate > 0)) +
    geom_col(alpha = 0.8, show.legend = FALSE) +
    coord_flip() +
    theme(axis.text = element_text(size = 11),
          strip.text = element_text(size = 18, face = "bold", color = "black"),
          axis.text.y = element_text(size = 18, color = "black"),    # y axis text (word labels)
          axis.text.x = element_text(size = 18, color = "black"),    # x axis text (counts)
          axis.title.y = element_text(size = 18),
          axis.title.x = element_text(size = 18),
          plot.margin = margin(1, 1, 1, 2, "cm")
    ) +
    labs(
      x = NULL,
      title = paste("Top Coefficients Predicting Cluster", i),
      y = "Coefficient",
      
    ) +
    theme_minimal(base_size = 14) 
  
  print(p)
}


