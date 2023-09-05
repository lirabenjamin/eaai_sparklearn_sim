import sentence_transformers
from sentence_transformers import SentenceTransformer, util
import numpy as np
import pandas as pd

# Load the model
model = SentenceTransformer('paraphrase-distilroberta-base-v1')

# Read the data
conversation = """
Student (S): I'm working on this question: “What belongs in the spaces? ? 3)”. I initially thought I had the right answer, but I made a mistake in my second attempt. Can you help me figure it out?

Intelligent Tutor (IT): Of course! I see you've had a go at it, which is excellent. Can you share your thought process on how you approached it the first time and what changed in your second attempt?

S: In my first approach, I tried breaking down the equation, but in my second attempt, I second-guessed myself and tried another method which didn't work out.

IT: It's completely normal to second-guess oneself, especially when faced with challenging problems. For this equation, I'd suggest we go step-by-step. Can you try to articulate the problem, just like you did in your first attempt?

S: Okay, it seems like the equation is something like “t plus 2 times something minus 3 equals 4.” So, I'm trying to find that unknown value.

IT: That's right! Let's use that framework to solve the problem. Remember, sometimes the simplest approach can be the correct one.

S: I think I get it now, but I still feel a bit unsure about my answers sometimes. I wish I was more confident in my abilities.

IT: Many students feel that way. It's essential to remember that everyone learns at their own pace, and making mistakes is a part of the learning process. It's more important to understand the concept than to always get the right answer the first time. If you ever feel uncertain about an answer, it's always a good idea to revisit the fundamentals of the topic. Would you like some additional resources or practice problems on writing and simplifying expressions?

S: Yes, that would be helpful. I think more practice might make me feel more confident.

IT: Absolutely! Practice can enhance your understanding and boost your confidence. Remember, every challenge you face in learning is an opportunity for growth. And I'm here to help guide you through any difficulties you encounter. Let'''s keep going!
"""

# Split the conversation into utterances
utterances = conversation.split("\n")
student_utterances = utterances[1::2]

student_utterances = [s.replace("S: ", "").replace("Student (S): ", "") for s in student_utterances]


# Compute embeddings
model.encode(student_utterances)

# target embedding
confidence = "I'm sure I can solve this problem on my own."
frustration = "I've tried solving this problem so many times, but I just can't get the right answer. I don't know what I'm doing wrong!"
boredom = "This topic doesn't interest me at all. I've seen it so many times before, and it just feels repetitive."
curiosity = "I'm intrigued by this concept. Can you recommend any additional resources or examples to explore it further?"
engagement = "I'd love to dive deeper into this topic and understand the underlying principles. Can we discuss it in more detail?"

# embed them
confidence_embedding = model.encode(confidence)
frustration_embedding = model.encode(frustration)
boredom_embedding = model.encode(boredom)
curiosity_embedding = model.encode(curiosity)
engagement_embedding = model.encode(engagement)

# compute similarity between student utterances and target embeddings
confidence_similarity = util.pytorch_cos_sim(model.encode(student_utterances), confidence_embedding)
frustration_similarity = util.pytorch_cos_sim(model.encode(student_utterances), frustration_embedding)
boredom_similarity = util.pytorch_cos_sim(model.encode(student_utterances), boredom_embedding)
curiosity_similarity = util.pytorch_cos_sim(model.encode(student_utterances), curiosity_embedding)
engagement_similarity = util.pytorch_cos_sim(model.encode(student_utterances), engagement_embedding)

print("Confidence similarity scores:")
print(confidence_similarity)
print("Frustration similarity scores:")
print(frustration_similarity)
print("Boredom similarity scores:")
print(boredom_similarity)
print("Curiosity similarity scores:")
print(curiosity_similarity)
print("Engagement similarity scores:")
print(engagement_similarity)

# make a line plot with the similarity scores on y, turn number in x, and each line is a target embedding
import matplotlib.pyplot as plt

plt.plot(confidence_similarity, label="Confidence")
plt.plot(frustration_similarity, label="Frustration")
plt.plot(boredom_similarity, label="Boredom")
plt.plot(curiosity_similarity, label="Curiosity")
plt.plot(engagement_similarity, label="Engagement")
plt.xlabel("Turn number")
plt.ylabel("Similarity score")
plt.legend()
plt.show()
