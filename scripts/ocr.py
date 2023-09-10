from PIL import Image
import pytesseract

def extract_text_from_image(image_path):
    return pytesseract.image_to_string(Image.open(image_path))

import os

text = []
images = []

for image in os.listdir('data/50_images'):
    text.append(extract_text_from_image('data/50_images/' + image))    
    images.append(image)
    
import pandas as pd
df = pd.DataFrame({'image': images, 'text': text})

df.sort_values(by=['image'], inplace=True)

df.to_csv('data/50_images_ocr.csv', index=False)