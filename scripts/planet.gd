@tool
extends Node2D

@export var planet_radius: float = 100.0:
	set(value):
		planet_radius = value
		print("planet_radius set")
		print(value)
		update_child_properties = true

@export var density: float = 1.0:
	set(value):
		density = value
		print("density set")
		print(value)
		update_child_properties = true

@export var gravity_radius: float = 5000.0:
	set(value):
		gravity_radius = value
		print("gravity_radius set")
		print(value)
		update_child_properties = true

@onready var gravity_area = %GravityArea
@onready var gravity_shape = %GravityShape
@onready var planet_body = %PlanetBody
@onready var planet_shape = %PlanetShape
@onready var sprite_2d = %Sprite2D

var update_child_properties: bool = true

func _process(_delta):
	if(update_child_properties):
		calculate_child_properties()

func _ready():
	request_ready()
	print("planet ready")
	calculate_child_properties()

func calculate_child_properties():
	var volume : float = 4.0 / 3.0 * PI * (planet_radius * planet_radius * planet_radius)
	var mass : float = density * volume
	var surfaceGravity : float = Global.G * mass / (planet_radius * planet_radius)

	planet_shape.shape.radius = planet_radius
	gravity_area.gravity = surfaceGravity
	gravity_area.gravity_point_unit_distance = planet_radius
	planet_body.physics_material_override.friction = 50
	print(planet_body.physics_material_override.friction)
	gravity_shape.shape.radius = gravity_radius

	if not Engine.is_editor_hint():
		var xScale : float = planet_radius * 2.0 / sprite_2d.texture.get_height()
		var yScale = planet_radius * 2.0 / sprite_2d.texture.get_width()
#
		sprite_2d.scale = Vector2(xScale, yScale)
		sprite_2d.visible = true

	update_child_properties = false
	print("planet child properties calculated")
