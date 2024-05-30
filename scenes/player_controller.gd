extends Node2D

@export var player_speed:float = 100.0

@onready var character_body_2d = $Body/CharacterBody2D

var current_planet:Node2D = null

func _physics_process(delta):
	
	if current_planet == null:
		print("no current_planet")
		return

	var gravity_area:Area2D = current_planet.get_node("GravityArea") as Area2D
	
	if gravity_area == null:
		print("no gravity_area")
		return

	var gravity:Vector2 = current_planet.global_position - self.global_position
	gravity = gravity.normalized() * gravity_area.gravity

	var direction = Input.get_axis("ui_left", "ui_right")
	var movement:Vector2 = transform.x.normalized() * player_speed * direction

	character_body_2d.velocity = gravity + movement
	self.rotation_degrees = gravity.angle()

	print(character_body_2d.move_and_slide())
	
	self.position = character_body_2d.global_position
	character_body_2d.position = Vector2.ZERO

func _on_planet_detector_body_entered(body:Node2D):
	current_planet = body.get_parent()


func _on_planet_detector_body_exited(body):
	current_planet = null
