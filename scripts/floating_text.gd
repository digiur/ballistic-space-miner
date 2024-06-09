extends Node2D

var my_text:String = "floating text"
var animation_speed:float = 1.0
var float_mode:String = "float"
var color_mode:String = "green"

@onready var position_animation_player: = %PositionAnimationPlayer as AnimationPlayer
@onready var color_animation_player: = %ColorAnimationPlayer as AnimationPlayer
@onready var label: = %Label as Label

func _ready():

	label.text = my_text

	print(color_mode)

	position_animation_player.play(float_mode)
	position_animation_player.speed_scale = animation_speed

	color_animation_player.play(color_mode)
	color_animation_player.speed_scale = animation_speed

	await position_animation_player.animation_finished

	queue_free()
