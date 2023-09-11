import tkinter as tk
from tkinter import messagebox
import pandas as pd

# Load the dataset
data = pd.read_parquet("data/simulated_conversations5.parquet")
data["Confidence"] = ""
data["Frustration"] = ""
data["Boredom"] = ""
data["Curiosity/Interest"] = ""
data["Engagement"] = ""

# rename content to conversation
data = data.rename(columns={"content": "conversation"})

index = 0

def save_and_next():
    global index
    for state in ["Confidence", "Frustration", "Boredom", "Curiosity/Interest", "Engagement"]:
        data.at[index, state] = states[state].get()
    index += 1
    if index < len(data):
        update_conversation()
    else:
        data.to_csv("output_ratings.csv", index=False)
        messagebox.showinfo("Info", "All conversations have been rated!")
        root.quit()

def update_conversation():
    conversation_label["text"] = data.iloc[index]["conversation"]  # Assuming the column with conversations is named "conversation"
    for state in states:
        states[state].set("No")

# Create the main window
root = tk.Tk()
root.title("Rate Conversations")

# Label to show the conversation
conversation_label = tk.Label(root, text=data.iloc[index]["conversation"], wraplength=700, padx=10, pady=10)
conversation_label.pack(pady=20)

# Buttons for motivational states
states = {"Confidence": tk.StringVar(), "Frustration": tk.StringVar(), "Boredom": tk.StringVar(), "Curiosity/Interest": tk.StringVar(), "Engagement": tk.StringVar()}
for state, var in states.items():
    b = tk.Checkbutton(root, text=state, variable=var, onvalue="Yes", offvalue="No")
    b.pack(anchor="w", padx=20)
    var.set("No")

# Button to save the rating and move to the next conversation
next_button = tk.Button(root, text="Next", command=save_and_next)
next_button.pack(pady=20)

root.mainloop()
