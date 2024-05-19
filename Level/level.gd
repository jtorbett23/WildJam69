extends Node3D

var breath_scene = "res://Level/breath.tscn"
var breather : Control 
var music_path : String = "res://assets/music/level.mp3"

@onready var player : Player = $Player
@onready var canvas : CanvasLayer = $CanvasLayer

func _ready() -> void:
	AudioManager.play_music(music_path)
	Camera.enabled = false
	Events.start_breathing.connect(Callable(self,"start_breather"))
	Events.end_breathing.connect(Callable(self,"end_breather"))
	Events.start_talking.connect(Callable(self, "start_talking"))


func post_fade() -> void:
	player.enable()

func _unhandled_input(event : InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		player.toggle_enabled()
		SceneManager.change_scene(self, MainMenu)
	
func start_breather():
	player.disable()
	if !canvas.has_node("Breath"):
		breather = load(breath_scene).instantiate()
		canvas.add_child(breather)


func end_breather():
	if canvas.has_node("Breath"):
		breather.exit()
		AudioManager.play_music(music_path)
		player.care("breath")
		player.enable()
		player.breath = false

func start_talking():
	var popup : PopupTurbo = PopupTurbo.new("What's on your mind? (Enter to submit)",
	PopupTurbo.INPUT, Callable())
	popup.input_text.connect(Callable(self, "handle_input_text"))
	canvas.add_child(popup)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func handle_input_text(text):
	if text != "":
		player.update_text(text)
