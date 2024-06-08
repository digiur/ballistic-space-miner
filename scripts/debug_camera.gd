class_name DebugCamera extends Camera2D

@export var speed:float = 10.0

func _process(_delta:float):
	if Input.is_action_just_pressed("camera_out"):
		zoom *= 1.5 / 2.0

	if Input.is_action_just_pressed("camera_in"):
		zoom *= 2.0 / 1.5

	if Input.is_action_pressed("camera_right"):
		position += Vector2.RIGHT * (1 / zoom.x) * speed

	if Input.is_action_pressed("camera_left"):
		position += Vector2.LEFT * (1 / zoom.x) * speed

	if Input.is_action_pressed("camera_up"):
		position += Vector2.UP * (1 / zoom.y) * speed

	if Input.is_action_pressed("camera_down"):
		position += Vector2.DOWN * (1 / zoom.y) * speed
