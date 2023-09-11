from numpy.random import normal
from numpy.random import random
from math import exp


def pick_item(student_knowledge, motivation, is_motivation_its):
    if(is_motivation_its):
        return normal(student_knowledge + motivation, 1)
    else:
        return normal(student_knowledge, 1)


def student_attempt(student_knowledge, motivation, item_difficulty):
    relative_difficulty = item_difficulty - student_knowledge
    # add a boost or drop depending on the motivation of the student
    relative_difficulty += motivation

    # Probability of success depends on relative difficulty
    probability_of_success = 1 / (1 + exp(-relative_difficulty))

    # Did the student succeed?
    if(random() < probability_of_success):
        is_correct = True
    else:
        is_correct = False
    return is_correct

# updates when student sees feedback


def update_knowledge(student_knowledge, item_difficulty, is_correct):
    if(is_correct):
        return student_knowledge + (item_difficulty - student_knowledge) / 10
    else:
        return student_knowledge


def update_motivation(student_knowledge, item_difficulty, motivation, is_correct):
    relative_difficulty = item_difficulty - student_knowledge
    # if you get something difficult right, you get more motivated, getting something right is never demotivating
    # if you get something easy wrong, you get more demotivated, getting something wrong is never motivating
    if(is_correct):
        return motivation + max(0, relative_difficulty / 10)
    else:
        return motivation - min(0, relative_difficulty / 10)


def update_quit_probability(quit_probability, motivation, iteration):
    # quit probability increases through time
    quit_probability = min(.99, quit_probability + iteration*0.005)

    # if you are motivated, you are less likely to quit
    quit_probability = max(0.01,quit_probability - motivation / 10)
    quit_probability = min(.99, quit_probability)
    return quit_probability

update_quit_probability(0, 0, 0)

def its_deliver_intervention(motivation, effectiveness, effectiveness_sd, is_motivation_its):
    # if your motivation drops below 0, you get an intervention
    if(is_motivation_its):
        if(motivation < 0):
            return motivation + normal(effectiveness, effectiveness_sd)
        else:
            return motivation
    else:
        return motivation


def simulate_learning(student_knowledge, motivation, item_difficulty, is_motivation_its, effectiveness, effectiveness_sd, quit_probability):
    iteration = 1
    skills = []
    motivations = []
    while random() > quit_probability:
        item_difficulty = pick_item(
            student_knowledge, motivation, is_motivation_its)
        is_correct = student_attempt(
            student_knowledge, motivation, item_difficulty)
        student_knowledge = update_knowledge(
            student_knowledge, item_difficulty, is_correct)
        motivation = update_motivation(
            student_knowledge, item_difficulty, motivation, is_correct)
        quit_probability = update_quit_probability(
            quit_probability, motivation, iteration)
        motivation = its_deliver_intervention(
            motivation, effectiveness, effectiveness_sd, is_motivation_its)
        skills.append(student_knowledge)
        motivations.append(motivation)
        iteration += 1
    return skills, motivations


skills, motivations = simulate_learning(0, 0, 0, True, .1, .1, 0)

print(skills)
print(motivations)

import matplotlib.pyplot as plt
plt.plot(skills)
plt.plot(motivations)
plt.show()