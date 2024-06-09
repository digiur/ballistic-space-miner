extends Node2D

var my_text:String = "Default Text"

func _ready():
	$Label.text = my_text
	$AnimationPlayer.play("float_up")
	await $AnimationPlayer.animation_finished
	print("animation done")
	queue_free()
