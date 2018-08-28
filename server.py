from pprint import pformat
import os

import requests
from flask import Flask, render_template, request, flash, redirect, session, jsonify
from flask_debugtoolbar import DebugToolbarExtension

from model import db, User, Allergy, UserAllergy, Plan, UserDiet, Diet, PlanRecipe, Recipe, Ingredient, RecipeIngredient, connect_to_db

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

	#if logged in - flash message: Succesfully logged in
	#show options in form(nav menu):
		# go to preferences 
		# go to make a meal from your fridge

	#if NOT logged in - flash message: You are not logged in
	# if "user_id" in session:
	# 	print(session)
		# show logout button


	return render_template("homepage.html")

@app.route("/register")
def register():
	"""Show register form"""

	return render_template("register_page.html")

@app.route("/register", methods=["POST"])
def register_form():
	"""Register user if not in the database"""

	fname=request.form.get("fname")
	lname=request.form.get("lname")
	email=request.form.get("email")
	password=request.form.get("password")

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

	# vegan = request.form.get("option5")
	# diet_options.append(vegan)

	# vegetarian = request.form.get("option6")
	# diet_options.append(vegetarian)

	# high_protein = request.form.get("option7")
	# diet_options.append(high_protein)

	# low_carb = request.form.get("option8")
	# diet_options.append(low_carb)

	# low_fat = request.form.get("option9")
	# diet_options.append(low_fat)

	# balanced = request.form.get("option10")
	# diet_options.append(balanced)

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

	return render_template("preferences.html", user=user)


@app.route("/display-breakfast", methods=["POST"])
def user_breakfast_preferences():
	"""Get the preferences from the form, search the options for breakfast."""

	user_id = session["user_id"]

	plan_name = request.form.get("plan_name")
	calories = request.form.get("calories")
	carbohydrates = request.form.get("carbohydrates")
	fat = request.form.get("fat")
	protein = request.form.get("protein")
	breakfast = request.form.get("breakfast")

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

	# breakfast = "breakfast"

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

	add_meal_to_db(user_id, recipe_name, recipe_url, recipe_image, directions, servings, calories, carbohydrates, fat, protein, ingredients)

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


	lunch_limit_carbohydrates = carbohydrates * 0.3 
	lunch_limit_fat = fat * 0.3
	lunch_limit_protein = protein * 0.3 

	#get unused calories and macros

	plan_recipe = PlanRecipe.query.filter_by(plan_id=plan.plan_id).first()
	# remember in the next steps there are many recipes
	breakfast_recipe = Recipe.query.filter_by(recipe_id=plan_recipe.recipe_id).first()
	
	lunch_limit_calories = get_unused_calories(breakfast_recipe, calories, 0.35)

	lunch = "chicken"
	#add a form to get a word
	results = get_recipes_from_api(lunch, lunch_limit_calories, lunch_limit_carbohydrates, lunch_limit_fat, lunch_limit_protein, user_allergies, user_diets)

	user_id = session["user_id"]
	user = User.query.filter_by(user_id=user_id).first().fname

	return render_template("display_lunch.html", results=results, user=user)

def get_unused_calories(meal_recipe, calories, a):
	"""Get the calories and macros from the last meal and add them to the limit."""



	recipe_calories = meal_recipe.calories
	recipe_servings = meal_recipe.servings
	recipe_calories_per_servings = recipe_calories / recipe_servings
	calories_left_from_meal = calories * a - recipe_calories_per_servings
	next_meal_limit_calories = calories * a + calories_left_from_meal

	return next_meal_limit_calories


@app.route("/add-lunch", methods=["POST"])
def add_lunch_to_db():
	"""Add lunch to the database."""

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

	add_meal_to_db(user_id, recipe_name, recipe_url, recipe_image, directions, servings, calories, carbohydrates, fat, protein, ingredients)

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

	dinner_limit_calories = calories * 0.35
	dinner_limit_carbohydrates = carbohydrates * 0.35
	dinner_limit_fat = fat * 0.35
	dinner_limit_protein = protein * 0.35

	dinner = "pizza"
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
	servings = request.form.get("servings")
	calories = request.form.get("calories")
	carbohydrates = request.form.get("carbohydrates")
	fat = request.form.get("fat")
	protein = request.form.get("protein")
	ingredients = request.form.get("ingredients")

	add_meal_to_db(user_id, recipe_name, recipe_url, recipe_image, directions, servings, calories, carbohydrates, fat, protein, ingredients)

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

			has_diet_label = False
			count = 0
			for user_diet in user_diets:
				if user_diet in recipe_labels:
					count += 1
			if count == len(user_diets):
				has_diet_label = True

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

				results.append(recipe)

	return results

def add_meal_to_db(user_id, recipe_name, recipe_url, recipe_image, directions, servings, calories, carbohydrates, fat, protein, ingredients):
	"""Helper function."""

	old_recipe = Recipe.query.filter_by(recipe_url=recipe_url).first()

	if old_recipe is not None:
		new_recipe_obj = old_recipe
	else:
		new_recipe_obj = Recipe(recipe_name=recipe_name, recipe_url=recipe_url, recipe_image=recipe_image, directions=directions, servings=servings, calories=calories, carbohydrates=carbohydrates, fat=fat, protein=protein)
		db.session.add(new_recipe_obj)
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

	for plan_recipe_obj in plan_recipe_lst:
		recipe = {}
		recipe_obj = Recipe.query.filter_by(recipe_id=plan_recipe_obj.recipe_id).first()
		recipe["recipe_name"] = recipe_obj.recipe_name
		recipe["recipe_image"] = recipe_obj.recipe_image
		recipe["directions"] = recipe_obj.directions
		recipe["servings"] = recipe_obj.servings
		recipe["calories_per_serving"] = recipe_obj.calories / recipe_obj.servings
		results.append(recipe)

	user_id = session["user_id"]
	user = User.query.filter_by(user_id=user_id).first().fname

	return render_template("display_plan.html", results=results, user=user)

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

	ingredient_ids = []
	for recipe_id in recipes_ids:
		recipe_ing_lst = RecipeIngredient.query.filter_by(recipe_id=recipe_id).all()
		recipe_name = Recipe.query.filter_by(recipe_id=recipe_id).first().recipe_name

		for recipe_ing in recipe_ing_lst:
			#recipe_ing - object
			ingredient_ids.append(recipe_ing.ingredient_id)

	ingredient_dictionary = {}
	for ing in ingredient_ids:
		ingredient = Ingredient.query.filter_by(ingredient_id=ing).one()
		recipe_ing_obj = RecipeIngredient.query.filter_by(ingredient_id=ingredient.ingredient_id).first()
		
		if ingredient.ingredient_name not in ingredient_dictionary:
			ingredient_dictionary[ingredient.ingredient_name] = recipe_ing_obj.amount
		else:
			ingredient_dictionary[ingredient.ingredient_name] += recipe_ing_obj.amount

	return render_template("display_shopping_list.html", results=ingredient_dictionary)

@app.route("/make-a-meal-from-fridge")
def show_ing_form():
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

	# add a button Log Out
	# jquery

if __name__ == "__main__":
	app.debug = True
	app.config['DEBUG_TB_INTERCEPT_REDIRECTS'] = False
	DebugToolbarExtension(app)
	connect_to_db(app)
	app.run(host='0.0.0.0', port=5000)

	#658 the end