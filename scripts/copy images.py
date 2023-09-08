import os
import shutil
import pandas as pd

def copy_images_based_on_numbers(r, source_folder, dest_folder):
    """
    Copy images based on their numbers from the source folder to the destination folder.
    
    :param r: List of numbers corresponding to image filenames.
    :param source_folder: Path to the source folder.
    :param dest_folder: Path to the destination folder.
    """
    
    # Ensure destination folder exists, if not create it
    if not os.path.exists(dest_folder):
        os.makedirs(dest_folder)
    
    # Iterate through each number in r
    for number in r:
        # Assuming image filenames are like "1.jpg", "2.jpg" etc.
        # Adjust the filename format if needed
        image_name = f"{number}.jpg"
        
        # Create full path for source and destination
        source_path = os.path.join(source_folder, image_name)
        dest_path = os.path.join(dest_folder, image_name)
        
        # If the image exists in the source folder, copy it to the destination folder
        if os.path.exists(source_path):
            shutil.copy2(source_path, dest_path)

# Example usage
r = pd.read_csv("data/data50.csv").QuestionId.tolist()
source_folder = "data/eedi/images"
dest_folder = "data/50_images"
copy_images_based_on_numbers(r, source_folder, dest_folder)
