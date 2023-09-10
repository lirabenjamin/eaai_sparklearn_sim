ben_ratings = read_csv("data/ratings_ben.csv") %>% 
  select(id,feedback) %>% 
  mutate(
    rating = str_detect(feedback, "'rating', 'value': 'good'"),
    incomplete = str_detect(feedback, "'issue', 'value': 'incomplete'"),
    boredom = str_detect(feedback, "'issue', 'value': 'boredom'"),
    interest = str_detect(feedback, "'issue', 'value': 'interest'"),
    engagement = str_detect(feedback, "'issue', 'value': 'engagement'"),
    frustration = str_detect(feedback, "'issue', 'value': 'frustration'"),
    confidence = str_detect(feedback, "'issue', 'value': 'confidence '")
  ) %>% 
  select(-feedback) %>% 
  mutate(rater = "ben")

stef_ratings = read_csv("data/ratings_stef.csv") %>% 
  select(id,feedback) %>% 
  mutate(
    rating = str_detect(feedback, "'rating', 'value': 'good'"),
    incomplete = str_detect(feedback, "'issue', 'value': 'incomplete'"),
    boredom = str_detect(feedback, "'issue', 'value': 'boredom'"),
    interest = str_detect(feedback, "'issue', 'value': 'interest'"),
    engagement = str_detect(feedback, "'issue', 'value': 'engagement'"),
    frustration = str_detect(feedback, "'issue', 'value': 'frustration'"),
    confidence = str_detect(feedback, "'issue', 'value': 'confidence '")
  ) %>% 
  select(-feedback) %>%
  mutate(rater = "stef")

ratings = bind_rows(ben_ratings, stef_ratings)

ratings %>%
  pivot_longer(rating:confidence, names_to = "issue", values_to = "value")  %>% 
  pivot_wider(names_from = "rater", values_from = "value") %>% 
  group_by(issue) %>% 
  summarise(
    cor = cor(ben, stef, use = "pairwise.complete.obs"),
    ben_mean = mean(ben, na.rm = TRUE),
    stef_mean = mean(stef, na.rm = TRUE)
  ) %>%
  gt::gt() %>% 
  gt::fmt_number() %>% 
  # make into latex
  gt::as_latex()

