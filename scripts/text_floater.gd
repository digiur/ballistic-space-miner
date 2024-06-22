extends Node

const FLOATING_TEXT:PackedScene = preload("res://scenes/floating_text.tscn")

func float_text(text:String, transform:Transform2D, offset:Vector2, speed:float = 1.0, float_mode:String = "float", color_mode:String = "green"):
	var floating_text = FLOATING_TEXT.instantiate()
	floating_text.my_text = text.strip_edges()
	floating_text.global_transform = transform
	floating_text.position += offset
	floating_text.animation_speed = speed
	floating_text.float_mode = float_mode
	floating_text.color_mode = color_mode
	add_child(floating_text)
