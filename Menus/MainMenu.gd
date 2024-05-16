extends MenuTurbo

class_name MainMenu

var level_path = "res://level.tscn"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Camera.set_static()
	Camera.enabled = true
	self.set_content("Void Checkpoint", 
	[	{"name": "Start Game", "callback": Callable(self, "start_game")}, 
		{"name":"Settings", "callback": Callable(self, "settings")},
		{"name":"Credits", "callback": Callable(self, "credits")}
		], "By Moshu")	

func start_game() -> void:
	var level = load(level_path).instantiate()
	SceneManager.change_scene(self, level, Callable(level, "post_fade"), true)

func close() -> void:
	self.queue_free()

func settings():
	Camera.add_ui(SettingsMenu.new())

func credits():
	Camera.add_ui(CreditsMenu.new())
