class_name Global extends Object

static var bounce_decay_factor:float = 0.95

static var gravity_constant:float = 9.8

static func calculate_gravity_acceleration(radius:float, density:float) -> float:
	var volume:float = 4.0 / 3.0 * PI * (radius * radius * radius)
	var mass:float = density * volume
	var surfaceGravity:float = Global.gravity_constant * mass / (radius * radius)
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
