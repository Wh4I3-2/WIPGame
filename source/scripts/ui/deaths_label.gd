extends Label

@export var typewrite_delay : float
@export var typewrite_sound : AudioStream

var final_text = ""
var typewrite_char = 0

func _ready():
	text = ""
	final_text = "You died %d times!" % GameManager.death_count
	if GameManager.death_count == 1:
		final_text = "You died 1 time!"
	
	typewrite()

func typewrite():
	if typewrite_char > len(final_text)-1:
		GameManager.death_count = 0
		return
	text += final_text[typewrite_char]
	typewrite_char += 1
	SoundManager.play_sound(typewrite_sound)
	await get_tree().create_timer(typewrite_delay).timeout
	typewrite()
