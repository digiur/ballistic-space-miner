class_name Dur extends Node

static var bounce_decay_factor:float = 0.95

static var gravity_constant:float = 9.8

static func calculate_gravity_acceleration(radius:float, density:float) -> float:
	var volume:float = 4.0 / 3.0 * PI * (radius * radius * radius)
	var mass:float = density * volume
	var surfaceGravity:float = Dur.gravity_constant * mass / (radius * radius)
	return surfaceGravity

static var player_jump_animations = [
	"dive",
	"dive",
	"dive",
	"jump",
	"jump",
	"jump",
	"flip_back",
	"flip_back",
	"flip_front",
	"flip_front",
	"dive",
	"dive",
	"dive",
	"jump",
	"jump",
	"jump",
	"flip_back",
	"flip_back",
	"flip_front",
	"flip_front",
	"flip_butt",
]

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
