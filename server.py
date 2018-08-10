from pprint import pformat
import os

import requests
from flask import Flask, render_template, request, flash, redirect
from flask_debugtoolbar import DebugToolbarExtension

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
	#show options:
		# register
		# log in

	return render_template("homepage.html")

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

@app.route("/register-form")
def register():
	"""Register user if not in the database"""

	#make a form with fname, lname, email, password
	# make a form for allergies
	#make a submit
	#check if email in database
	#if yes flash message: user in database
	#redirect to login

	#else: add user to database
	#redirect to homepage
	

	pass

@app.route("/login")
def login():
	"""Login user"""
 
	# form with email and password, SUBMIT
	#get email and password 
	#check if they in database
	#if yes: homepage 1st option
	#if no: homepage 2nd option


	pass

@app.route("/logout")
def logout():
	"""Logout user"""
	# remember about adding a session
	# add a button Log Out
	# jquery

	pass

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


# @app.route("/")
# def create_meal_plan():
# 	"""Based on users preferences search recipes."""

# 	#the essence of the app
# 	#how to get the recipes from db and sum (calories, macros,allergies)
# 	#1. get all the recipes from db where allergies AND health label is the same as user`s preference
# 	#2. Think about dinner/breakfast/lunch - do they have labels??
# 	#3. Proportion of calories - br-lunch-dinner????
# 	#....what will be next?

# 	pass


# @app.route("/make-a-meal-from-fridge")
# def make_a_meal():
# 	"""Make a meal from your fridge"""

# 	# make an html form
# 	# put a checkbox with the ingredients
# 	# put a submit button
# 	# redirect to the route cooking route

# 	pass

# @app.route("/cook-a-meal-from-fridge")
# def cook_a_meal():

# 	#get ingredients from the form
# 	#search recepies from the database which have those ingredients
# 	#list the recipes
# 	#redirect to a form which listing recepies

# 	pass

# @app.route("/show-a-meal-from-fridge")
# def show_meal():

# 	#I am not sure if I need this route
# 	# make a form listing the recipes
# 	#after clicking favorite recipe recirect to recipe url
# 	#recipe url is in database as directions

# 	pass

if __name__ == "__main__":
	app.debug = True
	app.config['DEBUG_TB_INTERCEPT_REDIRECTS'] = False
	DebugToolbarExtension(app)
	app.run(host='0.0.0.0', port=5000)

