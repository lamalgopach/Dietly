from pprint import pformat
import os

import requests
from flask import Flask, render_template, request, flash, redirect, session
from flask_debugtoolbar import DebugToolbarExtension

from model import db, User, Allergy, UserAllergy, Plan, connect_to_db

app = Flask(__name__)
app.secret_key = "SECRETSECRETSECRET"

EDAMAM_RECIPE_SEARCH_APPLICATION_ID = os.environ.get('EDAMAM_RECIPE_SEARCH_APPLICATION_ID')
EDAMAM_RECIPE_SEARCH_APPLICATION_KEY = os.environ.get('EDAMAM_RECIPE_SEARCH_APPLICATION_KEY')

EDAMAM_URL = "https://api.edamam.com/search"

@app.route("/show-recipe")
def show_recipe():
	"""Show the recipe"""

	recipe_name = 'chicken' 

	payload = { 'q': recipe_name,
				'app_id': EDAMAM_RECIPE_SEARCH_APPLICATION_ID,
				'app_key': EDAMAM_RECIPE_SEARCH_APPLICATION_KEY }
	
	response = requests.get(EDAMAM_URL, params=payload)
	data = response.json()
	
	if response.ok:
		recipe = data["hits"][0]["recipe"]["dietLabels"]

	return render_template("recipe.html", results=recipe)

@app.route("/")
def homepage():
	"""Show homepage"""

	#if logged in - flash message: Succesfully logged in
	#show options in form(nav menu):
		# go to preferences 
		# go to make a meal from your fridge

	#if NOT logged in - flash message: You are not logged in
	if "user_id" in session:
		print(session)
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
	"""Redirect from homepage/registration form. Display checkbox with set of allergies."""

	return render_template("allergies.html")


@app.route("/allergy", methods=["POST"])
def handle_allergy_form():
	"""Handle user's allergies."""

######################### maybe MORE ELEGANT??
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

	if gluten:
		allergy_id = 1
		new_users_allergy = UserAllergy(user_id=user_id, allergy_id=allergy_id)
		db.session.add(new_users_allergy)
	if wheat:
		allergy_id = 2
		new_users_allergy = UserAllergy(user_id=user_id, allergy_id=allergy_id)
		db.session.add(new_users_allergy)
	if tree_nut:
		allergy_id = 3
		new_users_allergy = UserAllergy(user_id=user_id, allergy_id=allergy_id)
		db.session.add(new_users_allergy)
	if shellfish:
		allergy_id = 4
		new_users_allergy = UserAllergy(user_id=user_id, allergy_id=allergy_id)
		db.session.add(new_users_allergy)
	if soy:
		allergy_id = 5
		new_users_allergy = UserAllergy(user_id=user_id, allergy_id=allergy_id)
		db.session.add(new_users_allergy)

	db.session.commit()

	return render_template("users_allergies.html", allergens=allergens)
	# make the user page more personal


@app.route("/login")
def login():
	"""Show login form."""

	return render_template("login_page.html")

@app.route("/login", methods=["POST"])
def login_form():
	"""Login user."""

	email=request.form["email"]
	password=request.form["password"]

	user = User.query.filter_by(email=email).first()

	if not email:
		flash("Not such user.")
		return redirect("/login")

	elif user.password != password:
		flash("Incorrect password!")
		return redirect("/login")

	session["user_id"] = user.user_id
	flash("User logged in!")
	return redirect("/")

	# return redirect(f"/users/{new_user.user_id}")


	flash(f"User succesfully logged in.")
	return redirect("/")


@app.route("/plan")
def user_options():
	"""Show users options"""

	return render_template("plan.html")

@app.route("/plan", methods=["POST"])
def user_preferences():
	"""Get the preferences."""

	plan_name = request.form.get("plan_name")
	user_id = session["user_id"]
	calories = request.form.get("calories")
	carbohydrates = request.form.get("carbs")
	fat = request.form.get("fat")
	protein = request.form.get("protein")

	new_plan = Plan(plan_name=plan_name, user_id=user_id, calories=calories, carbohydrates=carbohydrates, fat=fat, protein=protein)
	db.session.add(new_plan)
	db.session.commit()

	return render_template("homepage.html")



##############################OPTIONS - TO DDOOOO


@app.route("/options")
def show_options_form():
	"""Redirect from preferences form. Display checkbox with diet options."""

	return render_template("options_diet.html")


@app.route("/options", methods=["POST"])
def handle_options_form():
	"""Handle user's diet options."""
	pass




	# alcohol_free = request.form.get("Alcohol-Free")
	# balanced = request.form.get("Balanced")
	# high_protein = request.form.get("High-Protein")
	# low_carb = request.form.get("Low-Carb")	
	# low_fat = request.form.get("Low-Fat")


	# peanut_free = request.form.get("Peanut-Free")
	# low_fat = request.form.get("Sugar-Conscious")



	# <input type="checkbox", name="option6", value="Peanut-Free"> Peanut-Free? <br>
	# <input type="checkbox", name="option7", value="Sugar-Conscious"> Sugar-Conscious? <br>
	# <input type="checkbox", name="option8", value="Tree-Nut-Free"> Tree-Nut-Free? <br>
	# <input type="checkbox", name="option9", value="Vegan"> Vegan? <br>
	# <input type="checkbox", name="option10", value="Vegetarian"> Vegetarian? <br>




# 	user_id = session["new_user_id"]

# 	if gluten:
# 		allergy_id = 1
# 		new_users_allergy = UserAllergy(user_id=user_id, allergy_id=allergy_id)
# 		db.session.add(new_users_allergy)
# 	if wheat:
# 		allergy_id = 2
# 		new_users_allergy = UserAllergy(user_id=user_id, allergy_id=allergy_id)
# 		db.session.add(new_users_allergy)
# 	if tree_nut:
# 		allergy_id = 3
# 		new_users_allergy = UserAllergy(user_id=user_id, allergy_id=allergy_id)
# 		db.session.add(new_users_allergy)
# 	if shellfish:
# 		allergy_id = 4
# 		new_users_allergy = UserAllergy(user_id=user_id, allergy_id=allergy_id)
# 		db.session.add(new_users_allergy)
# 	if soy:
# 		allergy_id = 5
# 		new_users_allergy = UserAllergy(user_id=user_id, allergy_id=allergy_id)
# 		db.session.add(new_users_allergy)

# 	db.session.commit()

# 	return render_template("users_allergies.html", allergens=allergens)
# 	# make the user page more personal



































@app.route("/logout")
def logout():
    """Log out user."""

    del session["user_id"]
    flash("Logged Out.")
    return redirect("/")

	# add a button Log Out
	# jquery

@app.route("/design-your-meal-plan")
def design_meal_plan():

	# make a form: calories - text
	# macros - numbers
	# type of diet
	#in this function calculate sum
	#ask how you can sum up to 100
	#JS?????????
	#so basically check if macros are sum up to 100

	pass
@app.route("/get-users-preferences")
def get_users_preferences():
	"""Get users preferences. Store in database."""
	#update model.py
	#get the preferences: calories
	#add to the database
	#redirect to next route

	pass


 ##################converting macros##########
@app.route("/convert-fat")
def convert_fat():
	"""Convert weight of fat to get the percentage of energy"""
	# write a test first
	# revise the code below
	# get a value of fat from the form user`s preferences
	# calculate accurate value of fat
	# return accurate value of fat
	# if the function is ok repeat the same for carbs and protein in separate funtions

	pass

@app.route("/display-breakfast-preferences")
def display_breakfast_preferences():
	# make a form which display preferable breakfasts
	# get favorite breakfasts

	pass


@app.route("/")
def create_meal_plan():
	"""Based on users preferences search recipes."""

	#the essence of the app
	#how to get the recipes from db and sum (calories, macros,allergies)
	#1. get all the recipes from db where allergies AND health label is the same as user`s preference
	#2. Think about dinner/breakfast/lunch - do they have labels??
	#3. Proportion of calories - br-lunch-dinner????
	#....what will be next?
	# sum a bunch of br+lunch+dinner
	#check if sum is equal to users preferences

	pass


@app.route("/make-a-meal-from-fridge")
def make_a_meal():
	"""Make a meal from your fridge"""

	# make an html form
	# put a checkbox with the ingredients
	# put a submit button
	# redirect to the route cooking route

	pass

@app.route("/cook-a-meal-from-fridge")
def cook_a_meal():

	#get ingredients from the form
	#search recepies from the database which have those ingredients
	#list the recipes
	#redirect to a form which listing recepies

	pass

@app.route("/show-a-meal-from-fridge")
def show_meal():

	#I am not sure if I need this route
	# make a form listing the recipes
	#after clicking favorite recipe recirect to recipe url
	#recipe url is in database as directions

	pass

if __name__ == "__main__":
	app.debug = True
	app.config['DEBUG_TB_INTERCEPT_REDIRECTS'] = False
	DebugToolbarExtension(app)
	connect_to_db(app)
    # db.create_all()
	app.run(host='0.0.0.0', port=5000)