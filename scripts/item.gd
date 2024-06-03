extends Node2D

@export var damp_decay_velocity:float = 1.0

@export var initial_velocity: = Vector2.ZERO

@onready var sleep_time: = %SleepTime as Timer
@onready var item_body: = %ItemBody as RigidBody2D

var planetside:bool = false
var lifetime:float = 0.0

func _ready():
	item_body.linear_velocity = initial_velocity

func _physics_process(delta:float):
	lifetime += delta
	if planetside:
		item_body.linear_damp += damp_decay_velocity * delta

func _on_item_body_body_entered(_body):
	item_body.physics_material_override.bounce *= Global.bounce_decay_factor
	item_body.can_sleep = true
	planetside = true

func _on_planet_detector_body_exited(_body):
	item_body.linear_damp = 0.0
	item_body.can_sleep = false
	planetside = false

func _on_sector_detector_area_exited(_area):
	if not is_queued_for_deletion():
		#print("item exited sector")
		free_me()

func _on_item_body_sleeping_state_changed():
	if item_body.sleeping:
		sleep_time.start()

func _on_sleep_time_timeout():
	if not is_queued_for_deletion():
		#print("item timed out in its sleep")
		free_me()

func free_me():
	if not is_queued_for_deletion():
		#print("alive for %.3f seconds" % lifetime)
		queue_free()
