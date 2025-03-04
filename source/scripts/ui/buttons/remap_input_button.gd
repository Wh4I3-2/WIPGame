extends ButtonPlus

@export var input_prompt : Control

func on_button_up():
	input_prompt.prompt_for_input()
