library(gt)

# lowecase is gt, uppercase is gpt rating

gpt_ratings = read_csv('data/conversations5_gptratings_and_truth.csv') %>% 
  select(id = UserId,Confidence:engagement)

gpt_ratings %>%
  select(-id) %>%
  Ben::harcor() %>% 
  gt()

gpt_ratings = gpt_ratings %>% 
  pivot_longer(Confidence:engagement) %>% 
  # mutate rater, if starts with uppercase, make it prompt, otherwise gpt
  mutate(rater = ifelse(str_detect(name, "^[A-Z]"), "prompt", "gpt"))

# see my ratings
ben_ratings = read_csv("data/output_ratings_ben.csv") %>% 
  select(id, Confidence:Engagement) %>% 
  pivot_longer(Confidence:Engagement) %>% 
  mutate(value = ifelse(value == "No", 0, 1)) %>% 
  mutate(rater = "ben")

long = bind_rows(gpt_ratings, ben_ratings) %>% 
  mutate(
    name = str_replace(name, "Confidence", "confidence"),
    name = str_replace(name, "Engagement", "engagement"),
    name = str_replace(name, "Boredom", "boredom"),
    name = str_replace(name, "Frustration", "frustration"),
    name = str_replace(name, "Curiosity/Interest", "curiosity")

    ) 

long    

long  %>%
  pivot_wider(names_from = rater, values_from = value) %>%
  mutate(ben = 10*ben) %>%
  group_by(name) %>% 
  summarise(
    prompt_mean = mean(prompt),
    gpt_mean = mean(gpt),
    ben_mean = mean(ben),
    prompt_sd = sd(prompt),
    gpt_sd = sd(gpt),
    ben_sd = sd(ben),
    cor_ben_prompt = cor(prompt, ben, use = "pairwise.complete.obs"),
    cor_ben_gpt = cor(gpt, ben, use = "pairwise.complete.obs")
  ) %>% 
  gt() %>%
  fmt_number(
    columns = vars(prompt_mean, gpt_mean, ben_mean, prompt_sd, gpt_sd, ben_sd, cor_ben_prompt, cor_ben_gpt),
    decimals = 2
  ) %>% 
  fmt_missing()

