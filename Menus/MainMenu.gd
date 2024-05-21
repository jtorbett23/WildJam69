extends MenuTurbo

class_name MainMenu

var level_path : String = "res://Level/level.tscn"
var music_path : String = "res://assets/music/menu.wav"

func _ready() -> void:
	AudioManager.play_music(music_path)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	var menu_content : Array[Dictionary] = [{"name": "Start Game", "callback": Callable(self, "start_game")}, {"name":"Settings", "callback": Callable(self, "settings")}, {"name":"Credits", "callback": Callable(self, "credits")}]
	
	if OS.has_feature("windows") or OS.has_feature("macos"):
		menu_content.append({"name": "Exit Game", "callback": Callable(func(): get_tree().quit())})
	self.set_content("Void Checkpoint", menu_content, "By Moshu")	

func start_game() -> void:
	var level = load(level_path).instantiate()
	SceneManager.change_scene(self, level, Callable(level, "post_fade"), true, get_tree().root.get_node("Main"), true)

func close() -> void:
	self.queue_free()

func settings():
	UiManager.add(SettingsMenu.new())

func credits():
	UiManager.add(CreditsMenu.new())
