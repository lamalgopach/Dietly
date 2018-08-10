from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


# model work, add a flag
# dafault always with nullable False?

#1
class Recipe(db.Model):
    """Recipe"""

    __tablename__ = "recipes"
    
    recipe_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    recipe_name = db.Column(db.String, nullable=False) #uniqueness 
    recipe_url = db.Column(db.String, nullable=False) 
    recipe_image = db.Column(db.String)
    directions = db.Column(db.Text, nullable=False)#here will probably goes the url so text/string??? 
    servings = db.Column(db.Float, nullable=False) #default=2
    calories = db.Column(db.Integer, nullable=False, default=0) #not sure about if nullable
    carbohydrates = db.Column(db.Integer, nullable=False) #not sure if nullable
    fat = db.Column(db.Integer, nullable=False) #not sure if nullable
    protein = db.Column(db.Integer, nullable=False) #not sure if nullable 


    def __repr__(self):
        return f"""<Recipe name={self.recipe_name}>"""

#2
class Ingredient(db.Model):
    """Ingredient"""    

    __tablename__ = "ingredients"

    ingredient_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    ingredient_name = db.Column(db.String, nullable=False)


    def __repr__(self):
        return f"""<Ingredient ID={self.ingredient_id}, ingredient name={self.ingredient_name}>"""


#3 middle #1
class RecipeIngredient(db.Model):
    """Middle table. Recipe and Ingredient"""

    __tablename__ = "recipes_and_ingredients" #naming??

    recipe_ingredient_id = db.Column(db.Integer, autoincrement=True, primaryKey=True) 
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.recipe_id')) #why string?
    ingredient_id = db.Column(db.Integer, db.ForeignKey('ingredients.ingredient_id'))
    amount = db.Column(db.Integer, nullable=False)

    recipe = db.relationship("Recipe", backref=db.backref("recipes_and_ingredients", order_by=recipe_ingredient_id))

    ingredient = db.relationship("Ingredient", backref=db.backref("recipes_and_ingredients", order_by=recipe_ingredient_id))


    def __repr__(self):
        return f"""<Recipe - Ingredient ID={self.recipe_ingredient_id}>""" #do I need more?    


#4
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

#5 associate
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

    user = db.relationship("User", backref=db.backref("plans", order_by=plan_id))

    def __repr__(self):
        return f"""<Plan ID={self.plan_id}>"""#add plan name if necessary

#6 middle #2
class RecipePlan(db.Model):
    """Associate table. Recipes and Plan"""

    __tablename__ = "recipes_and_plans"

    recipe_plan_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    plan_id = db.Column(db.Integer, db.ForeignKey('plans.plan_id'))
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.recipe_id'))

    plan = db.relationship("Plan", backref=db.backref("plans", order_by=recipe_plan_id))
    recipe = db.relationship("Recipe", backref=db.backref("recipes", order_by=recipe_plan_id))

    def __repr__(self):
        return f"""<Recipe - Plan ID={self.recipe_plan_id}>"""

#7
class Allergy(db.Model):
    """List of allergies"""

    __tablename__ = "allergies"

    allergy_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    allergy_name = db.Column(db.String, nullable=False)

    def __repr__(self):
        return f"""<Allergy ID={self.allergy_id}>"""    

#8 middle #2
class UserAllergy(db.Model):
    """Middle table. List of user's allergies"""

    __tablename__ = "users_and_allergies"

    user_allergy_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'))
    allergy_id = db.Column(db.Integer, db.ForeignKey('allergies.allergy_id'))
   
    user = db.relationship("User", backref=db.backref("users", order_by=user_allergy_id))
    allergy = db.relationship("Allergy", backref=db.backref("allergies", order_by=user_allergy_id))

    def __repr__(self):
        return f"""<ID={self.user_allergy_id}>"""

#9 middle #3
class Label(db.Model):
    """List of diet and health labels."""

    __tablename__ = "labels"

    label_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    label_name = db.Column(db.String, nullable=False)

    def __repr__(self):
        return f"""<Label ID={self.label_id}>"""    

#10 middle #4
class UserLabel(db.Model):
    """Middle table with users and labels."""

    __tablename__ = "users_labels"

    user_label_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'))
    label_id = db.Column(db.Integer, db.ForeignKey('labels.label_id'))
   
    user = db.relationship("User", backref=db.backref("users", order_by=user_label_id))
    label = db.relationship("Label", backref=db.backref("labels", order_by=user_label_id))

    def __repr__(self):
        return f"""<ID={self.user_dhl_id}>"""

#11 middle #5
class RecipeLabel(db.Model):
    """Middle table. List of labels in recipes."""

    __tablename__ = "labels_recipes"

    label_recipe_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.recipe_id'))
    label_id = db.Column(db.Integer, db.ForeignKey('labels.label_id'))
   
    recipe = db.relationship("Recipe", backref=db.backref("recipes", order_by=label_recipe_id))
    label = db.relationship("Label", backref=db.backref("labels", order_by=label_recipe_id))

    def __repr__(self):
        return f"""<ID={self.label_recipe_id}>"""

#12 middle #6

class RecipeAllergy(db.Model):
    """Middle table. List of allergies(cautions) in recipes."""

    __tablename__ = "allergies_recipes"

    allergy_recipe_id = db.Column(db.Integer, autoincrement=True, primaryKey=True)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipes.recipe_id'))
    allergy_id = db.Column(db.Integer, db.ForeignKey('allergies.allergy_id'))
   
    recipe = db.relationship("Recipe", backref=db.backref("recipes", order_by=allergy_recipe_id))
    allergy = db.relationship("Label", backref=db.backref("allergies", order_by=allergy_recipe_id))

    def __repr__(self):
        return f"""<ID={self.allergy_recipe_id}>"""