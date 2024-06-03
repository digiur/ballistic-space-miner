extends Node

signal late_process

func _process(delta):
	late_process.emit()
