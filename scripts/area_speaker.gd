extends Area2D

@export var speech_priority:int = 0
@export_multiline var text:String = ""

var _speaking = false

func _ready():
	Bus.speech_spoken.connect(handle_speech_signal, 1)

func _on_body_entered(body):
	if not _speaking and text != "":
		_speaking = true
		TTS.speak(text, name, speech_priority)
		#print("player entered! speech started!")
	else:
		#print("player entered! speech SKIPPED!")
		pass

func handle_speech_signal(external_id:String, event:DisplayServer.TTSUtteranceEvent, voice_id:String, text:String, boundray:int):
	if external_id != name:
		return

	match event:
		DisplayServer.TTS_UTTERANCE_STARTED:
			_handle_started_event(voice_id, text)
		DisplayServer.TTS_UTTERANCE_ENDED:
			_handle_ended_event(voice_id, text)
		DisplayServer.TTS_UTTERANCE_CANCELED:
			_handle_canceled_event(voice_id, text)
		DisplayServer.TTS_UTTERANCE_BOUNDARY:
			_handle_boundary_event(voice_id, text, boundray)

func _handle_started_event(voice_id:String, text:String):
	#print("phrase started: ", " | text: ", text, " | voice_id: ", voice_id)
	pass

func _handle_ended_event(voice_id:String, text:String):
	if text == "" and voice_id == "":
		#print("speech ended!")
		_speaking = false
	else:
		#print("phrase ended: ", " | text: ", text, " | voice_id: ", voice_id)
		pass

func _handle_canceled_event(voice_id:String, text:String):
	#print("speech canceled! text: ", text, " | voice_id: ", voice_id)
	_speaking = false

func _handle_boundary_event(voice_id:String, text:String, boundray:int):
	#print("Speech in process: | boundray: ", boundray, " | text: ", text, " | voice_id: ", voice_id)
	pass
