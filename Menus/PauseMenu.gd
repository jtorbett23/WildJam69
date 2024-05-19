extends MenuTurbo

class_name PauseMenu

var close_callback : Callable

func _init(on_close_callback : Callable = Callable()):
	super()
	self.close_callback = on_close_callback
	background.color.a = 0.5

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.set_content("Pause", 
	[	{"name": "Master Volume", "type": HSliderTurbo, 
		"value": AudioManager.current_master_level, "callback": Callable(AudioManager, "set_master_volume")},
		{"name": "Music Volume", "type": HSliderTurbo, 
		"value": AudioManager.current_music_level, "callback": Callable(AudioManager, "set_music_volume")},
		{"name": "Sound Volume", "type": HSliderTurbo, 
		"value": AudioManager.current_sound_level, "callback": Callable(AudioManager, "set_sound_volume")},
		{"name":"Return to Game", "callback": Callable(self, "close") },
		{"name":"Return to Main Menu", "callback": Callable(self, "main_menu") }])

func close() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if !close_callback.is_null():
		close_callback.call()
	self.queue_free()

func main_menu() -> void:
	SceneManager.change_scene(self.get_parent().get_parent(), MainMenu)



