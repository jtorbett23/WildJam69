extends Node3D

@onready var player : Player = $Player

func _ready() -> void:
	Camera.enabled = false

func post_fade() -> void:
	player.enable()

func _unhandled_input(event : InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		player.toggle_enabled()
		SceneManager.change_scene(self, MainMenu)