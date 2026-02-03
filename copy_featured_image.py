import shutil
import os

source = r"C:\Users\barboza-salerno.1\.gemini\antigravity\brain\0f78e238-66cd-4191-b7a7-d52fb3e3c5c5\uploaded_media_1770161214437.png"
destination = r"c:\Users\barboza-salerno.1\Documents\lab\content\publication\ipv-symptoms\featured.png"

try:
    shutil.copy2(source, destination)
    print(f"Successfully copied to {destination}")
except Exception as e:
    print(f"Error copying file: {e}")
