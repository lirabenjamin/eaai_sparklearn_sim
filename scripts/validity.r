library(gt)

# lowecase is gt, uppercase is gpt rating

read_csv('data/conversations5_gptratings_and_truth.csv') %>% 
  select(Confidence:engagement) %>% 
  select(-UserId) %>%
  Ben::harcor() %>% 
  gt()
