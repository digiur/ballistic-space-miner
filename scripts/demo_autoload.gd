extends Node

const SAMPLE_TEXT:String = "Welcome. This is the beginning of a journey. through the outer reaches of the galaxy. The cosmos can be unforgiving. but with the right skills. survival and success are within reach. Today's task is simple yet crucial. mastering the art of navigating through gravity wells. and launching resources between planets. Take a moment to look around. Absorb the beauty of the universe. the stars. the planets. and the endless possibilities that await. Each celestial body has its own gravitational pull. and mastering this will be key to success. First, let's start with something fundamental. jumping between gravity wells. See that small moon orbiting the planet. It's the first destination. Engage the thrusters lightly. feel the tug of the planet's gravity. and aim for the moon's gravity well. The onboard computer will assist with trajectory calculations. Remember. speed and angle are crucial. Ready?. Initiate the jump. Feel the shift?. That's the moon’s gravity taking over. Beautiful. isn’t it?. This is the first successful interplanetary jump. Now, let's move on to resource launching. There is a crate of supplies that needs to be sent to a base on the neighboring planet. This isn’t just about brute force; it’s about precision. Align the launcher with the planet’s orbit, calculate the escape velocity, and let the crate fly. Too slow, and it will fall back to the moon. Too fast, and it will drift into the void. Launch now. Watch as the crate sails through space, gracefully caught by the planet’s gravity well. Perfect. Each successful launch and jump brings us one step closer to mastering the stars. Out here, every move counts, every decision matters. The gravity wells are allies, but they can also be foes if not handled carefully. Use them wisely, and the galaxy will become a playground. Excellent work. These are the first steps in a journey that leads across the stars. Remember, the cosmos is vast and full of challenges, but with skill and determination, there's nothing that can't be achieved. Now, prepare for the next mission. Adventure awaits."
const SAMPLE_TEXT_SHORT:String = "Welcome. This is the beginning of a journey. through the outer reaches of the galaxy. The cosmos can be unforgiving. but with the right skills. survival and success are within reach"

func _ready():
	Bus.speech_spoken.connect(handle_speech_signal)

func _input(event:InputEvent):
	if event.is_action_pressed("get_dinner_idea"):
		Dur.roll_food()

	if event.is_action_pressed("speak"):
		TTS.speak(SAMPLE_TEXT_SHORT, "demo speech")

func handle_speech_signal(id:String, event:DisplayServer.TTSUtteranceEvent, voice_id:String, text:String, boundray:int):
	if id == "demo speech":
		print("id: ", id, " | event: ", event, " | text: ", text, " | boundray: ", boundray, " | text: ", text, " | voice_id: ", voice_id)
