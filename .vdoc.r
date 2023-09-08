# nolint start
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
knitr::include_graphics("data/eedi/images/945.jpg")
#
#
#
#
#
#| message: false
library(gt)
read_csv("data/eedi/train_data/train_task_1_2.csv") %>% head %>% gt() %>% tab_header(title = "Training data: Task 1 and 2")
train_data = read_csv("data/eedi/train_data/train_task_3_4.csv") 
train_data %>% head %>% gt() %>% tab_header(title = "Training data: Task 3 and 4")
#
#
#
#
#
#| message: false
question_metadata = read_csv("data/eedi/metadata/question_metadata_task_1_2.csv") 
question_metadata %>% 
  head() %>%
  gt() %>% 
  tab_header(title = "Question Metadata")
#
#
#
#
#
#| message: false
subject_metadata = read_csv("data/eedi/metadata/subject_metadata.csv") 
subject_metadata %>% 
  head() %>%
  gt() %>% 
  tab_header(title = "Subject Metadata")
#
#
#
#
#| message: false   
student_metadata = read_csv("data/eedi/metadata/student_metadata_task_3_4.csv") 
student_metadata %>% 
  head() %>%
  gt() %>% 
  tab_header(title = "Student Metadata")
#
#
#
#
#
#| message: false
answer_metadata = read_csv("data/eedi/metadata/answer_metadata_task_3_4.csv")
answer_metadata %>% 
  head() %>%
  gt() %>% 
  tab_header(title = "Answer Metadata")

answer_metadata %>% count(is.na(Confidence)) %>% mutate(prop = n/sum(n))
#
#
#
#
#
#
#
#
#
#
#
#
train_data %>% slice(1000) %>% gt()
#
#
#
#
#
knitr::include_graphics("data/eedi/images/533.jpg")
#
#
#
#
#
#
#
#
#
#
student_metadata %>% filter(UserId == 2918) %>% gt()
#
#
#
#
answer_metadata %>% filter(AnswerId == 723667) %>% gt()
#
#
#
#
question_metadata %>% filter(QuestionId == 533) %>% 
  pull(SubjectId) %>% 
  # get numbers
  str_extract_all("[0-9]+", simplify = TRUE) %>% 
  as.numeric() %>%
  enframe() %>% 
  left_join(subject_metadata, by = c("value" = "SubjectId")) %>% 
  gt()

#
#
#
#
#
train_data %>% filter(UserId == 2918) %>% 
  left_join(question_metadata, by = c("QuestionId" = "QuestionId")) %>% 
  left_join(answer_metadata, by = c("AnswerId" = "AnswerId")) %>%
  arrange(DateAnswered) %>%
  filter(QuizId == 37) %>%
  gt() %>%
  tab_style(
    style = list(
      cell_fill(color = "lightblue")
    ),
    locations = cells_body(
      rows = c(QuestionId == 533)
    )
  ) %>%
  tab_header(title = "Sequence of questions")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
knitr::include_graphics("output/pilot/embedding similarity.png")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
set.seed(34)

# Setting parameters
initial_skill <- 120
skill_variance <- 10
initial_motivation <- 100
motivation_variance <- 10
motivation_boost <- 0.01
initial_difficulty <- rnorm(1, initial_skill, skill_variance)
measurement_error <- rnorm(1, 0, 5)  # measurement error for motivation

# Initialize
S <- initial_skill
M <- rnorm(1, initial_motivation, motivation_variance)
D <- initial_difficulty
engagement_outcome <- "engage"
iteration <- 1  # iteration counter

# ITS recommender simulation
while (engagement_outcome != "quit") {
  print(paste("Iteration:", iteration))
  print(paste("Skill (S):", S))
  print(paste("Motivation (M):", M))
  print(paste("Difficulty (D):", D))
  
  # Calculate probability student knows answer
  skill_minus_difficulty <- S - D
  probability_student_knows <- 1 / (1 + exp(-skill_minus_difficulty))

  # Determine engagement probabilities
  P_engage <- 1 / (1 + exp(-0.05 * (S + M - D)))
  P_engage <- min(max(P_engage, 0.05), 0.95)  # Clipping P_engage to lie within [0.05, 0.95]
  P_guess <- (1 - P_engage) / 2
  P_quit <- 1 - P_engage - P_guess

  # Determine engagement outcome
  engagement_outcome <- sample(c("try", "guess", "quit"), 1, prob = c(P_engage, P_guess, P_quit))
  print(paste("Engagement outcome:", engagement_outcome))

  # Update M and S based on outcome
  if (engagement_outcome == "try") {
    probability_correct_try <- 1 / (1 + exp(-(probability_student_knows + motivation_boost * M)))
    correct <- sample(c(TRUE, FALSE), 1, prob = c(probability_correct_try, 1 - probability_correct_try))
    print(paste("Tried and got the answer", ifelse(correct, "correct", "incorrect")))
    if (correct) {
      S <- S + rnorm(1, 0.5, 0.1)  # Assumption: increase skill slightly if correct
      M <- M + rnorm(1, 0, measurement_error)  # Assumption: Motivation update with measurement error
    } else {
      M <- M - rnorm(1, 0, measurement_error)  # Assumption: decrease motivation with error if wrong
    }
  } else if (engagement_outcome == "guess") {
    correct <- sample(c(TRUE, FALSE), 1, prob = c(0.5, 0.5))  # 50% chance to get it right by guessing
    print(paste("Guessed and got the answer", ifelse(correct, "correct", "incorrect")))
    if (correct) {
      M <- M - rnorm(1, 0, measurement_error)  # Assumption: decrease motivation with error if correct guess
    } else {
      M <- M - rnorm(1, 0, measurement_error)  # Assumption: decrease motivation with error if wrong guess
    }
  }

  # Update D based on new estimates of S and M
  D <- rnorm(1, S, skill_variance)
  iteration <- iteration + 1
  print("")  # Blank line for better readability
}

print(paste("Final skill:", S))
print(paste("Final motivation:", M))
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
complete_data = train_data %>% 
  left_join(question_metadata, by = c("QuestionId" = "QuestionId")) %>% 
  left_join(answer_metadata, by = c("AnswerId" = "AnswerId")) %>%
  left_join(student_metadata, by = c("UserId" = "UserId")) %>%
  # drop incomplete students
  filter(!is.na(DateOfBirth), !is.na(Gender), !is.na(PremiumPupil)) %>%
  group_by(UserId) %>%
  mutate(
    average_confidence = mean(Confidence, na.rm = TRUE), 
    confidence_response_rate = sum(!is.na(Confidence))/n(),
    average_correctness = mean(IsCorrect, na.rm = TRUE),
  ) %>% 
  ungroup() %>%
  filter(!is.na(average_confidence))
#
#
#
#
#
set.seed(18)
data50 = complete_data %>% 
  filter(confidence_response_rate > 0.8) %>% 
  group_by(UserId) %>%
  nest() %>%
  ungroup() %>%
  slice_sample(n = 50) %>% 
  unnest(cols = c(data)) %>% 
  arrange(UserId, QuizId,DateAnswered) %>% 
  group_by(UserId,QuizId) %>% 
  mutate(
    cum_percent_correct = cumsum(IsCorrect)/row_number(),
    cum_percent_confident = cumsum(Confidence)/row_number(),
    problems_so_far = row_number(),
    student_age = (difftime(DateAnswered, DateOfBirth, units = "auto") %>% as.numeric())/364.25
    )

set.seed(352)

data50 = data50 %>%
  group_by(UserId) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(UserId, Gender, student_age, QuizId, QuestionId, SubjectId, IsCorrect, Confidence, average_confidence, average_correctness, cum_percent_correct, cum_percent_confident, problems_so_far) %>%
  mutate(Gender = case_match(Gender, 
  1 ~ "Male",
  2 ~ "Female"
  )) %>%
  rowwise() %>%
  # lets pull random values for the psychological variables
  mutate(
    iq = rnorm(1, 0, 1),
    extraversion = rnorm(1, 0, 1),
    agreeableness = rnorm(1, 0, 1),
    conscientiousness = rnorm(1, 0, 1),
    neuroticism = rnorm(1, 0, 1),
    openness = rnorm(1, 0, 1)
  ) %>%
  ungroup() %>%
  # and for motivatoinal states (0 - 10)
  mutate(
    confidence = sample(0:10, 50, replace = T),
    frustration = sample(0:10, 50, replace = T),
    boredom = sample(0:10, 50, replace = T),
    curiosity = sample(0:10, 50, replace = T),
    engagement = sample(0:10, 50, replace = T)
  )



questions = data50$QuestionId

subjects_to_words = function(text){
  text = gsub("\\[|\\]", "", text)
  text = str_split(text, ",")[[1]]
  text = as.numeric(text)
  text = subject_metadata %>% filter(SubjectId %in% text) %>% pull(Name)
  text = paste(text, collapse = ", ")
  return(text)
}

data50 = data50 %>% 
  rowwise() %>%
  mutate(
    subject_text = map_chr(SubjectId, function(x) subjects_to_words(x))
  ) %>% 
  select(-SubjectId)

#
#
#
#
#
data50 %>% 
  gt() %>%
  fmt_auto() %>%
  fmt_number(vars(iq:openness, average_correctness, cum_percent_correct), decimals = 2)
#
#
#
#
#
#
#
#
#| echo: false
#| results: "asis"
library(glue)
for (i in questions) {
  cat(glue('<img src="data/eedi/images/{i}.jpg" width="320px" height="240px">'))
  if (i %% 10 == 0) { cat('<br>') }  # Start a new row after every 10 images
}

#
#
#
#
#
#
#
#
#
library(glue)

generate_prompt <- function(question_text, subject_text, IsCorrect, Confidence, problems_so_far, 
                            cum_percent_confident, cum_percent_correct, student_age, Gender, iq, extraversion, 
                            agreeableness, conscientiousness, neuroticism, openness, confidence, 
                            frustration, boredom, curiosity, engagement) {
  
  prompt <- glue("
  You are a simulator for an intelligent tutoring system. I will tell you a math question a student is working on, some information about the student and their interaction with the question, and you will generate a conversation between the student and the intelligent tutor. I will tell you some psychological characteristics of the student, but the tutor does not know them explicitly, they are there just so that you can more accurately model the student. (All psychological variables are specified as z-scores, such that 0 is the mean and 1 is one standard deviation above the mean). Make sure that the student is asking for some help.

  This question:
  Question text: {question_text}
  The question is about: {subject_text}
  Did the student get the question right? {ifelse(IsCorrect == 0, 'No', 'Yes')}
  What was the student's confidence for this question? {Confidence} 

  About the student's learning session so far:
  This student has worked on {problems_so_far} problems so far.
  The student's average confidence so far is {cum_percent_confident %>% round(0)}.
  The student has answered {(cum_percent_correct*100) %>% round(0)}% questions correctly so far.

  About the student:
  Student age: {student_age %>% round(0)}
  Student gender: {Gender}
  Student IQ: {iq %>% round(3)}
  Student Extraversion: {extraversion%>% round(3)}
  Student Agreeableness: {agreeableness%>% round(3)}
  Student Conscientiousness: {conscientiousness%>% round(3)}
  Student Neuroticism: {neuroticism%>% round(3)}
  Student Openness: {openness%>% round(3)}

  And this is the student's current motivational state. These are in a scale of 0 - 10
  Confidence: {confidence}
  Frustration: {frustration}
  Boredom: {boredom}
  Curiosity/Interest: {curiosity}\n
  Engagement: {engagement}
  ")
  
  return(prompt)
}



library(purrr)

data50 = data50 %>%
  mutate(question_text = "to be transcribed") %>%
  mutate(prompt = pmap(list(question_text, subject_text, IsCorrect, Confidence, problems_so_far, 
                            cum_percent_confident, cum_percent_correct, student_age, Gender, iq, extraversion, 
                            agreeableness, conscientiousness, neuroticism, openness, confidence, 
                            frustration, boredom, curiosity, engagement), generate_prompt))

data50 %>% 
  mutate(prompt = as.character(prompt))

write_csv(data50, "data/data50.csv")
#
#
#
#
#
data50 %>% 
  select(prompt) %>% 
  head() %>% 
  gt()
#
#
#
