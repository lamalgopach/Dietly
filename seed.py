from sqlalchemy import func
import json 

import requests
import os

from model import Allergy, Diet, Recipe, RecipeIngredient, Ingredient, RecipeDiet, RecipeAllergy, connect_to_db, db
from server import app

import time


EDAMAM_RECIPE_SEARCH_APPLICATION_ID = os.environ.get('EDAMAM_RECIPE_SEARCH_APPLICATION_ID')
EDAMAM_RECIPE_SEARCH_APPLICATION_KEY = os.environ.get('EDAMAM_RECIPE_SEARCH_APPLICATION_KEY')

EDAMAM_URL = "https://api.edamam.com/search"


def get_recipe_attributes_db(name):
	"""Get the recipes' attributes."""


	payload = { 'q': name,
				'app_id': EDAMAM_RECIPE_SEARCH_APPLICATION_ID,
				'app_key': EDAMAM_RECIPE_SEARCH_APPLICATION_KEY }
	
	response = requests.get(EDAMAM_URL, params=payload)
	data = response.json()


	if response.ok:
		for n in range(5):
			recipe_obj = Recipe(recipe_name=data["hits"][n]["recipe"]["label"],
								recipe_url=data["hits"][n]["recipe"]["uri"],
								recipe_image=data["hits"][n]["recipe"]["image"],
								directions=data["hits"][n]["recipe"]["url"],
								servings=data["hits"][n]["recipe"]["yield"],
								calories=data["hits"][n]["recipe"]["calories"],
								carbohydrates=data["hits"][n]["recipe"]["totalNutrients"]["CHOCDF"]["quantity"],
								fat=data["hits"][n]["recipe"]["totalNutrients"]["FAT"]["quantity"],
								protein=data["hits"][n]["recipe"]["totalNutrients"]["PROCNT"]["quantity"])
			db.session.add(recipe_obj)
			db.session.commit()


			recipe_labels_1 = data["hits"][n]["recipe"]["dietLabels"]
			recipe_labels = data["hits"][n]["recipe"]["healthLabels"]

			for rec_lab_1 in recipe_labels_1:
				recipe_labels.append(rec_lab_1)

			diet_id_lst = []
			for recipe_label in recipe_labels:
				label = Diet.query.filter_by(diet_name=recipe_label).first()
				diet_id = label.diet_id
				diet_id_lst.append(diet_id)



			for diet_id in diet_id_lst:
				diet_connection = RecipeDiet(recipe_id=recipe_obj.recipe_id, diet_id=diet_id)
				db.session.add(diet_connection)

			recipe_cautions = data["hits"][n]["recipe"]["cautions"]

			cautions_id_lst = []

			for caution in recipe_cautions:

				caution_obj = Allergy.query.filter_by(allergy_name=caution).first()

				caution_id = caution_obj.allergy_id
				cautions_id_lst.append(caution_id)




			for caution_id in cautions_id_lst:
				caution_connection = RecipeAllergy(recipe_id=recipe_obj.recipe_id, allergy_id=caution_id)
				db.session.add(caution_connection)




			ingredients = data["hits"][n]["recipe"]["ingredientLines"]
			
			for i, ingredient in enumerate(ingredients):
				ingredient_obj = Ingredient(ingredient_name=ingredient)
				db.session.add(ingredient_obj)
				db.session.commit()
				recipe_ingredient_obj = RecipeIngredient(ingredient_id=ingredient_obj.ingredient_id, 
														recipe_id=recipe_obj.recipe_id, 
														amount=data["hits"][n]["recipe"]["ingredients"][i]["weight"])
				db.session.add(recipe_ingredient_obj)	
			print (recipe_cautions)

		db.session.commit()



def load_allergens(allergy_filename):
    """Load allergens from allergies.txt into database."""

    for i, row in enumerate(open(allergy_filename)):
        row = row.rstrip()
        allergy_id, allergy_name = row.split(": ")

        allergen = Allergy(allergy_id=allergy_id,
                    allergy_name=allergy_name)

        db.session.add(allergen)

    db.session.commit()

def load_diets(diet_filename):
    """Load diets from diets.txt into database."""

    for i, row in enumerate(open(diet_filename)):
        row = row.rstrip()
        diet_id, diet_name = row.split(": ")

        diet = Diet(diet_id=diet_id,
                    diet_name=diet_name)

        db.session.add(diet)

    db.session.commit()



# def get_recipe_attributes(name):
# 	"""Get the recipes' attributes."""


# 	payload = { 'q': name,
# 				'app_id': EDAMAM_RECIPE_SEARCH_APPLICATION_ID,
# 				'app_key': EDAMAM_RECIPE_SEARCH_APPLICATION_KEY }
	
# 	response = requests.get(EDAMAM_URL, params=payload)
# 	data = response.json()
# 	# import pdb; pdb.set_trace()

# 	set_of_recipes = []

	

# 	if response.ok:
# 		for n in range(3):	
# 			recipe = data["hits"][n]["recipe"]["label"]
# 			set_of_recipes.append(recipe)

# 			recipe_url = data["hits"][n]["recipe"]["url"]
# 			set_of_recipes.append(recipe_url)

# 			recipe_image = data["hits"][n]["recipe"]["image"]
# 			set_of_recipes.append(recipe_image)

# 			directions = data["hits"][n]["recipe"]["url"]
# 			set_of_recipes.append(directions)

# 			servings = data["hits"][n]["recipe"]["yield"]
# 			set_of_recipes.append(servings)

# 			calories = (data["hits"][n]["recipe"]["calories"])
# 			set_of_recipes.append(calories)
			
# 			carbs = data["hits"][n]["recipe"]["totalNutrients"]["CHOCDF"]["quantity"]
# 			set_of_recipes.append(carbs)
			
# 			fat = data["hits"][n]["recipe"]["totalNutrients"]["FAT"]["quantity"]
# 			set_of_recipes.append(fat)
			
# 			protein = data["hits"][n]["recipe"]["totalNutrients"]["PROCNT"]["quantity"]			
# 			set_of_recipes.append(protein)

# 			ingredients_dict = {}
# 			ingredients = data["hits"][n]["recipe"]["ingredientLines"]
# 			set_of_recipes.append(ingredients_dict)
			
# 			for i, ing in enumerate(ingredients):
# 				ingredients_dict[ing] = data["hits"][n]["recipe"]["ingredients"][i]["weight"]


# 	return set_of_recipes


# def print_recipe_to_textfile(set_of_recipes):
# 	"""Print the recipe's attributes to the text file"""
	
# 	set_of_recipes = str(set_of_recipes)

# 	f = open("./seed_data/database.txt", "a")
# 	f.write(set_of_recipes)
# 	f.write("\n")
# 	f.write("\n")
# 	f.close()

###########################################to do::::

# def load_recipes_to_db(database):
# 	"""Load recipes from file to the db"""

# 	for i, row in enumerate(open(database)):
# 		# row = row.strip("'")
# 		recipes, ingredients = row.split("{")
# 		#error ValueError: not enough values to unpack (expected 2, got 1)
# 		print(recipes)
# 		print()
# 		print(ingredients)
# 		print()


# 		for recipe in recipes:
# 			recipe_name, recipe_url, recipe_image, directions, servings, calories, carbohydrates, fat, protein = recipe.split(",")
# 			print(recipe_name)


    # for row in database:
    #     row = row.strip("'")
    #     recipe_name, recipe_url, recipe_image, directions, servings, calories, carbohydrates, fat, protein = row.split(", ")

    #     print(recipe_name)


    #     recipe = Recipe(recipe_name=recipe_name, 
    #     				recipe_url=recipe_url,
    #     				recipe_image=recipe_image,
    #     				directions=directions,
    #     				servings=servings,
    #     				calories=calories,
    #     				carbohydrates=carbohydrates,
    #     				fat=fat,
    #     				protein=protein)

    #     db.session.add(recipe)

    # db.session.commit()


 #add this function to the main


def load_ingredients_to_db():

	pass

def load_ing_rec_db():

	pass


if __name__ == "__main__":
    connect_to_db(app)
    db.create_all()

    # print_recipe_to_textfile(set_of_recipes)

    # database = "seed_data/database.txt"
    # load_recipes_to_db(database)

    # remove_apple()

    # name = "breakfast"
    # name = "lunch"
    # name = "dinner"


    

    # names = ["breakfast", "lunch", "dinner"]


    allergy_filename = "seed_data/allergens.txt"
    diet_filename = "seed_data/diets.txt"
    load_allergens(allergy_filename)
    load_diets(diet_filename)

    meal_list = ["fish", "zucchini", "crepes", "dinner", "broccoli", "pancakes", "pork", "kebab", "taco", "tacos", "steak", "schnitzel", "gulash", "hungarian", "dumplings", "pasta"]
 
    

# "breakfast", "pancake", "eggs", "chicken", "beef", "avocado", "banana", "muesli", "lunch", "poke", "garlic", "pizza", - ok


# bad names: pork, protein, oatmeal "scrambled", "chinese", "apple", "smoothie", "omelette", "bruschetta", "sausage(s)", "soup", "panini",
# "ramen",   "spaghetti", "salad", "hamburger", "pierogies",  "mozarella", 

    for i in meal_list:

    	get_recipe_attributes_db(i)
    	time.sleep(90.0)





    









    ########################tested OR NOT but not to use:



###########<<<<<<<<<<<<<<<<<<<<<<<<<<<<<look down: if you want to use doc! :)








# set_of_recipes = get_recipe_attributes('lunch')
# print_recipe_to_textfile(set_of_recipes)

# set_of_recipes = get_recipe_attributes('dinner')
# print_recipe_to_textfile(set_of_recipes)


############################################### up is working! ###################################



# def get_recipe_labels(name):
# 	"""Get the recipes' labels."""

# 	payload = { 'q': name,
# 				'app_id': EDAMAM_RECIPE_SEARCH_APPLICATION_ID,
# 				'app_key': EDAMAM_RECIPE_SEARCH_APPLICATION_KEY }
	
# 	response = requests.get(EDAMAM_URL, params=payload)
# 	data = response.json()

# 	set_of_labels = []

# 	if response.ok:
# 		for n in range(2):
# 			recipe = data["hits"][n]["recipe"]["label"]
# 			set_of_labels.append(recipe)

# 			recipe_url = data["hits"][n]["recipe"]["dietLabels"]
# 			set_of_labels.append(recipe_url)

# 			recipe_image = data["hits"][n]["recipe"]["healthLabels"]
# 			set_of_labels.append(recipe_image)

# 	print(set_of_labels)

# 	return set_of_labels


# def print_labels_to_textfile(set_of_labels):
# 	"""Print the labels to the text file"""
	
# 	set_of_labels = str(set_of_labels)

# 	f = open("./seed_data/labels.txt", "a")
# 	f.write(set_of_labels)
# 	f.write("\n")
# 	f.write("\n")
# 	f.close()


# set_of_labels = get_recipe_labels('breakfast')
# print_labels_to_textfile(set_of_labels)

# set_of_labels = get_recipe_labels('lunch')
# print_labels_to_textfile(set_of_labels)

# set_of_labels = get_recipe_labels('dinner')
# print_labels_to_textfile(set_of_labels)



################# up is tested ######################################


# def get_recipe_cautions(name):
# 	"""Get the recipes' cautions."""

# 	payload = { 'q': name,
# 				'app_id': EDAMAM_RECIPE_SEARCH_APPLICATION_ID,
# 				'app_key': EDAMAM_RECIPE_SEARCH_APPLICATION_KEY }
	
# 	response = requests.get(EDAMAM_URL, params=payload)
# 	data = response.json()

# 	set_of_cautions = []

# 	if response.ok:
# 		for n in range(2):
# 			recipe = data["hits"][n]["recipe"]["label"]
# 			set_of_cautions.append(recipe)

# 			recipe = data["hits"][n]["recipe"]["cautions"]
# 			set_of_cautions.append(recipe)

# 	print(set_of_cautions)

# 	return set_of_cautions

# def print_cautions_to_textfile(set_of_lcautions):
# 	"""Print the cautions to the text file"""
	
# 	set_of_cautions = str(set_of_cautions)

# 	f = open("./seed_data/cautions.txt", "a")
# 	f.write(set_of_cautions)
# 	f.write("\n")
# 	f.write("\n")
# 	f.close() #not sure about closing



# set_of_recipes = get_recipe_attributes('breakfast')
# print_recipe_to_textfile(set_of_recipes)

# set_of_recipes = get_recipe_attributes('lunch')
# print_recipe_to_textfile(set_of_recipes)

# set_of_recipes = get_recipe_attributes('dinner')
# print_recipe_to_textfile(set_of_recipes)