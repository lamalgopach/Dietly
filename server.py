from pprint import pformat
import os

import requests
from flask import Flask, render_template, request, flash, redirect, session, jsonify
from flask_debugtoolbar import DebugToolbarExtension

from model import db, User, Allergy, UserAllergy, Plan, UserDiet, Diet, PlanRecipe, Recipe, Ingredient, RecipeIngredient, RecipeAllergy, RecipeDiet, connect_to_db

import random

from sys import argv
from pprint import pprint
import json

app = Flask(__name__)
app.secret_key = "SECRETSECRETSECRET"

EDAMAM_RECIPE_SEARCH_APPLICATION_ID = os.environ.get('EDAMAM_RECIPE_SEARCH_APPLICATION_ID')
EDAMAM_RECIPE_SEARCH_APPLICATION_KEY = os.environ.get('EDAMAM_RECIPE_SEARCH_APPLICATION_KEY')

EDAMAM_URL = "https://api.edamam.com/search"


@app.route("/")
def homepage():
	"""Show homepage"""

	return render_template("homepage.html")

@app.route("/register")
def register():
	"""Show register form"""

	return render_template("register_page.html")

@app.route("/register", methods=["POST"])
def register_form():
	"""Register user if not in the database"""

	fname = request.form.get("fname")
	lname = request.form.get("lname")
	email = request.form.get("email")
	password = request.form.get("password")

	new_user = User(fname=fname, lname=lname, email=email, password=password)
	user = User.query.filter_by(fname=fname, lname=lname, email=email, password=password).first()

	if user is not None:
		flash(f"User {user.fname} {user.lname} already exists in our database!")
		return redirect("/")
	else:
		db.session.add(new_user)

	db.session.commit()
	flash(f"User {new_user.fname} {new_user.lname} succesfully added to the database!")

	session["new_user_id"] = new_user.user_id

	return redirect("/allergy")

@app.route("/allergy")
def show_allergy_form():
	"""Redirect from homepage form. Display checkbox with set of allergies."""

	return render_template("allergies.html")


@app.route("/allergy", methods=["POST"])
def handle_allergy_form():
	"""Handle user's allergies."""

	allergens = []

	gluten = request.form.get("allergen1")
	allergens.append(gluten)

	wheat = request.form.get("allergen2")
	allergens.append(wheat)

	tree_nut = request.form.get("allergen3")
	allergens.append(tree_nut)

	shellfish = request.form.get("allergen4")
	allergens.append(shellfish)

	soy = request.form.get("allergen5")
	allergens.append(soy)

	eggs = request.form.get("allergen6")
	allergens.append(eggs)

	milk = request.form.get("allergen7")
	allergens.append(milk)

	user_id = session["new_user_id"]

	for i, allergen in enumerate(allergens):
  		if allergen:
  			allergy_id = i + 1
  			user_allergy = UserAllergy(user_id=user_id, allergy_id=allergy_id)
  			db.session.add(user_allergy)

	db.session.commit()

	return redirect("/options")
	# make the user page more personal

@app.route("/options")
def show_options_form():
	"""Redirect from the preferences form. Display checkbox with diet options."""

	return render_template("options_diet.html")

@app.route("/options", methods=["POST"])
def handle_options_form():
	"""Handle user's diet options."""
	
	diet_options = []

	alcohol_free = request.form.get("option1")
	diet_options.append(alcohol_free)

	peanut_free = request.form.get("option2")
	diet_options.append(peanut_free)

	sugar_conscious = request.form.get("option3")
	diet_options.append(sugar_conscious)

	tree_nut_free = request.form.get("option4")
	diet_options.append(tree_nut_free)

	vegan = request.form.get("option5")
	diet_options.append(vegan)

	vegetarian = request.form.get("option6")
	diet_options.append(vegetarian)

	high_protein = request.form.get("option7")
	diet_options.append(high_protein)

	low_carb = request.form.get("option8")
	diet_options.append(low_carb)

	low_fat = request.form.get("option9")
	diet_options.append(low_fat)

	balanced = request.form.get("option10")
	diet_options.append(balanced)

	user_id = session["new_user_id"]

	for i, diet_option in enumerate(diet_options):
		if diet_option:
			diet_id = i + 1
			user_diet = UserDiet(user_id=user_id, diet_id=diet_id)
			db.session.add(user_diet)

	db.session.commit()

	return redirect("/login")


@app.route("/login")
def login():
	"""Show login form."""

	if "new_user_id" in session:
		user_id = session["new_user_id"]
		user_name = User.query.filter_by(user_id=user_id).first().fname
		del session["new_user_id"]
	else:
		user_name = "User"
	return render_template("login_page.html", user=user_name)

@app.route("/login", methods=["POST"])
def login_form():
	"""Login user."""

	email=request.form["email"]
	password=request.form["password"]

	user = User.query.filter_by(email=email).first()

	if not user:
		flash("Not such user.")
		return redirect("/register")

	elif user.password != password:
		flash("Incorrect password!")
		return redirect("/login")

	session["user_id"] = user.user_id

	# return redirect(f"/users/{new_user.user_id}")
	flash("{} succesfully logged in.".format(user.fname))
	return redirect("/preferences")
	#in version 2.0 add option to go whenever


@app.route("/preferences")
def user_options():
	"""Show users options"""

	user_id = session["user_id"]
	user = User.query.filter_by(user_id=user_id).first().fname

	plan_lst = display_all_user_plans(user_id)

	return render_template("preferences.html", user=user, plan_lst=plan_lst)


@app.route("/display-mealplan", methods=["POST"])
def calculate_and_display_user_mealplans():
	"""Get calories and macros, calculate in helper functions and return list of user's mealplans."""

	user_id = session["user_id"]

	plan_name = request.form.get("plan_name")
	calories = float(request.form.get("calories"))
	carbohydrates = float(request.form.get("carbohydrates"))
	fat = float(request.form.get("fat"))
	protein = float(request.form.get("protein"))
	cal_or_perc = request.form.get("macro")

	if cal_or_perc == "percentage":
		carbohydrates = float(calories) * float(carbohydrates) / 400
		#divide by 100 because 100% and div by 4 because 1 g carb is 4 calories
		fat = float(calories) * float(fat) / 900
		#1 g fat is 9 kcal
		protein = float(calories) * float(protein) / 400


	new_plan = Plan(plan_name=plan_name, user_id=user_id, calories=calories, carbohydrates=carbohydrates, fat=fat, protein=protein)
	db.session.add(new_plan)
	db.session.commit()

	results = calculate_calories_from_recipes_depend_on_plan(user_id)

	return render_template("calculated_mealplans.html", results=results)


@app.route("/display-all-mealplans")
def display_all_users_mealplans():
	"""Display list of user's mealplans."""

	user_id = session["user_id"]

	plan_lst = display_all_user_plans(user_id)
	
	return render_template("display_multiple_plans.html", plan_lst=plan_lst)


def display_all_user_plans(user_id):
	"""Get all user's plans and display them to the collapse buttons."""

	list_of_users_plans = Plan.query.filter_by(user_id=user_id).all()

	plans_lst = []

	for plan in list_of_users_plans:

		names_and_calories_of_plans = {}

		names_and_calories_of_plans['name'] = plan.plan_name
		names_and_calories_of_plans['plan_id'] = plan.plan_id
		names_and_calories_of_plans['calories'] = plan.calories
		names_and_calories_of_plans['carbohydrates'] = plan.carbohydrates
		names_and_calories_of_plans['fat'] = plan.fat
		names_and_calories_of_plans['protein'] = plan.protein

		plans_lst.append(names_and_calories_of_plans)

	return plans_lst


def calculate_calories_from_recipes_depend_on_plan(user_id):
	"""Get all the recipes from db, get number of calories, check which recipes which could create mealplan."""

	all_recipes_list = Recipe.query.all()

	plan = Plan.query.filter_by(user_id=user_id).order_by(Plan.plan_id.desc()).first()

	user_allergies = find_user_allergies(user_id)

	user_diets = find_user_diets(user_id)

	plan_calories = plan.calories
	plan_carbohydrates = plan.carbohydrates
	plan_fat = plan.fat
	plan_protein = plan.protein


	list_of_recipes = []


	for recipe1 in all_recipes_list:
		
		serv1 = recipe1.servings
		kcal1 = recipe1.calories
		carbs1 = recipe1.carbohydrates
		fat1 = recipe1.fat
		protein1 = recipe1.protein
		
		kcal_per_yield1 = kcal1 / serv1
		carbohydrates_per_yield1 = carbs1 / serv1
		fat_per_yield1 = fat1 / serv1
		protein_per_yield1 = protein1 / serv1


		recipe_cautions = RecipeAllergy.query.filter_by(recipe_id=recipe1.recipe_id).all()

		allergies = []
		for caution in recipe_cautions:
			allergy = Allergy.query.filter_by(allergy_id=caution.allergy_id).first()
			allergies.append(allergy)



		has_allergy = False
		for user_allergy in user_allergies:
			if user_allergy in allergies:
				has_allergy = True

		

		recipe_labels = RecipeDiet.query.filter_by(recipe_id=recipe1.recipe_id).all()

		has_diet_label = True

		labels = []
		for diet in recipe_labels:
			label = Diet.query.filter_by(diet_id=diet.diet_id).first()
			labels.append(label.diet_name)
	

		for user_diet in user_diets:
			if user_diet not in labels:
				has_diet_label = False

		if has_allergy == False and has_diet_label == True:


			for recipe2 in all_recipes_list:

				serv2 = recipe2.servings
				kcal2 = recipe2.calories
				carbs2 = recipe2.carbohydrates
				fat2 = recipe2.fat
				protein2 = recipe2.protein
				
				kcal_per_yield2 = kcal2 / serv2
				carbohydrates_per_yield2 = carbs2 / serv2
				fat_per_yield2 = fat2 / serv2
				protein_per_yield2 = protein2 / serv2


				for recipe3 in all_recipes_list:

					serv3 = recipe3.servings
					kcal3 = recipe3.calories
					carbs3 = recipe3.carbohydrates
					fat3 = recipe3.fat
					protein3 = recipe3.protein


					kcal_per_yield3 = kcal3 / serv3
					carbohydrates_per_yield3 = carbs3 / serv3
					fat_per_yield3 = fat3 / serv3
					protein_per_yield3 = protein3 / serv3



					if kcal_per_yield1 + kcal_per_yield2 + kcal_per_yield3 <= plan_calories + 50 and kcal_per_yield1 + kcal_per_yield2 + kcal_per_yield3 >= plan_calories - 50:

						if carbohydrates_per_yield1 + carbohydrates_per_yield2 + carbohydrates_per_yield3 <= plan_carbohydrates + 20 and carbohydrates_per_yield1 + carbohydrates_per_yield2 + carbohydrates_per_yield3 >= plan_carbohydrates - 20:
							if fat_per_yield1 + fat_per_yield2 + fat_per_yield3 <= plan_fat + 20 and fat_per_yield1 + fat_per_yield2 + fat_per_yield3 >= plan_fat - 20: 
								if protein_per_yield1 + protein_per_yield2 + protein_per_yield3 <= plan_protein + 20 and protein_per_yield1 + protein_per_yield2 + protein_per_yield3 >= plan_protein - 20:
									if recipe1 != recipe2 and recipe2 != recipe3 and recipe3 != recipe1:
										set_recipe = set()
										set_recipe.add(recipe1)
										set_recipe.add(recipe2)
										set_recipe.add(recipe3)


										has_allergy = False
										has_diet_label = True


										recipe_cautions = RecipeAllergy.query.filter_by(recipe_id=recipe2.recipe_id).all()
										recipe_cautions.extend(RecipeAllergy.query.filter_by(recipe_id=recipe3.recipe_id).all())



										allergies = []
										for caution in recipe_cautions:
											allergy = Allergy.query.filter_by(allergy_id=caution.allergy_id).first()
											allergies.append(allergy)

										for user_allergy in user_allergies:
											if user_allergy in allergies:
												has_allergy = True


									

										recipe_labels = RecipeDiet.query.filter_by(recipe_id=recipe2.recipe_id).all()
										recipe_labels.extend(RecipeDiet.query.filter_by(recipe_id=recipe3.recipe_id).all())

										labels = []
										for diet in recipe_labels:
											label = Diet.query.filter_by(diet_id=diet.diet_id).first()
											labels.append(label.diet_name)
									

										for user_diet in user_diets:
											if user_diet not in labels:
												has_diet_label = False


										if has_allergy == False and has_diet_label == True:
											if set_recipe not in list_of_recipes:
												list_of_recipes.append(set_recipe)


	results = []
	for set_of_recipes in list_of_recipes:

		result = []
		for recipe in set_of_recipes:
			recipes = {}

			recipes["name"] = recipe.recipe_name
			recipes["url"] = recipe.recipe_url
			recipes["image"] = recipe.recipe_image
			recipes["directions"] = recipe.directions
			recipes["servings"] = recipe.servings
			recipes["calories"] = recipe.calories
			recipes["carbohydrates"] = recipe.carbohydrates
			recipes["fat"] = recipe.fat
			recipes["protein"] = recipe.protein

			result.append(recipes)

		results.append(result)

	return results


@app.route("/add-mealplan", methods=["POST"])
def get_user_pick_and_add_mealplan_to_db():
	"""Get picked mealplan and add recipes to the databse."""

	user_id = session["user_id"]
	recipes = request.form.get("recipes_list")
	plan = Plan.query.filter_by(user_id=user_id).order_by(Plan.plan_id.desc()).first()

	new_recipes = ""
	for char in recipes:
		if char == "'":
			new_recipes += '"'
		else:
			new_recipes += char

	new_recipes_list = json.loads(new_recipes)

	for recipe in new_recipes_list:

		recipe = Recipe.query.filter_by(recipe_name=recipe["name"]).first()
		new_connection = PlanRecipe(recipe_id=recipe.recipe_id, plan_id=plan.plan_id)	

		db.session.add(new_connection)
  										
	db.session.commit()


	return redirect('/shopping-list')



@app.route("/plans/<int:plan_id>")
def show_info_about_plan(plan_id):
	"""Info from link, show the chosen plan."""

	lst_of_recipes = get_all_recipes_for_plan_id(plan_id)
	nutritions = display_nutrition_facts_for_plan(plan_id)
	plan = Plan.query.filter_by(plan_id=plan_id).first().plan_name
	user_id = session['user_id']
	user = User.query.filter_by(user_id=user_id).first().fname


	return render_template("plan.html", lst_of_recipes=lst_of_recipes, nutritions=nutritions, user=user, plan=plan)


def get_all_recipes_for_plan_id(plan_id):
	"""Get all recipes for user's plan"""

	connection_lst = PlanRecipe.query.filter_by(plan_id=plan_id).all()


	lst_of_recipes = []
	recipe_lst_obj = []
	
	for connection in connection_lst:
		recipe_lst_obj = Recipe.query.filter_by(recipe_id=connection.recipe_id).all()

		for recipe_obj in recipe_lst_obj:
			recipe = {}
			recipe['recipe_name'] = recipe_obj.recipe_name
			recipe['recipe_image'] = recipe_obj.recipe_image
			recipe['directions'] = recipe_obj.directions

			lst_of_recipes.append(recipe)

	return lst_of_recipes


def display_nutrition_facts_for_plan(plan_id):
	"""Get user's and display nutrition facts."""

	nutritions = {}

	calories = 0
	carbohydrates = 0
	fat = 0
	protein = 0

	connection_lst = PlanRecipe.query.filter_by(plan_id=plan_id).all()

	recipe_lst_obj = []


	for connection in connection_lst:
		recipe_obj = Recipe.query.filter_by(recipe_id=connection.recipe_id).first()
		recipe_lst_obj.append(recipe_obj)


	for recipe_obj in recipe_lst_obj:
		
		calories += recipe_obj.calories / recipe_obj.servings
		carbohydrates += recipe_obj.carbohydrates / recipe_obj.servings
		fat += recipe_obj.fat / recipe_obj.servings
		protein += recipe_obj.protein / recipe_obj.servings

		nutritions['calories'] = calories
		nutritions['carbohydrates'] = carbohydrates
		nutritions['fat'] = fat
		nutritions['protein'] = protein

	return(nutritions)


@app.route("/display-breakfast", methods=["POST"])
def user_breakfast_preferences():
	"""Get the preferences from the form, search the options for breakfast."""

	user_id = session["user_id"]

	plan_name = request.form.get("plan_name")
	calories = request.form.get("calories")
	carbohydrates = request.form.get("carbohydrates")
	fat = request.form.get("fat")
	protein = request.form.get("protein")
	# breakfast = request.form.get("breakfast")
	cal_or_perc = request.form.get("macro")


	breakfast = "egg"

	if cal_or_perc == "percentage":
		carbohydrates = float(calories) * float(carbohydrates) / 400
		#divide by 100 because 100% and div by 4 because 1 g carb is 4 calories
		fat = float(calories) * float(fat) / 900
		#1 g fat is 9 kcal
		protein = float(calories) * float(protein) / 400



	new_plan = Plan(plan_name=plan_name, user_id=user_id, calories=calories, carbohydrates=carbohydrates, fat=fat, protein=protein)
	db.session.add(new_plan)
	db.session.commit()

	user_allergies = find_user_allergies(user_id)

	user_diets = find_user_diets(user_id)

	plan = Plan.query.filter_by(user_id=user_id).order_by(Plan.plan_id.desc()).first()
	calories = plan.calories
	carbohydrates = plan.carbohydrates
	fat = plan.fat
	protein = plan.protein

	breakfast_limit_calories = calories * 0.35
	breakfast_limit_carbohydrates = carbohydrates * 0.35 
	breakfast_limit_fat = fat * 0.35
	breakfast_limit_protein = protein * 0.35 

	results = get_recipes_from_api(breakfast, breakfast_limit_calories, breakfast_limit_carbohydrates, breakfast_limit_fat, breakfast_limit_protein, user_allergies, user_diets)
	user_id = session["user_id"]
	user = User.query.filter_by(user_id=user_id).first().fname

	return render_template("display_breakfast.html", results=results, user=user)


@app.route("/add-breakfast", methods=["POST"])
def add_breakfast_to_db():
	"""Add breakfast to the database."""

	user_id = session["user_id"]

	recipe_name = request.form.get("recipe_name")
	recipe_url = request.form.get("recipe_url")
	recipe_image = request.form.get("recipe_image")
	directions = request.form.get("directions")
	servings = request.form.get("servings")
	calories = request.form.get("calories")
	carbohydrates = request.form.get("carbohydrates")
	fat = request.form.get("fat")
	protein = request.form.get("protein")
	ingredients = request.form.get("ingredients")
	cautions = request.form.get("cautions")
	diets = request.form.get("diets")

	add_meal_to_db(user_id, recipe_name, recipe_url, recipe_image, directions, servings, calories, carbohydrates, fat, protein, ingredients, cautions, diets)

	return redirect ("/display-lunch")


@app.route("/display-lunch")
def user_lunch_preferences():
	"""Get the preferences from the form, search the options for lunch."""

	# lunch = request.form.get("lunch")

	user_id = session["user_id"]

	user_allergies = find_user_allergies(user_id)

	user_diets = find_user_diets(user_id)

	plan = Plan.query.filter_by(user_id=user_id).order_by(Plan.plan_id.desc()).first()

	#add a form to select plan
	calories = plan.calories
	carbohydrates = plan.carbohydrates
	fat = plan.fat
	protein = plan.protein

	plan_recipe = PlanRecipe.query.filter_by(plan_id=plan.plan_id).first()
	# remember in the next steps there are many recipes
	breakfast_recipe = Recipe.query.filter_by(recipe_id=plan_recipe.recipe_id).first()
	
	calories_used_in_breakfast = calculate_used_calories(breakfast_recipe, calories)
	carbohydrates_used_in_breakfast = calculate_used_carbohydrates(breakfast_recipe, carbohydrates)
	fat_used_in_breakfast = calculate_used_fat(breakfast_recipe, fat)
	protein_used_in_breakfast = calculate_used_protein(breakfast_recipe, protein)

	lunch_limit_calories = calories * 0.65 - calories_used_in_breakfast
	lunch_limit_carbohydrates = carbohydrates * 0.65 - carbohydrates_used_in_breakfast
	lunch_limit_fat = fat * 0.65 - fat_used_in_breakfast
	lunch_limit_protein = protein * 0.65 - protein_used_in_breakfast

	lunch = "broccoli"
	#add a form to get a word
	results = get_recipes_from_api(lunch, lunch_limit_calories, lunch_limit_carbohydrates, lunch_limit_fat, lunch_limit_protein, user_allergies, user_diets)

	user_id = session["user_id"]
	user = User.query.filter_by(user_id=user_id).first().fname

	return render_template("display_lunch.html", results=results, user=user)

def calculate_used_calories(meal_recipe, calories):
	"""Get the calories from the last meal and add them to the limit."""

	recipe_calories = meal_recipe.calories

	recipe_servings = meal_recipe.servings
	recipe_calories_per_serving = recipe_calories / recipe_servings

	return recipe_calories_per_serving

def calculate_used_carbohydrates(meal_recipe, carbohydrates):
	"""Get the carbohydrates from the last meal and add them to the limit."""

	recipe_carbohydrates = meal_recipe.carbohydrates

	recipe_servings = meal_recipe.servings
	recipe_carbohydrates_per_serving = recipe_carbohydrates / recipe_servings

	return recipe_carbohydrates_per_serving

def calculate_used_fat(meal_recipe, fat):
	"""Get the fat from the last meal and add them to the limit."""

	recipe_fat = meal_recipe.fat

	recipe_servings = meal_recipe.servings
	recipe_fat_per_serving = recipe_fat / recipe_servings

	return recipe_fat_per_serving

def calculate_used_protein(meal_recipe, protein):
	"""Get the protein from the last meal and add them to the limit."""

	recipe_protein = meal_recipe.protein

	recipe_servings = meal_recipe.servings
	recipe_protein_per_serving = recipe_protein / recipe_servings

	return recipe_protein_per_serving


@app.route("/add-lunch", methods=["POST"])
def add_lunch_to_db():
	"""Add lunch to the database."""

	user_id = session["user_id"]

	recipe_name = request.form.get("recipe_name")
	recipe_url = request.form.get("recipe_url")
	recipe_image = request.form.get("recipe_image")
	directions = request.form.get("directions")
	servings = float(request.form.get("servings"))
	calories = float(request.form.get("calories"))
	carbohydrates = float(request.form.get("carbohydrates"))
	fat = float(request.form.get("fat"))
	protein = float(request.form.get("protein"))
	ingredients = request.form.get("ingredients")
	cautions = request.form.get("cautions")
	diets = request.form.get("diets")

	add_meal_to_db(user_id, recipe_name, recipe_url, recipe_image, directions, servings, calories, carbohydrates, fat, protein, ingredients, cautions, diets)

	return redirect ("/display-dinner")


@app.route("/display-dinner")
def user_dinner_preferences():
	"""Get the preferences from the form, search the options for dinner."""

	# dinner = request.form.get("dinner")
	
	user_id = session["user_id"]

	user_allergies = find_user_allergies(user_id)

	user_diets = find_user_diets(user_id)

	plan = Plan.query.filter_by(user_id=user_id).order_by(Plan.plan_id.desc()).first()

	#add a form to select plan
	calories = plan.calories
	carbohydrates = plan.carbohydrates
	fat = plan.fat
	protein = plan.protein


	plan_recipes = PlanRecipe.query.filter_by(plan_id=plan.plan_id).all()

	for plan_recipe in range(len(plan_recipes)):

		if plan_recipe == 0:
			breakfast_recipe = Recipe.query.filter_by(recipe_id=plan_recipes[plan_recipe].recipe_id).first()


		else:
			lunch_recipe = Recipe.query.filter_by(recipe_id=plan_recipes[plan_recipe].recipe_id).first()
	
	
	calories_used_in_breakfast = calculate_used_calories(breakfast_recipe, calories)
	carbohydrates_used_in_breakfast = calculate_used_carbohydrates(breakfast_recipe, carbohydrates)
	fat_used_in_breakfast = calculate_used_fat(breakfast_recipe, fat)
	protein_used_in_breakfast = calculate_used_protein(breakfast_recipe, protein)

	calories_used_in_lunch = calculate_used_calories(lunch_recipe, calories)
	carbohydrates_used_in_lunch = calculate_used_carbohydrates(lunch_recipe, carbohydrates)
	fat_used_in_lunch = calculate_used_fat(lunch_recipe, fat)
	protein_used_in_lunch = calculate_used_protein(lunch_recipe, protein)

	dinner_limit_calories = calories - calories_used_in_breakfast - calories_used_in_lunch
	dinner_limit_carbohydrates = carbohydrates - carbohydrates_used_in_breakfast - carbohydrates_used_in_lunch
	dinner_limit_fat = fat - fat_used_in_breakfast - fat_used_in_lunch
	dinner_limit_protein = protein - protein_used_in_breakfast - protein_used_in_lunch

	dinner = "margherita"
	#add a form to get a word

	results = get_recipes_from_api(dinner, dinner_limit_calories, dinner_limit_carbohydrates, dinner_limit_fat, dinner_limit_protein, user_allergies, user_diets)

	user_id = session["user_id"]
	user = User.query.filter_by(user_id=user_id).first().fname

	return render_template("display_dinner.html", results=results, user=user)

def find_user_allergies(user_id):
	"""Helper function"""

	allergies = UserAllergy.query.filter_by(user_id=user_id).all()
	user_allergies = []
	for allergy in allergies:
		allergy_name = Allergy.query.filter_by(allergy_id=allergy.allergy_id).first()
		user_allergies.append(allergy_name.allergy_name)

	return user_allergies

def find_user_diets(user_id):
	"""Helper function"""

	diets = UserDiet.query.filter_by(user_id=user_id).all()
	user_diets = []
	for diet in diets:
		diet_name = Diet.query.filter_by(diet_id=diet.diet_id).first()
		user_diets.append(diet_name.diet_name)
		#diet_name is an object and diet name is an attribute

	return user_diets

@app.route("/add-dinner", methods=["POST"])
def add_dinner_to_db():
	"""Add dinner to the database."""

	user_id = session["user_id"]

	recipe_name = request.form.get("recipe_name")
	recipe_url = request.form.get("recipe_url")
	recipe_image = request.form.get("recipe_image")
	directions = request.form.get("directions")
	servings = float(request.form.get("servings"))
	calories = float(request.form.get("calories"))
	carbohydrates = float(request.form.get("carbohydrates"))
	fat = float(request.form.get("fat"))
	protein = float(request.form.get("protein"))
	ingredients = request.form.get("ingredients")
	cautions = request.form.get("cautions")
	diets = request.form.get("diets")

	add_meal_to_db(user_id, recipe_name, recipe_url, recipe_image, directions, servings, calories, carbohydrates, fat, protein, ingredients, cautions, diets)

	return redirect("/display-plan")

def get_recipes_from_api(meal, meal_limit_calories, meal_limit_carbohydrates, meal_limit_fat, meal_limit_protein, user_allergies, user_diets):
	"""Helper function"""

	payload = { 'q': meal,
				'app_id': EDAMAM_RECIPE_SEARCH_APPLICATION_ID,
				'app_key': EDAMAM_RECIPE_SEARCH_APPLICATION_KEY }

	response = requests.get(EDAMAM_URL, params=payload)
	data = response.json()

	results = []

	if response.ok:
		for n in range(5):
			recipe = {}

			recipe_serving = data["hits"][n]["recipe"]["yield"]

			recipe_calories = data["hits"][n]["recipe"]["calories"]
			recipe_carbohydrates = data["hits"][n]["recipe"]["totalNutrients"]["CHOCDF"]["quantity"]
			recipe_fat = data["hits"][n]["recipe"]["totalNutrients"]["FAT"]["quantity"]
			recipe_protein = data["hits"][n]["recipe"]["totalNutrients"]["PROCNT"]["quantity"]	

			recipe_cautions = data["hits"][n]["recipe"]["cautions"]
			recipe_labels_1 = data["hits"][n]["recipe"]["dietLabels"]
			recipe_labels = data["hits"][n]["recipe"]["healthLabels"]

			for rec_lab_1 in recipe_labels_1:
				recipe_labels.append(rec_lab_1)

			calories_per_yield = recipe_calories/recipe_serving
			carbohydrates_per_yield = recipe_carbohydrates/recipe_serving
			fat_per_yield = recipe_fat/recipe_serving
			protein_per_yield = recipe_protein/recipe_serving

			# below is ok, dont worry!!!
			if (calories_per_yield > meal_limit_calories) or (carbohydrates_per_yield > meal_limit_carbohydrates) or (fat_per_yield > meal_limit_fat) or (protein_per_yield > meal_limit_protein):
				continue

			has_allergy = False

			for user_allergy in user_allergies:
				if user_allergy in recipe_cautions:
					has_allergy = True

			has_diet_label = True

			for user_diet in user_diets:
				if user_diet not in recipe_labels:
					has_diet_label = False

			if has_allergy == False and has_diet_label == True:
				recipe_name = data["hits"][n]["recipe"]["label"]
				recipe["recipe_name"] = recipe_name

				recipe_url = data["hits"][n]["recipe"]["uri"]
				recipe["recipe_url"] = recipe_url
				
				recipe_image = data["hits"][n]["recipe"]["image"]
				recipe["recipe_image"] = recipe_image

				directions = data["hits"][n]["recipe"]["url"]
				recipe["directions"] = directions

				servings = data["hits"][n]["recipe"]["yield"]
				recipe["servings"] = servings

				calories = data["hits"][n]["recipe"]["calories"]
				recipe["calories"] = calories

				carbohydrates = data["hits"][n]["recipe"]["totalNutrients"]["CHOCDF"]["quantity"]
				recipe["carbohydrates"] = carbohydrates

				fat = data["hits"][n]["recipe"]["totalNutrients"]["FAT"]["quantity"]
				recipe["fat"] = fat

				protein = data["hits"][n]["recipe"]["totalNutrients"]["PROCNT"]["quantity"]
				recipe["protein"] = protein

				ingredients = data["hits"][n]["recipe"]["ingredients"]#this is a list of dictionaries
				recipe["ingredients"] = ingredients

				recipe["cautions"] = recipe_cautions

				recipe["diets"] = recipe_labels

				results.append(recipe)

	return results


def add_meal_to_db(user_id, recipe_name, recipe_url, recipe_image, directions, servings, calories, carbohydrates, fat, protein, ingredients, cautions, diets):
	"""Helper function."""

	old_recipe = Recipe.query.filter_by(recipe_url=recipe_url).first()

	new_cautions = ""
	for char in cautions:
		if char == "'":
			new_cautions += '"'
		else:
			new_cautions += char

	new_cautions_lst = json.loads(new_cautions)

	new_diets = ""
	for char in diets:
		if char == "'":
			new_diets += '"'
		else:
			new_diets += char

	new_diets_lst = json.loads(new_diets)

	if old_recipe is not None:
		new_recipe_obj = old_recipe
	else:
		new_recipe_obj = Recipe(recipe_name=recipe_name, recipe_url=recipe_url, recipe_image=recipe_image, directions=directions, servings=servings, calories=calories, carbohydrates=carbohydrates, fat=fat, protein=protein)
		db.session.add(new_recipe_obj)
		db.session.commit()

		for caution in new_cautions_lst:

			allergy = Allergy.query.filter_by(allergy_name=caution).first()

			new_caution_recipe_obj = RecipeAllergy(recipe_id=new_recipe_obj.recipe_id, allergy_id=allergy.allergy_id)
			db.session.add(new_caution_recipe_obj)

		for diet in new_diets_lst:

			diet = Diet.query.filter_by(diet_name=diet).first()

			new_diet_recipe_obj = RecipeDiet(recipe_id=new_recipe_obj.recipe_id, diet_id=diet.diet_id)
			db.session.add(new_diet_recipe_obj)

	db.session.commit()

	recipe = Recipe.query.filter_by(recipe_name=recipe_name).first()
	plan = Plan.query.filter_by(user_id=user_id).order_by(Plan.plan_id.desc()).first()

	plan_recipe_obj = PlanRecipe(plan_id=plan.plan_id, recipe_id=recipe.recipe_id)
	db.session.add(plan_recipe_obj)
	db.session.commit()

	new_ingredients = ""
	for char in ingredients:
		if char == "'":
			new_ingredients += '"'
		else:
			new_ingredients += char

	new_ingredients_dict = json.loads(new_ingredients)

	for ingredient in new_ingredients_dict:
		ingredient_name = ingredient["text"]
		amount = ingredient["weight"]

		ingredient = Ingredient.query.filter_by(ingredient_name=ingredient_name).first()
		if ingredient is None:
			new_ingredient_obj = Ingredient(ingredient_name=ingredient_name)
			db.session.add(new_ingredient_obj)
			db.session.commit()

			ingredient = Ingredient.query.filter_by(ingredient_name=ingredient_name).first()
			new_recipe_ingredient_obj = RecipeIngredient(recipe_id=recipe.recipe_id, ingredient_id=ingredient.ingredient_id, amount=amount)
			db.session.add(new_recipe_ingredient_obj)
			db.session.commit()


@app.route("/display-plan")
def show_web_with_whole_plan():
	"""Display the whole plan for a day."""
	#display with the react

	user_id = session["user_id"]
	plan = Plan.query.filter_by(user_id=user_id).order_by(Plan.plan_id.desc()).first()
	plan_recipe_lst = PlanRecipe.query.filter_by(plan_id=plan.plan_id).all()

	results = []
	calories_sum = 0
	carbohydrates_sum = 0
	fat_sum = 0
	protein_sum = 0


	for plan_recipe_obj in plan_recipe_lst:
		recipe = {}
		recipe_obj = Recipe.query.filter_by(recipe_id=plan_recipe_obj.recipe_id).first()
		recipe["recipe_name"] = recipe_obj.recipe_name
		recipe["recipe_image"] = recipe_obj.recipe_image
		recipe["directions"] = recipe_obj.directions
		recipe["servings"] = recipe_obj.servings
		recipe["carbohydrates"] = recipe_obj.carbohydrates
		recipe["fat"] = recipe_obj.fat
		recipe["protein"] = recipe_obj.protein
		recipe["calories_per_serving"] = recipe_obj.calories / recipe_obj.servings
		
		calories_sum += recipe["calories_per_serving"]
		carbohydrates_sum += recipe["carbohydrates"] / recipe["servings"]
		fat_sum += recipe["fat"] / recipe["servings"]
		protein_sum += recipe["protein"] / recipe["servings"]

		print(type(recipe["calories_per_serving"]))

		results.append(recipe)

	user = User.query.filter_by(user_id=user_id).first().fname

	return render_template("display_plan.html", results=results, user=user, calories_sum=calories_sum, carbohydrates_sum=carbohydrates_sum, fat_sum=fat_sum, protein_sum=protein_sum)

@app.route("/shopping-list")
def get_shopping_list():
	"""Based on users favorite meals display get the ingredients and sum up if duplicate."""

	user_id = session["user_id"]
	plan = Plan.query.filter_by(user_id=user_id).order_by(Plan.plan_id.desc()).first()
	plan_recipe_lst = PlanRecipe.query.filter_by(plan_id=plan.plan_id).all()

	recipes_ids = []

	for plan_recipe_obj in plan_recipe_lst:
		recipe_obj = Recipe.query.filter_by(recipe_id=plan_recipe_obj.recipe_id).first()
		recipes_ids.append(recipe_obj.recipe_id)

	# ingredient_ids = []
	recipes_ing_lst = []
	recipes_names = []
	for recipe_id in recipes_ids:
		recipe_ing_lst = RecipeIngredient.query.filter_by(recipe_id=recipe_id).all()
		recipe_name = Recipe.query.filter_by(recipe_id=recipe_id).first().recipe_name
		ingredient_lst = []
		recipes_names.append(recipe_name)
		
		for recipe_ing in recipe_ing_lst:
			#recipe_ing - object
			# ingredient_ids.append(recipe_ing.ingredient_id)

			ingredient = Ingredient.query.filter_by(ingredient_id=recipe_ing.ingredient_id).first()

			ingredient_lst.append(ingredient.ingredient_name)
		recipes_ing_lst.append(ingredient_lst)


# down is not so nice list backend but with the amount od the ingredients

	# ingredient_dictionary = {}
	# for ing in ingredient_ids:
	# 	ingredient = Ingredient.query.filter_by(ingredient_id=ing).one()
	# 	recipe_ing_obj = RecipeIngredient.query.filter_by(ingredient_id=ingredient.ingredient_id).first()
		

	
		# if ingredient.ingredient_name not in ingredient_dictionary:
		# 	ingredient_dictionary[ingredient.ingredient_name] = recipe_ing_obj.amount
		# else:
		# 	ingredient_dictionary[ingredient.ingredient_name] += recipe_ing_obj.amount

	return render_template("display_shopping_list.html", results=recipes_ing_lst, recipes_names=recipes_names)

@app.route("/make-a-meal-from-fridge")
def show_ingredients_form():
	"""Display checkbox with ingredients options."""

	return render_template("make_a_meal.html")

@app.route("/make-a-meal-from-fridge", methods = ["POST"])
def make_a_meal_from_fridge():
	"""Get user ingredients and query to API for available recipes."""

	chicken = request.form.get("option1")
	tomato = request.form.get("option2")
	avocado = request.form.get("option3")
	onion = request.form.get("option4")
	milk = request.form.get("option5")
	ginger = request.form.get("option6")
	oregano = request.form.get("option7")
	pepper = request.form.get("option8")
	parsley = request.form.get("option9")
	potato = request.form.get("option10")


	eggs = request.form.get("option11")
	cucumber = request.form.get("option12")
	yoghurt = request.form.get("option13")
	cream = request.form.get("option14")
	ham = request.form.get("option15")
	cheese = request.form.get("option16")
	chickpeas = request.form.get("option17")
	butter = request.form.get("option18")
	garlic = request.form.get("option19")
	breast = request.form.get("option20")


	beef = request.form.get("option21")
	apple = request.form.get("option22")
	lettuce = request.form.get("option23")
	honey = request.form.get("option24")
	ketchup = request.form.get("option25")
	mayo = request.form.get("option26")
	cauliflower = request.form.get("option27")


	mustard = request.form.get("option28")
	cod = request.form.get("option29")
	mushrooms = request.form.get("option30")
	sausage = request.form.get("option31")
	zucchini = request.form.get("option32")
	vinegar = request.form.get("option33")
	peppers = request.form.get("option34")


	ingredients = []

	ingredients.append(chicken)
	ingredients.append(tomato)
	ingredients.append(avocado)
	ingredients.append(milk)
	ingredients.append(ginger)
	ingredients.append(oregano)
	ingredients.append(pepper)
	ingredients.append(parsley)
	ingredients.append(potato)

	ingredients.append(eggs)
	ingredients.append(cucumber)
	ingredients.append(yoghurt)
	ingredients.append(cream)
	ingredients.append(ham)
	ingredients.append(cheese)
	ingredients.append(chickpeas)
	ingredients.append(butter)
	ingredients.append(garlic)
	ingredients.append(breast)

	ingredients.append(beef)
	ingredients.append(apple)
	ingredients.append(lettuce)
	ingredients.append(honey)
	ingredients.append(ketchup)
	ingredients.append(mayo)
	ingredients.append(cauliflower)

	ingredients.append(mustard)
	ingredients.append(cod)
	ingredients.append(mushrooms)
	ingredients.append(sausage)
	ingredients.append(zucchini)
	ingredients.append(vinegar)
	ingredients.append(peppers)




	results = []

	meal = ""
	for ing in ingredients:
		if ing != None:
			meal += ing + ","

	payload = { 'q': meal,
				'app_id': EDAMAM_RECIPE_SEARCH_APPLICATION_ID,
				'app_key': EDAMAM_RECIPE_SEARCH_APPLICATION_KEY }

	response = requests.get(EDAMAM_URL, params=payload)
	data = response.json()

	if response.ok:
		for n in range(5):
			recipe = {}
			recipe_url = data["hits"][n]["recipe"]["url"]
			recipe["recipe_url"] = recipe_url

			recipe_image = data["hits"][n]["recipe"]["image"]
			recipe["recipe_image"] = recipe_image

			recipe_name = data["hits"][n]["recipe"]["label"]
			recipe["recipe_name"] = recipe_name

			results.append(recipe)

	return render_template("make_a_meal_display_recipes.html", results=results)

@app.route("/logout")
def logout():
    """Log out user."""

    del session["user_id"]
    flash("Logged Out.")
    return redirect("/")


if __name__ == "__main__":
	app.debug = True
	app.config['DEBUG_TB_INTERCEPT_REDIRECTS'] = False
	DebugToolbarExtension(app)
	connect_to_db(app)
	app.run(host='0.0.0.0', port=5000)