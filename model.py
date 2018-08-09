#i`VE COPIED from homework, but then analyzed very carefully

from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


# model work, add a flag
# dafault always with nullable False?

class Recipe(db.Model):
    """Recipe"""

    __tablename__ = "recipes"
    
    recipe_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    recipe_name = db.Column(db.String, nullable=False) #uniqueness 
    recipe_url = db.Column(db.String, nullable=False) 
    recipe_image = db.Column(db.String)
    directions = db.Column(db.Text, nullable=False)#here will probably goes the url so text/string??? 
    servings = db.Column(db.Float, nullable=False) #default=2
    diet_label = db.Column(db.String, nullable=False, default="Balanced") #low-carb, balanced, high-protein, low-fat, 
    health_label= db.Column(db.String, nullable=False, default="Regular") #[ "Vegan", "Vegetarian", "Peanut-Free", "Tree-Nut-Free", "Alcohol-Free", Sugar-Conscious" ],
    caution = db.Column(db.String, nullable=False, default="No cautions")#ALLERGIES #wheat, gluten, peanuts, tree-nuts, soy, egg, milk, shellfish
    calories = db.Column(db.Integer, nullable=False, default=0) #not sure about if nullable
    carbohydrates = db.Column(db.Integer, nullable=False) #not sure if nullable
    fat = db.Column(db.Integer, nullable=False) #not sure if nullable
    protein = db.Column(db.Integer, nullable=False) #not sure if nullable 



    def __repr__(self):
        return f"""<Recipe name={self.recipe_name}>"""


# class Meal(db.Model):
#     """Meal flag"""

#     __tablename__ = "meals"

#     meal_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
#     recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.recipe_id'))
#     meal_flag = db.Column(db.String, nullable=False)

#     recipe = db.relationship("Recipe", backref=db.backref("recipes", order_by=meal_id))

    # def __repr__(self):
    #     return f"""<Meal ID={self.meal_id}>"""


class Ingredient(db.Model):
    """Ingredient"""    

    __tablename__ = "ingredients"

    ingredient_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    ingredient_name = db.Column(db.String, nullable=False)


    def __repr__(self):
        return f"""<Ingredient ID={self.ingredient_id}, ingredient name={self.ingredient_name}>"""



class RecipeIngredient(db.Model):
    """Associate Table with Recipe and Ingredient"""#for sure is it associate?

    __tablename__ = "recipes_and_ingredients" #naming??

    recipe_ingredient_id = db.Column(db.Integer, autoincrement=True, primaryKey=True) 
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.recipe_id')) #why string?
    ingredient_id = db.Column(db.Integer, db.ForeignKey('ingredients.ingredient_id'))
    amount = db.Column(db.Integer, nullable=False)

    recipe = db.relationship("Recipe", backref=db.backref("recipes_and_ingredients", order_by=recipe_ingredient_id))
    #I dont understand this line.
    ingredient = db.relationship("Ingredient", backref=db.backref("recipes_and_ingredients", order_by=recipe_ingredient_id))
    #why name of class is str??

    def __repr__(self):
        return f"""<Recipe - Ingredient ID={self.recipe_ingredient_id}>""" #do I need more?    



###############################################################################################################

                            #USER#

class User(db.Model):
    """User"""

    __tablename__ = "users"

    user_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    fname = db.Column(db.String, nullable=False)
    lname = db.Column(db.String, nullable=False)
    email = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False) #to revise


    def __repr__(self):
        return f"""<User ID={self.user_id}, First name={self.fname}, 
                    Last Name={self.lname}, Email={self.email}>"""



class Plan(db.Model):
    """Plan"""

    __tablename__ = "plans"

    plan_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    plan_name = db.Column(db.String) #??????do I need? 
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'))
    # timestamp = db.Column(db.DateTime) #period of time??
    calories = db.Column(db.Float, nullable=False)
    carbohydrates = db.Column(db.Float, nullable=False)
    fat = db.Column(db.Float, nullable=False)
    protein = db.Column(db.Float, nullable=False)

    user = db.relationship("User", backref=db.backref("users", order_by=plan_id))

    def __repr__(self):
        return f"""<Plan ID={self.plan_id}, User ID={self.user_id}, 
                    Timestamp={self.timestamp}>"""#add plan name if necessary



class RecipePlan(db.Model):
    """Recipes and Plan"""

    __tablename__ = "recipes_and_plans"

    recipe_plan_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    plan_id = db.Column(db.Integer, db.ForeignKey('plans.plan_id'))
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.recipe_id'))

    plan = db.relationship("Plan", backref=db.backref("plans", order_by=recipe_plan_id))
    recipe = db.relationship("Recipe", backref=db.backref("recipes", order_by=recipe_plan_id))

    def __repr__(self):
        return f"""<Recipe - Plan ID={self.recipe_plan_id}, Plan ID={self.plan_id}, 
                    Recipe ID ={self.recipe_id}, Timestamp={self.timestamp}>"""


class Allergy(db.Model):
    """List of allergies"""

    __tablename__ = "allergies"

    allergy_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    allergy_name = db.Column(db.String, nullable=False)

    def __repr__(self):
        return f"""<Allergy={self.allergy_name}, Allergy ID={self.allergy_id}>"""    


class UserAllergy(db.Model):
    """List of user's allergies"""

    __tablename__ = "users_and_allergies"

    user_allergy_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'))
    allergy_id = db.Column(db.Integer, db.ForeignKey('allergies.allergy_id'))
   
    user = db.relationship("User", backref=db.backref("users", order_by=user_allergy_id))
    allergy = db.relationship("Allergy", backref=db.backref("allergies", order_by=user_allergy_id))

    def __repr__(self):
        return f"""<User={self.user_id}, Allergy={self.allergy_id}>"""



########################not sure if diet class necessary. probably only in recipes.

# class Diet(db.Model):
#     """List of types of diet."""

#     __tablename__ = "diets"

#     diet_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
#     diet_name = db.Column(db.String, nullable=False)

#     def __repr__(self):
#         return f"""<Diet={self.diet_name}, diet ID={self.diet_id}>"""    


# class UserDiet(db.Model):
#     """List of users' diets."""

#     __tablename__ = "users_diets"

#     users_diet_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
#     user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'))
#     diet_id = db.Column(db.Integer, db.ForeignKey('diets.diet_id'))
   
#     user = db.relationship("User", backref=db.backref("users", order_by=user_allergy_id))
#     diet = db.relationship("Diet", backref=db.backref("diets", order_by=user_diet_id))

#     def __repr__(self):
#         return f"""<User={self.user_id}, Diet={self.diet_id}>"""