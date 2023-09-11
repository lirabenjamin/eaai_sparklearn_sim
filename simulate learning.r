  library(glue)

  # Student vars
  motivation = 0
  knowledge = 100
  motivation_random_walk_noise = 1

  # its vars
  its_measured_knowledge = 100
  item_difficulty = 100
  item_difficulty_variance = 10

  # world vars
  learning_rate = 1
  probability_of_quitting = .1
  probability_of_forgetting = .001
  probability_of_learning = .75
  forgetting_rate = .05
  motivation_d = -.5

  motivation_its = T

  results = tibble(student = numeric(), item = numeric(), correct = numeric(), knowledge = numeric(), motivation = numeric(), quit = numeric(), motivation_its = logical())


  for(motivation_its in c(T,F)){
  for (student in 1:100){
    # Initialize variables for each student
    quit_status = FALSE
    i = 0
    knowledge = 100
    item_difficulty = 100
    motivation = 0


    while(!quit_status){
      # its picks an item
      item_difficulty = rnorm(1,its_measured_knowledge,item_difficulty_variance)

      # calculate the probabilty of getting the item correct based on dif
      relative_difficulty = item_difficulty - knowledge
      probability_of_correct = 1/(1+exp(-relative_difficulty))

      # will the student get the item correct
      correct = rbinom(1,1,probability_of_correct)
      if(correct==1){print(glue("student got item {i} correct"))}
      else(print(glue("student got item {i} incorrect")))

      # if the student gets the item correct, and based on p_learning increase knowledge
      will_learn = rbinom(1,1,probability_of_learning)
      will_learn = ifelse(will_learn==1,T,F)
      if(correct && will_learn){
        knowledge = knowledge + learning_rate*correct
      }

      # student might forget
      forget = rbinom(1,1,probability_of_forgetting)
      if(forget == 1){
        knowledge = knowledge - forgetting_rate*knowledge
      }

      # student might quit
      quit_result = rbinom(1,1,probability_of_quitting)
      if(quit_result == 1){
        quit_status = TRUE
        print("student quit")
      }

      # if motivation drops, student sees a motivation intervention
      if(motivation < 0 && motivation_its){
        print("student sees motivation intervention")
        motivation = motivation + rnorm(1, motivation_d, 1)
      }

      # update motivation
      motivation = motivation + rnorm(1,0,motivation_random_walk_noise)
      # its updates its measured knowledge
      its_measured_knowledge = its_measured_knowledge + correct*will_learn*learning_rate

      i = i + 1

      # save data
      results = results %>% add_row(student = student, item = i, correct = correct, knowledge = knowledge, motivation = motivation, quit = as.numeric(quit_status), motivation_its = motivation_its)
    }
  }
  }
  # plot learning trajectories
  results %>% 
    pivot_longer(cols = c(knowledge, motivation), names_to = "variable", values_to = "value")  %>%
    ggplot(aes(x = item, y = value, color = motivation_its)) +
    geom_line(alpha = .1, aes(group = student)) +
    geom_smooth()+
    facet_wrap(~variable, scales = "free_y") +
    labs(x = "item", y = "knowledge", title = "Learning trajectories")


results %>% filter(student == 2)
