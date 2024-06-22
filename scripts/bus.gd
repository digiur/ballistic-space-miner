extends Node

signal floating_text

signal speech_spoken(
	id:String,
	event:DisplayServer.TTSUtteranceEvent,
	voice_id:String,
	text:String,
	boundray:int
)
