extends Node

const Veg:Array[String] = ["carrot", "tomato", "sweet pepper", "jalepeno", "bell pepper", "celery", "onion", "tomato", "eggplant", "kale", "spinach", "radish", "fresh herb", "cucumber", "cabbage", "brocolli", "green bean", "cauliflower", "zucchini", "squash", "snow peas", "sweet peas", "brussel sprouts", "asparagus", "beet", "bok choy", "corn", "leeks", "mushrooms", "potato", "tomatillo", "olives", "tender greens"]
const Protein:Array[String] = ["Chicken", "Seafood", "tofu", "Meat Substitute/Bean"]
const Style:Array[String] = ["Curry", "Sheet Pan", "Taco", "Sandwich/Wrap", "Soup/Stew", "Salad", "Pasta", "Grain Bowl"]

func _input(event:InputEvent):
	if event.is_action_pressed("get_dinner_idea"):
		roll_food()

func roll_food():
	print("-------------------")
	print("Veg: ", Veg.pick_random())
	print("Protein: ", Protein.pick_random())
	print("Style: ", Style.pick_random())
