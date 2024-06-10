extends Node2D

@export var damp_decay_velocity:float = 1.0

@export var initial_velocity: = Vector2.ZERO

@export var maxTracerPoints:int = 50

@export var trailColor:Color = Color.WEB_GREEN

@onready var sleep_time: = %SleepTime as Timer
@onready var item_body: = %ItemBody as RigidBody2D

var planetside:bool = false
var lifetime:float = 0.0

var tracerPos:Array[Vector2] = []

func _draw():
	var color:Color = trailColor
	for i:int in range(1, tracerPos.size()):
		color.a = i as float / tracerPos.size() as float
		draw_line(tracerPos[i-1], tracerPos[i], color, -20.0, true)

func _ready():
	item_body.linear_velocity = initial_velocity

func _process(delta:float):
	lifetime += delta

	if planetside:
		item_body.linear_damp += damp_decay_velocity * delta

	tracerPos.push_back(item_body.position)

	if tracerPos.size() > maxTracerPoints:
		tracerPos.pop_front()

	queue_redraw()

func _on_item_body_body_entered(_body):
	item_body.physics_material_override.bounce *= Dur.bounce_decay_factor
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
