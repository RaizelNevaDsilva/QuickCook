import csv
import json
import os
import re

INPUT_CSV = "indian_food_with_images.csv"
OUTPUT_JSON = "assets/data/recipes.json"


def parse_ingredients(raw: str):
    """
    Convert comma-separated ingredient string into list
    """
    if not raw:
        return []
    return [item.strip() for item in raw.split(",") if item.strip()]


def detect_no_cook(instructions: str):
    """
    Detect whether recipe requires actual cooking
    """
    instructions = instructions.lower()

    cook_keywords = [
        "cook", "boil", "fry", "heat", "saute",
        "steam", "bake", "roast", "pressure cook",
        "grill", "temper", "simmer", "microwave",
        "stir fry", "deep fry"
    ]

    return not any(word in instructions for word in cook_keywords)


def split_time(total_time: int, no_cook: bool):
    """
    Split total time into prep and cook time
    """
    if total_time <= 0:
        return 5, 0   # fallback default

    if no_cook:
        prep_time = total_time
        cook_time = 0
    else:
        prep_time = max(2, int(total_time * 0.3))
        cook_time = total_time - prep_time

    return prep_time, cook_time


def detect_diet(name: str, ingredients: list):
    """
    Detect vegetarian / non-vegetarian using exact word matching.
    Handles egg / eggs and avoids eggplant issue.
    """
    non_veg_keywords = {
        "chicken",
        "mutton",
        "fish",
        "egg",
        "eggs",
        "prawn",
        "prawns",
        "shrimp",
        "crab",
        "meat",
        "lamb",
        "beef",
        "pork"
    }

    text = (name + " " + " ".join(ingredients)).lower()

    words = re.split(r'[\s,()\-]+', text)
    words = [word for word in words if word]

    if any(word in non_veg_keywords for word in words):
        return "non vegetarian"

    return "vegetarian"


def build_recipe(row, index):
    name = row.get("TranslatedRecipeName", "").strip()
    instructions = row.get("TranslatedInstructions", "").strip()
    ingredients_raw = row.get("TranslatedIngredients", "")
    cuisine = row.get("Cuisine", "").strip()
    image_url = row.get("image_url", "").strip()

    try:
        total_time = int(row.get("TotalTimeInMins", 0) or 0)
    except:
        total_time = 0

    ingredients = parse_ingredients(ingredients_raw)

    no_cook = detect_no_cook(instructions)

    prep_time, cook_time = split_time(total_time, no_cook)

    diet = detect_diet(name, ingredients)

    return {
        "id": index,
        "name": name,
        "searchableName": name.lower(),
        "ingredients": ingredients,
        "diet": diet,
        "prepTime": prep_time,
        "cookTime": cook_time,
        "totalTime": prep_time + cook_time,
        "noCook": no_cook,
        "flavorProfile": "",
        "course": cuisine,
        "state": "",
        "region": "",
        "instructions": instructions,
        "imageUrl": image_url
    }


def main():
    if not os.path.exists(INPUT_CSV):
        print(f"ERROR: {INPUT_CSV} not found.")
        return

    recipes = []

    with open(INPUT_CSV, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)

        for i, row in enumerate(reader):
            recipe = build_recipe(row, i)

            if recipe["name"]:
                recipes.append(recipe)

    os.makedirs(os.path.dirname(OUTPUT_JSON), exist_ok=True)

    with open(OUTPUT_JSON, "w", encoding="utf-8") as f:
        json.dump(recipes, f, ensure_ascii=False, indent=2)

    no_cook_count = sum(1 for r in recipes if r["noCook"])
    veg_count = sum(1 for r in recipes if r["diet"] == "vegetarian")
    non_veg_count = sum(1 for r in recipes if r["diet"] == "non vegetarian")

    print(f"✅ Converted {len(recipes)} recipes → {OUTPUT_JSON}")
    print(f"🥗 No-cook recipes: {no_cook_count}")
    print(f"🥬 Vegetarian recipes: {veg_count}")
    print(f"🍗 Non-vegetarian recipes: {non_veg_count}")


if __name__ == "__main__":
    main()