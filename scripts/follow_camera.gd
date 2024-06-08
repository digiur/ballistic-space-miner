class_name FollowCamera extends Camera2D

@export var speed:float = 10.0
@export var follow_mode:bool = false
@export var follow:Player = null

func _ready():
	global_position = follow.get_follow_position()
	global_rotation = follow.get_follow_rotation()

func _process(delta:float):
	if Input.is_action_just_pressed("camera_out"):
		zoom *= 1.5 / 2.0

	if Input.is_action_just_pressed("camera_in"):
		zoom *= 2.0 / 1.5

	if not follow_mode:
		if Input.is_action_pressed("camera_right"):
			position += Vector2.RIGHT * (1 / zoom.x) * speed

		if Input.is_action_pressed("camera_left"):
			position += Vector2.LEFT * (1 / zoom.x) * speed

		if Input.is_action_pressed("camera_up"):
			position += Vector2.UP * (1 / zoom.y) * speed

		if Input.is_action_pressed("camera_down"):
			position += Vector2.DOWN * (1 / zoom.y) * speed
	else:
		global_position = lerp(global_position, follow.get_follow_position(), speed * delta)
		global_rotation = lerp_angle(global_rotation, follow.get_follow_rotation(), speed / PI * delta)
		#global_position = follow.get_follow_position()
		#global_rotation = follow.get_follow_rotation()
