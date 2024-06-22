class_name TTS extends Node

const delimiter:String = "."

class SpeechRequest:
	var _text:String
	var _fragments:Array[String]
	var _chosen_voice_ids:Array[String]
	var _starting_utterance_id = -1
	var _priority:int = -1

static var _voices:Array[Dictionary] = DisplayServer.tts_get_voices()
static var _request_id_by_utterance_id:Dictionary = {}
static var _requests_by_id:Dictionary = {}
static var _current_request_id:String = ""
static var _utterance_id:int = 0
static var _last_used_voice_id:String

static func _static_init():
	DisplayServer.tts_set_utterance_callback(DisplayServer.TTS_UTTERANCE_STARTED, TTS._utterance_started)
	DisplayServer.tts_set_utterance_callback(DisplayServer.TTS_UTTERANCE_ENDED, TTS._utterance_ended)
	DisplayServer.tts_set_utterance_callback(DisplayServer.TTS_UTTERANCE_CANCELED, TTS._utterance_canceled)
	DisplayServer.tts_set_utterance_callback(DisplayServer.TTS_UTTERANCE_BOUNDARY, TTS._utterance_boundary)

	if _voices.size() == 0:
		while _voices.size() == 0:
			print("ERROR: No Voices Available. Retry")
			_voices = DisplayServer.tts_get_voices()
	else:
		print("Got voices first try")

static func speak(request_text:String, request_id:String, priority:int = 0):

	print("speaking request: ", request_id)

	if  request_text == "":
		print("No text in request. Ignoring.")
		return

	#if _current_request_id != "":
		#print("Server currently speaking.")
		#if priority <= _requests_by_id[_current_request_id]._priority:
			#print("Ignoring new speech request with lower priority.")
			#return

	#var interupt:bool = false
	#if DisplayServer.tts_is_speaking():
		#print("Stop current speech for higher priority request.")
		#DisplayServer.tts_stop()
		#interupt = true

	request_text = request_text.strip_edges()

	var new_request: = SpeechRequest.new()
	new_request._text = request_text
	new_request._fragments.assign(request_text.split(delimiter, false))
	new_request._chosen_voice_ids = []
	new_request._priority = priority
	new_request._starting_utterance_id = _utterance_id

	new_request._fragments.assign(new_request._fragments.map(func(i:String):return i.strip_edges()))

	_current_request_id = request_id
	_requests_by_id[_current_request_id] = new_request

	for fragment in new_request._fragments:
		_queue_text_with_random_voice(fragment)

	_emit_signal(_current_request_id, DisplayServer.TTS_UTTERANCE_STARTED, "", "")

	print("begin speaking: ", _current_request_id)

static func _queue_text_with_random_voice(text:String):
	var new_voice_id = _last_used_voice_id
	while new_voice_id == _last_used_voice_id:
		new_voice_id = _voices[randi() % _voices.size()].id

	print("queue_text: id: ", _utterance_id, text)
	#print("with voice: ", new_voice_id)

	DisplayServer.tts_speak(text, new_voice_id, 50, 1.0, 1.0, _utterance_id)

	_requests_by_id[_current_request_id]._chosen_voice_ids.push_back(new_voice_id)
	_request_id_by_utterance_id[_utterance_id] = _current_request_id
	_last_used_voice_id = new_voice_id
	
	_utterance_id += 1

static func _emit_signal(request_id:String, event:DisplayServer.TTSUtteranceEvent, voice:String, text:String, boundary:int=0):
	Bus.speech_spoken.emit(request_id, event, voice, text, boundary)
	
static func _utterance_started(utterance_id:int):
	var request_id:String = _request_id_by_utterance_id[utterance_id]
	var request:SpeechRequest = _requests_by_id[request_id]
	
	var local_index = utterance_id - request._starting_utterance_id
	
	var voice_id:String = request._chosen_voice_ids[local_index]
	var fragment:String = request._fragments[local_index]

	print("utterance_started: ", utterance_id, " | request_id: ", request_id, " | fragment: ", fragment)
	_emit_signal(request_id, DisplayServer.TTS_UTTERANCE_STARTED, voice_id, fragment)

static func _utterance_ended(utterance_id:int):
	var request_id:String = _request_id_by_utterance_id[utterance_id]
	var request:SpeechRequest = _requests_by_id[request_id]

	var local_index = utterance_id - request._starting_utterance_id
	
	var voice_id:String = request._chosen_voice_ids[local_index]
	var fragment:String = request._fragments[local_index]

	print("utterance_ended: ", utterance_id, " | request_id: ", request_id, " | fragment: ", fragment)
	_emit_signal(request_id, DisplayServer.TTS_UTTERANCE_ENDED, voice_id, fragment)
	
	if local_index + 1 == request._fragments.size():
		print("request ended: ", request_id)
		_emit_signal(request_id, DisplayServer.TTS_UTTERANCE_ENDED, "", "")

static func _utterance_canceled(utterance_id:int):
	var request_id:String = _request_id_by_utterance_id[utterance_id]
	var request:SpeechRequest = _requests_by_id[request_id]

	var local_index = utterance_id - request._starting_utterance_id
	
	var voice_id:String = request._chosen_voice_ids[local_index]
	var fragment:String = request._fragments[local_index]

	print("utterance_canceled: ", utterance_id, " | request_id: ", request_id, " | fragment: ", fragment)
	_emit_signal(request_id, DisplayServer.TTS_UTTERANCE_CANCELED, voice_id, fragment)

	if local_index + 1 == request._fragments.size():
		print("request ended: ", request_id)
		_emit_signal(request_id, DisplayServer.TTS_UTTERANCE_ENDED, "", "")

static func _utterance_boundary(boundary:int, utterance_id:int):
	var request_id:String = _request_id_by_utterance_id[utterance_id]
	var request:SpeechRequest = _requests_by_id[request_id]
	
	var local_index = utterance_id - request._starting_utterance_id
	
	var voice_id:String = request._chosen_voice_ids[local_index]
	var fragment:String = request._fragments[local_index]

	#print("_utterance_boundary: ", utterance_id, ",", boundary, " | request_id: ", request_id, " | fragment: ", fragment)
	_emit_signal(request_id, DisplayServer.TTS_UTTERANCE_STARTED, voice_id, fragment, boundary)

	#float_text("bestow " + str(tts_voices.size()) + " voices:",
		#dynamic_nodes_handle.transform, dynamic_nodes_handle.transform.x * 100, 2.0, "lower")
#
	#await get_tree().create_timer(1.5).timeout
	#
	#for voice in tts_voices:
		#float_text("voice:" + voice.name + " id:" + voice.id + " lang:" + voice.language,
			#dynamic_nodes_handle.transform, dynamic_nodes_handle.transform.x * 100, 2.0, "lower")
		#await get_tree().create_timer(0.5).timeout
		#float_text(
			#"make thy will be known: v_id: " + str(new_v_id_index) + " | str_id: " + str(tts_index) + " | str: " + tts_strings[tts_index].strip_edges() + " | v: " + tts_voices[tts_voice_ids_index].id,
			#dynamic_nodes_handle.transform,
			#(dynamic_nodes_handle.transform.x * (100 + (randi() % 20) - 10)) + (dynamic_nodes_handle.transform.y * ((randi() % 10) - 5)),
			#2.0,
			#move_options.pick_random(),
			#color_options.pick_random()
		#)
	#float_text("_ready done",
		#dynamic_nodes_handle.transform, dynamic_nodes_handle.transform.x * 100, 0.5)
#
	#float_text("callback i: " + str(i), dynamic_nodes_handle.transform,
		#dynamic_nodes_handle.transform.x * -150 + dynamic_nodes_handle.transform.y * -25, 15, "float", "yellow")
	#float_text(tts_strings[i], dynamic_nodes_handle.transform, dynamic_nodes_handle.transform.x * -400, 0.5, "raise")
