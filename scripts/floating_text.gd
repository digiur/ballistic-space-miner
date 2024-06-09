extends Node2D

var my_text:String = ""

func _ready():
	%Label.text = my_text
	%AnimationPlayer.play("float")
	await %AnimationPlayer.animation_finished
	#await get_tree().create_timer(10.5).timeout
	queue_free()
