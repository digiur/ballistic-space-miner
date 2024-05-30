extends CharacterBody2D

@export var player_speed:float = 300.0

var current_planet:Node2D = null

func _physics_process(delta):
	
	if current_planet == null:
		return

	var gravity:Vector2 = current_planet.global_position - self.global_position
	#gravity = gravity.normalized() * current_planet.gravity_area.gravity

	var direction = Input.get_axis("ui_left", "ui_right")
	var movement:Vector2 = transform.x.normalized() * player_speed * direction

	velocity = gravity + movement

	if direction < 0.0:
		print("left")
	elif direction < 0.0:
		print("left")

	move_and_slide()

func _on_planet_detector_body_entered(body:Node2D):
	current_planet = body


func _on_planet_detector_body_exited(body):
	current_planet = null
