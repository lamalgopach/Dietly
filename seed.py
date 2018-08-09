from sqlalchemy import func
import json 
# do I need json?
import requests
import os

from server import app

EDAMAM_RECIPE_SEARCH_APPLICATION_ID = os.environ.get('EDAMAM_RECIPE_SEARCH_APPLICATION_ID')
EDAMAM_RECIPE_SEARCH_APPLICATION_KEY = os.environ.get('EDAMAM_RECIPE_SEARCH_APPLICATION_KEY')

EDAMAM_URL = "https://api.edamam.com/search"


# diet label:
# diet_label = data["hits"][1]["recipe"]["dietLabels"][0] index - if we want to get rid of the brackets

# health:
# health_labels = data["hits"][1]["recipe"]["healthLabels"] list of health labels

# ingredient:

# amount of ingredient



def get_recipes_attributes(name):
	"""Get the recipes' attributes."""


	payload = { 'q': name,
				'app_id': EDAMAM_RECIPE_SEARCH_APPLICATION_ID,
				'app_key': EDAMAM_RECIPE_SEARCH_APPLICATION_KEY }
	
	response = requests.get(EDAMAM_URL, params=payload)
	data = response.json()
	# import pdb; pdb.set_trace()

	set_of_recipes = []

	if response.ok:
		for n in range(2):
			recipe = data["hits"][n]["recipe"]["label"]
			set_of_recipes.append(recipe)

			recipe_url = data["hits"][n]["recipe"]["url"]
			set_of_recipes.append(recipe_url)

			recipe_image = data["hits"][n]["recipe"]["image"]
			set_of_recipes.append(recipe_image)

			directions = data["hits"][n]["recipe"]["url"]
			set_of_recipes.append(directions)

			servings = data["hits"][n]["recipe"]["yield"]
			set_of_recipes.append(servings)


			calories = calories = data["hits"][1]["recipe"]["calories"]
			set_of_recipes.append(calories)
			
			carbs = data["hits"][n]["recipe"]["totalNutrients"]["CHOCDF"]["quantity"]
			set_of_recipes.append(carbs)
			
			fat = data["hits"][n]["recipe"]["totalNutrients"]["FAT"]["quantity"]
			set_of_recipes.append(fat)
			
			protein = data["hits"][n]["recipe"]["totalNutrients"]["PROCNT"]["quantity"]			
			set_of_recipes.append(protein)

# 
			#add another data

	print(set_of_recipes)

	return set_of_recipes

	#think about how to remove duplicates
	#maybe if statement in loop

def print_recipe_to_textfile(set_of_recipes):
	"""Print the recipe's attributes to the text file"""
	set_of_recipes = str(set_of_recipes)

	f = open("./seed_data/database.txt", "a")
	f.write(set_of_recipes)
	f.write("\n")
	f.write("\n")
	f.close() #not sure about closing


set_of_recipes = get_recipes_attributes('lunch')
print_recipe_to_textfile(set_of_recipes)

set_of_recipes = get_recipes_attributes('breakfast')
print_recipe_to_textfile(set_of_recipes)

