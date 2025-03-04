extends ButtonPlus

enum Devices {
	KEYBOARD,
	CONTROLLER
}

@export var device : Devices = Devices.KEYBOARD

func on_button_up():
	InputHelper.reset_all_actions()
	SettingsManager.save_settings()
