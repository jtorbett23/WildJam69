extends Control

var fade_in : bool = false
var fade_out : bool = false
var fade_speed : float = 2
var leaf_speed : float = 100
@onready var background : ColorRect = $Background
@onready var leaf : Control = $Background/leaf
var breathing : bool = false
var falling : bool = false
var breath_time : float = 3.5294
var breath_timer : float = 0.0
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var music_path : String = "res://assets/music/breath.wav"

func _ready() -> void:
	fade_in = true

func exit() -> void:
	fade_out = true

func play_music() -> void:
	AudioManager.play_music(music_path)

func _process(delta):
	if(fade_in):
		background.color.a += fade_speed * delta
		leaf.modulate.a += fade_speed * delta
		if(background.color.a >= 1.0):
			fade_in = false
			breathing = true
			play_music()
	if(fade_out):
		background.color.a -= fade_speed * delta
		leaf.modulate.a -= fade_speed * delta
		if(background.color.a <= 0.0):
			fade_out = false
			Events.end_breathing.emit()
			queue_free()
	
	if breathing:
		breath_timer += delta
		var angle_change = 0
		if(breath_timer >= breath_time):
			breath_timer = 0
			falling = !falling
		if falling:
			leaf.position.y += delta * leaf_speed
			angle_change = delta * rng.randf_range(-1,1)
		else:
			leaf.position.y -= delta * leaf_speed
			angle_change = -delta * rng.randf_range(-1,1)
		leaf.rotation = lerp(leaf.rotation, leaf.rotation + angle_change, 0.5)
		leaf.rotation = clamp(leaf.rotation, -30, 30)

func _unhandled_input(event : InputEvent) -> void:
	if Input.is_action_just_released("breath"):
		if !fade_in and !fade_out:
			fade_out = true
