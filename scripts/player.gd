class_name Player extends Node2D

@export var walk_speed:float = 3000.0
@export var jump_speed:float = 4000.0
@export var bounce:float = 0.6
@export var camera_rise:float = 150.0
@export var look_rise:float = 150.0

@onready var dynamic_nodes_handle: = %DynamicNodesHandle as Node2D
@onready var rigid_body_2d: = %RigidBody2D as RigidBody2D
@onready var character_body_2d: = %CharacterBody2D as CharacterBody2D
@onready var animated_sprite_2d: = %AnimatedSprite2D as AnimatedSprite2D
@onready var timer: = %BallisticTimer as Timer
@onready var animation_player: = $AnimationPlayer as AnimationPlayer

enum PlayerState {NONE, BALLISTIC, PLAYER}

var prev_state:PlayerState = PlayerState.NONE
var current_state:PlayerState = PlayerState.NONE
var next_state:PlayerState = PlayerState.BALLISTIC

var current_planet:Planet = null

var ballistic_state_over:bool = false
var next_ballistic_velocity:Vector2 = Vector2.ZERO

var aiming:bool = false
var vec_start: = Vector2.ZERO
var vec_fin: = Vector2.ZERO
const SPAWNEE:PackedScene = preload("res://scenes/item.tscn")
@export var vectorMultiplier:float = 1.0

var speed:float = 0.0

var tts_string:String = "Welcome. This is the beginning of a journey. through the outer reaches of the galaxy. The cosmos can be unforgiving. but with the right skills. survival and success are within reach. Today's task is simple yet crucial. mastering the art of navigating through gravity wells. and launching resources between planets.

Take a moment to look around. Absorb the beauty of the universe. the stars. the planets. and the endless possibilities that await. Each celestial body has its own gravitational pull. and mastering this will be key to success.

First, let's start with something fundamental. jumping between gravity wells. See that small moon orbiting the planet. It's the first destination. Engage the thrusters lightly. feel the tug of the planet's gravity. and aim for the moon's gravity well. The onboard computer will assist with trajectory calculations. Remember. speed and angle are crucial.

Ready?. Initiate the jump. Feel the shift?. That's the moon’s gravity taking over. Beautiful. isn’t it?. This is the first successful interplanetary jump. Now, let's move on to resource launching.

There is a crate of supplies that needs to be sent to a base on the neighboring planet. This isn’t just about brute force; it’s about precision. Align the launcher with the planet’s orbit, calculate the escape velocity, and let the crate fly. Too slow, and it will fall back to the moon. Too fast, and it will drift into the void.

Launch now. Watch as the crate sails through space, gracefully caught by the planet’s gravity well. Perfect. Each successful launch and jump brings us one step closer to mastering the stars.

Out here, every move counts, every decision matters. The gravity wells are allies, but they can also be foes if not handled carefully. Use them wisely, and the galaxy will become a playground.

Excellent work. These are the first steps in a journey that leads across the stars. Remember, the cosmos is vast and full of challenges, but with skill and determination, there's nothing that can't be achieved. Now, prepare for the next mission. Adventure awaits."

var tts_strings:PackedStringArray

var voice_ids = DisplayServer.tts_get_voices_for_language('en')
var voice_ids_index:int = 0

const FLOATING_TEXT:PackedScene = preload("res://scenes/floating_text.tscn")

func _ready():
	DisplayServer.tts_set_utterance_callback(
		DisplayServer.TTS_UTTERANCE_STARTED,
		Callable(self, "speak_callback")
	)
	tts_strings = tts_string.split(".")
	var tts_index = 0
	while tts_index < tts_strings.size():
		speak(tts_strings[tts_index], tts_index)
		tts_index += 1

func speak(string:String, id:int):
	if voice_ids.size() == 0:
		return
	var new_v_id_index = randi() % voice_ids.size()
	while new_v_id_index == voice_ids_index:
		new_v_id_index = randi() % voice_ids.size()
	voice_ids_index = new_v_id_index

	DisplayServer.tts_speak(
		string,
		voice_ids[voice_ids_index],
		50,
		1.0,
		1.0,
		id
	)

func speak_callback(i:int):
	var floating_text = FLOATING_TEXT.instantiate()
	floating_text.my_text = tts_strings[i].strip_edges()
	floating_text.position = dynamic_nodes_handle.position
	floating_text.position += character_body_2d.transform.x * -400
	floating_text.rotation = dynamic_nodes_handle.rotation
	add_child(floating_text)
	print(tts_strings[i])
	pass

func _process(delta:float):
	if next_state != current_state:
		exit_state(current_state)
		prev_state = current_state
		enter_state(next_state)
		current_state = next_state

	process_state(current_state, delta)
	queue_redraw()

	
func _draw():
	draw_line(character_body_2d.position, character_body_2d.position + (vec_start - vec_fin), Color.FOREST_GREEN)

#region Enter
func enter_state(state:PlayerState):
	print("enter_state:", state)
	match state:
		PlayerState.BALLISTIC:
			enter_balistic_state(state)
		PlayerState.PLAYER:
			enter_player_state(state)

func enter_balistic_state(state:PlayerState):
	print("enter_balistic_state")
	rigid_body_2d.process_mode = Node.PROCESS_MODE_PAUSABLE
	rigid_body_2d.visible = true
	rigid_body_2d.set_ballistic_params(
		character_body_2d.global_position,
		next_ballistic_velocity
	)

func enter_player_state(state:PlayerState):
	character_body_2d.process_mode = Node.PROCESS_MODE_PAUSABLE
	character_body_2d.visible = true
	print("enter_player_state")
#endregion

#region Process
func process_state(state:PlayerState, delta:float):
	match state:
		PlayerState.BALLISTIC:
			process_balistic_state(delta)
		PlayerState.PLAYER:
			process_player_state(delta)

func process_balistic_state(delta:float):

	dynamic_nodes_handle.global_position = rigid_body_2d.global_position

	if current_planet == null:
		var v:Vector2 = rigid_body_2d.linear_velocity
		v += dynamic_nodes_handle.global_position
		dynamic_nodes_handle.look_at(v)
	elif not rigid_body_2d.sleeping:
		dynamic_nodes_handle.rotate(rigid_body_2d.angular_velocity * delta)

	if ballistic_state_over:
		next_state = PlayerState.PLAYER

	character_body_2d.global_position = rigid_body_2d.global_position

func process_player_state(delta:float):

	if Input.is_action_just_pressed("right_click"):
		print("right click down")
		aiming = true
		vec_start = get_global_mouse_position()
		vec_fin = vec_start
		queue_redraw()

	if Input.is_action_pressed("right_click"):
		aiming = true
		vec_fin = get_global_mouse_position()
		queue_redraw()

	if Input.is_action_just_released("right_click"):
		print("right click up")
		aiming = false
		next_state = PlayerState.BALLISTIC
		next_ballistic_velocity = calc_velocity()
		vec_start = Vector2.ZERO
		vec_fin = Vector2.ZERO

	var v:Vector2 = current_planet.global_position
	v -= character_body_2d.global_position
	v = v.normalized()

	var target = character_body_2d.global_position + v.rotated(-PI/2.0)
	dynamic_nodes_handle.look_at(target)
	character_body_2d.look_at(target)

	if Input.is_action_just_pressed("player_jump"):
		animated_sprite_2d.animation = Dur.player_jump_animations.pick_random()
		animation_player.play("jump")

	var target_speed:float = 0.0
	if Input.is_action_pressed("player_right"):
		animated_sprite_2d.flip_h = false
		if animation_player.is_playing():
			target_speed = jump_speed
		else:
			target_speed = walk_speed
			animated_sprite_2d.animation = "move"

	elif Input.is_action_pressed("player_left"):
		animated_sprite_2d.flip_h = true
		if animation_player.is_playing():
			target_speed = -jump_speed
		else:
			target_speed = -walk_speed
			animated_sprite_2d.animation = "move"

	else:
		target_speed = 0
		if not animation_player.is_playing():
			animated_sprite_2d.animation = "idle"

	if signf(target_speed) == 0 or animation_player.is_playing():
		speed = move_toward(speed, target_speed, walk_speed * delta * 1.25) # get these values from the planet
	elif signf (speed) + signf(target_speed) == 0:
		speed = move_toward(speed, target_speed, walk_speed * delta * 1.5)
	else:
		speed = move_toward(speed, target_speed, walk_speed * delta * 5.0)

	var forward:Vector2 = character_body_2d.transform.x * speed * delta
	character_body_2d.velocity = forward

	character_body_2d.move_and_slide()

	character_body_2d.velocity = v * Dur.calculate_gravity_acceleration(
		current_planet.planet_radius,
		current_planet.density
	) * delta



	character_body_2d.move_and_slide()

	dynamic_nodes_handle.global_position = character_body_2d.global_position
#endregion

#region Exit
func exit_state(state:PlayerState):
	print("exit_state:", state)
	match state:
		PlayerState.BALLISTIC:
			exit_balistic_state(state)
		PlayerState.PLAYER:
			exit_player_state(state)

func exit_balistic_state(state:PlayerState):
	print("exit_balistic_state")
	rigid_body_2d.process_mode = Node.PROCESS_MODE_DISABLED
	rigid_body_2d.visible = false
	rigid_body_2d.physics_material_override.bounce = bounce
	ballistic_state_over = false

func exit_player_state(state:PlayerState):
	character_body_2d.process_mode = Node.PROCESS_MODE_DISABLED
	character_body_2d.visible = false
	print("exit_player_state")
#endregion

#region Signals
func _on_planet_detector_body_entered(body):
	print("planet entered")
	rigid_body_2d.can_sleep = true
	current_planet = body.get_parent()

func _on_planet_detector_body_exited(body):
	print("planet exited")
	current_planet = null
	rigid_body_2d.can_sleep = false
	rigid_body_2d.physics_material_override.bounce = bounce

func _on_rigid_body_2d_body_entered(body):
	rigid_body_2d.physics_material_override.bounce *= Dur.bounce_decay_factor

func _on_rigid_body_2d_sleeping_state_changed():
	print("sleep state changed")
	if rigid_body_2d.sleeping:
		print("is sleeping")
		timer.start()

func _on_timer_timeout():
	print("ballistic timer out")
	ballistic_state_over = true

func _on_spawn_timer_timeout():
	if aiming:
		spawn_item(get_spawn_position(), calc_velocity())
#endregion

#region Helpers
func get_follow_position():
	match current_state:
		PlayerState.BALLISTIC:
			return rigid_body_2d.global_position
		PlayerState.PLAYER:
			var rise:float = camera_rise
			if Input.is_action_pressed("player_up"):
				rise += look_rise
			var riseVector:Vector2 = -dynamic_nodes_handle.transform.y * rise
			return character_body_2d.global_position + riseVector
	return Vector2.ZERO

func get_spawn_position():
	match current_state:
		PlayerState.BALLISTIC:
			return rigid_body_2d.global_position
		PlayerState.PLAYER:
			return character_body_2d.global_position
	return Vector2.ZERO

func get_follow_rotation():
	return character_body_2d.global_rotation

func spawn_item(p:Vector2, v:Vector2):
		var a:float = PI / 180.0
		var spawnee = SPAWNEE.instantiate()
		v = v.rotated(randf_range(-a, a)) * randf_range(1.0 - a, 1.0 + a)
		spawnee.initial_velocity = v
		add_child(spawnee)
		spawnee.global_position = p

func calc_velocity() -> Vector2:
	return (vec_start - vec_fin) * vectorMultiplier

func calc_position() -> Vector2:
	return vec_fin + (vec_start - vec_fin)
#endregion
