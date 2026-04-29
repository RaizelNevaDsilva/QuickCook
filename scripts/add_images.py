import pandas as pd
import requests
import time
from dotenv import load_dotenv
import os

load_dotenv()
API_KEY = os.getenv("API_KEY")
headers = {
    "Authorization": API_KEY
}

CSV_FILE = "indian_food_with_images.csv"
INPUT_FILE = "indian_food.csv"
RECIPE_COLUMN = "TranslatedRecipeName"

BATCH_SIZE = 250


def get_image_url(recipe_name):
    url = "https://api.pexels.com/v1/search"

    params = {
        "query": f"{recipe_name} indian food",
        "per_page": 1
    }

    for attempt in range(3):
        try:
            response = requests.get(
                url,
                headers=headers,
                params=params,
                timeout=15
            )

            response.raise_for_status()

            data = response.json()
            photos = data.get("photos", [])

            if photos:
                return photos[0]["src"]["medium"]

            return ""

        except requests.exceptions.HTTPError:
            if response.status_code == 429:
                print("⚠ Rate limit hit. Waiting 30 sec...")
                time.sleep(30)
            else:
                time.sleep(5)

        except requests.exceptions.RequestException:
            time.sleep(5)

    return ""


df = pd.read_csv(INPUT_FILE)

try:
    progress_df = pd.read_csv(CSV_FILE)

    if "image_url" in progress_df.columns:
        df["image_url"] = progress_df["image_url"]

    print("Loaded original dataset + existing progress")

except FileNotFoundError:
    print("Loaded original dataset")


if "image_url" not in df.columns:
    df["image_url"] = ""


# AUTOMATIC FULL DATASET LOOP
for batch_start in range(0, len(df), BATCH_SIZE):
    batch_end = min(batch_start + BATCH_SIZE, len(df))

    print(f"\n🚀 Processing batch {batch_start} → {batch_end - 1}")

    for i in range(batch_start, batch_end):
        try:
            if pd.notna(df.loc[i, "image_url"]) and df.loc[i, "image_url"] != "":
                continue

            recipe_name = df.loc[i, RECIPE_COLUMN]

            print(f"[{i+1}/{len(df)}] {recipe_name}")

            image_url = get_image_url(recipe_name)

            df.loc[i, "image_url"] = image_url

            df.to_csv(CSV_FILE, index=False)

            time.sleep(1)

        except Exception as e:
            print(f"Skipping row {i}: {e}")
            continue

print("\n✅ All recipes processed")