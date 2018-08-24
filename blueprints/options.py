from flask import Blueprint, render_template

options_page = Blueprint('options_page', __name__, template_folder='templates')

@options_page.route("/options")
def show_options_form():
	"""Redirect from the preferences form. Display checkbox with diet options."""

	return render_template("options_diet.html")

@options_page.route("/options", methods=["POST"])
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
