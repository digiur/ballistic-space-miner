extends Node2D

@export var vectorMultiplier:float = 1.0

@onready var line_2d = %Line2D
@onready var timer = %Timer

var vec_start:Vector2 = Vector2.ZERO
var vec_fin:Vector2 = Vector2.ZERO
var clicking:bool = false

const SPAWNEE:PackedScene = preload("res://scenes/item.tscn")

var positions:Array[Vector2] = []
var velocities:Array[Vector2] = []

func _process(_delta : float):
	if Input.is_action_just_pressed("clear_spawners"):
		positions.clear()
		velocities.clear()

	if Input.is_action_just_pressed("click"):
		clicking = true
		vec_start = get_global_mouse_position()
		vec_fin = vec_start
		line_2d.points[0] = vec_start

	if Input.is_action_pressed("click"):
		clicking = true
		vec_fin = get_global_mouse_position()
		line_2d.points[1] = vec_fin

	if Input.is_action_just_released("click"):
		clicking = false
		positions.append(calc_position())
		velocities.append(calc_velocity())
		line_2d.points[0] = Vector2.ZERO
		line_2d.points[1] = Vector2.ZERO

func spawn_item(p:Vector2, v:Vector2):
		var a:float = PI / 180.0
		var spawnee:RigidBody2D = SPAWNEE.instantiate() as RigidBody2D
		v = v.rotated(randf_range(-a, a)) * randf_range(1.0 - a, 1.0 + a)
		spawnee.linear_velocity = v
		spawnee.position = p
		add_child(spawnee)

func _on_timer_timeout():
	if clicking:
		spawn_item(calc_position(), calc_velocity())

	for i:int in positions.size():
		spawn_item(positions[i], velocities[i])

func calc_velocity() -> Vector2:
	return (vec_start - vec_fin) * vectorMultiplier

func calc_position() -> Vector2:
	return vec_fin + (vec_start - vec_fin)
