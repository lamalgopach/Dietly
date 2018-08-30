from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


# model work, add a flag
# dafault always with nullable False?

#1
class Recipe(db.Model):
    """Recipe"""

    __tablename__ = "recipes"
    
    recipe_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    recipe_name = db.Column(db.String, nullable=False) #uniqueness 
    recipe_url = db.Column(db.String, nullable=False) 
    recipe_image = db.Column(db.String)
    directions = db.Column(db.Text, nullable=False)#here will probably goes the url so text/string??? 
    servings = db.Column(db.Float, nullable=False) #default=2
    calories = db.Column(db.Float, nullable=False, default=0) #not sure about if nullable
    carbohydrates = db.Column(db.Float, nullable=False) #not sure if nullable
    fat = db.Column(db.Float, nullable=False) #not sure if nullable
    protein = db.Column(db.Float, nullable=False) #not sure if nullable 


    def __repr__(self):
        return f"""<Recipe name={self.recipe_name}>"""

#2
class Ingredient(db.Model):
    """Ingredient"""    

    __tablename__ = "ingredients"

    ingredient_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    ingredient_name = db.Column(db.String, nullable=False)


    def __repr__(self):
        return f"""<Ingredient ID={self.ingredient_id}, ingredient name={self.ingredient_name}>"""


#3 middle #1
class RecipeIngredient(db.Model):
    """Middle table. Recipe and Ingredient"""

    __tablename__ = "recipes_ingredients" #naming??

    recipe_ingredient_id = db.Column(db.Integer, autoincrement=True, primary_key=True) 
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.recipe_id')) #why string?
    ingredient_id = db.Column(db.Integer, db.ForeignKey('ingredients.ingredient_id'))
    amount = db.Column(db.Float)

    recipe = db.relationship("Recipe", backref=db.backref("recipes_ingredients", order_by=recipe_ingredient_id))

    ingredient = db.relationship("Ingredient", backref=db.backref("recipes_ingredients", order_by=recipe_ingredient_id))


    def __repr__(self):
        return f"""<Recipe - Ingredient ID={self.recipe_ingredient_id}>""" #do I need more?    


#4
class User(db.Model):
    """User"""

    __tablename__ = "users"

    user_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    fname = db.Column(db.String, nullable=False)
    lname = db.Column(db.String, nullable=False)
    email = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)


    def __repr__(self):
        return f"""<User ID={self.user_id}, First name={self.fname}, 
                    Last Name={self.lname}, Email={self.email}>"""

#5 associate
class Plan(db.Model):
    """Plan"""

    __tablename__ = "plans"

    plan_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    plan_name = db.Column(db.String, nullable=False, default="plan") #??????do I need? 
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'))
    # timestamp = db.Column(db.DateTime) #period of time??
    calories = db.Column(db.Float, nullable=False)
    carbohydrates = db.Column(db.Float, nullable=False)
    fat = db.Column(db.Float, nullable=False)
    protein = db.Column(db.Float, nullable=False)

    user = db.relationship("User", backref=db.backref("plans", order_by=plan_id))

    def __repr__(self):
        return f"""<Plan ID={self.plan_id}>"""#add plan name if necessary

#6 middle #2
class PlanRecipe(db.Model):
    # PlanRecipe
    """Associate table. Recipes and Plan"""

    __tablename__ = "plans_recipes"

    recipe_plan_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    plan_id = db.Column(db.Integer, db.ForeignKey('plans.plan_id'))
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.recipe_id'))

    plan = db.relationship("Plan", backref=db.backref("plans_recipes", order_by=recipe_plan_id))
    recipe = db.relationship("Recipe", backref=db.backref("plans_recipes", order_by=recipe_plan_id))

    def __repr__(self):
        return f"""<Plan-Recipe ID={self.recipe_plan_id}>"""

#7
class Allergy(db.Model):
    """List of allergies"""

    __tablename__ = "allergies"

    allergy_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    allergy_name = db.Column(db.String, nullable=False)

    def __repr__(self):
        return f"""<Allergy ID={self.allergy_id}>"""    

#8 middle #2
class UserAllergy(db.Model):
    """Middle table. List of user's allergies"""

    __tablename__ = "users_allergies"

    user_allergy_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'))
    allergy_id = db.Column(db.Integer, db.ForeignKey('allergies.allergy_id'))
   
    user = db.relationship("User", backref=db.backref("users_allergies", order_by=user_allergy_id))
    allergy = db.relationship("Allergy", backref=db.backref("users_allergies", order_by=user_allergy_id))

    def __repr__(self):
        return f"""<ID={self.user_allergy_id}>"""

#9 middle #3
class Diet(db.Model):
    """List of diet and health diets."""

    __tablename__ = "diets"

    diet_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    diet_name = db.Column(db.String, nullable=False)

    def __repr__(self):
        return f"""<Diet ID={self.diet_id}>"""    

#10 middle #4
class UserDiet(db.Model):
    """Middle table with users and diets."""

    __tablename__ = "users_diets"

    user_diet_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'))
    diet_id = db.Column(db.Integer, db.ForeignKey('diets.diet_id'))
   
    user = db.relationship("User", backref=db.backref("users_diets", order_by=user_diet_id))
    diet = db.relationship("Diet", backref=db.backref("users_diets", order_by=user_diet_id))

    def __repr__(self):
        return f"""<ID={self.user_diet_id}>"""

#11 middle #5
class RecipeDiet(db.Model):
    """Middle table. List of diets in recipes."""

    __tablename__ = "diets_recipes"

    diet_recipe_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.recipe_id'))
    diet_id = db.Column(db.Integer, db.ForeignKey('diets.diet_id'))
   
    recipe = db.relationship("Recipe", backref=db.backref("diets_recipes", order_by=diet_recipe_id))
    diet = db.relationship("Diet", backref=db.backref("diets_recipes", order_by=diet_recipe_id))

    def __repr__(self):
        return f"""<ID={self.diet_recipe_id}>"""

#12 middle #6

class RecipeAllergy(db.Model):
    """Middle table. List of allergies(cautions) in recipes."""

    __tablename__ = "allergies_recipes"

    allergy_recipe_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.recipe_id'))
    allergy_id = db.Column(db.Integer, db.ForeignKey('allergies.allergy_id'))
   
    recipe = db.relationship("Recipe", backref=db.backref("allergies_recipes", order_by=allergy_recipe_id))
    allergy = db.relationship("Allergy", backref=db.backref("allergies_recipes", order_by=allergy_recipe_id))

    def __repr__(self):
        return f"""<ID={self.allergy_recipe_id}>"""

def connect_to_db(app):
    """Connect the database to our Flask app."""

    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql:///mealplan'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SQLALCHEMY_ECHO'] = True
    db.app = app
    db.init_app(app)

if __name__ == "__main__":

    from server import app

    connect_to_db(app)
    db.create_all()
    print("Connected to DB.")