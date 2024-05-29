extends RigidBody2D

@export var damp_decay_velocity:float = 1
@export var bounce_decay_factor:float = 0.95

@onready var sleep_timer:Timer = %SleepTimer as Timer

var planetside:bool = false
var lifetime:float = 0.0

func _physics_process(delta:float):
	lifetime += delta
	if planetside:
		linear_damp += damp_decay_velocity * delta

func _on_body_entered(_body):
	physics_material_override.bounce *= bounce_decay_factor
	planetside = true

func _on_area_2d_body_exited(_body):
	linear_damp = 0.0
	planetside = false

func _on_boundry_detector_area_exited(_area):
	free_me()

func _on_sleeping_state_changed():
	if sleeping:
		sleep_timer.start()

func _on_sleep_timer_timeout():
	free_me()

func free_me():
	if not is_queued_for_deletion():
		print("free item alive for %.3f seconds" % lifetime)
		queue_free()
