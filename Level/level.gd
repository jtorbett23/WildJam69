extends Node3D

var breath_scene = "res://Level/breath.tscn"
var breather : Control 
var music_path : String = "res://assets/music/level.mp3"

@onready var player : Player = $Player
@onready var canvas : CanvasLayer = $CanvasLayer

func _ready() -> void:
	AudioManager.play_music(music_path)
	Camera.enabled = false
	Events.toggle_breathing.connect(Callable(self,"toggle_breather"))

func post_fade() -> void:
	player.enable()

func _unhandled_input(event : InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		player.toggle_enabled()
		SceneManager.change_scene(self, MainMenu)
	
func toggle_breather():
	player.toggle_enabled()
	if !canvas.has_node("Breath"):
		breather = load(breath_scene).instantiate()
		canvas.add_child(breather)
	else:
		breather.exit()
		AudioManager.play_music(music_path)
		player.care("breath")


	
