@tool
class_name Planet extends Node2D

@export var planet_radius:int = 100:
	set(value):
		# print("planet_radius set")
		planet_radius = value
		update_child_properties = true

@export var density:float = 1.0:
	set(value):
		# print("density set")
		density = value
		update_child_properties = true

@export var gravity_radius:float = 5000.0:
	set(value):
		# print("gravity_radius set")
		gravity_radius = value
		update_child_properties = true

@onready var gravity_area: = %GravityArea as Area2D
@onready var gravity_shape: = %GravityShape as CollisionShape2D
@onready var planet_body: = %PlanetBody as StaticBody2D
@onready var planet_shape: = %PlanetShape as CollisionShape2D
#@onready var sprite_2d: = %Sprite2D as Sprite2D
@onready var animated_sprite_2d: = %AnimatedSprite2D as AnimatedSprite2D

var update_child_properties:bool = true

func _process(_delta):
	calculate_child_properties()

func _physics_process(_delta):
	calculate_child_properties()

func _ready():
	request_ready()
	# print("planet ready")
	calculate_child_properties()

func calculate_child_properties():
	if not update_child_properties:
		return

	planet_shape.shape.radius = planet_radius
	gravity_area.gravity = Dur.calculate_gravity_acceleration(planet_radius, density)
	gravity_area.gravity_point_unit_distance = planet_radius
	gravity_shape.shape.radius = gravity_radius

	if not Engine.is_editor_hint():
		var animationName:String = str(planet_radius)
		animated_sprite_2d.play(animationName)
		
		var texture:Texture2D = animated_sprite_2d.sprite_frames.get_frame_texture(animationName, 0)
		
		var xScale:float = planet_radius * 2.0 / texture.get_width()
		var yScale:float = planet_radius * 2.0 / texture.get_height()
#
		animated_sprite_2d.scale = Vector2(xScale, yScale)
		animated_sprite_2d.visible = true

	update_child_properties = false
	# print("planet child properties calculated")
