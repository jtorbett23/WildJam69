extends Control

var fade_in : bool = false
var fade_out : bool = false
var fade_speed : float = 2
@onready var background : ColorRect = $Background

func _ready() -> void:
	fade_in = true

func exit():
	fade_out = true

func _process(delta):
	if(fade_in):
		background.color.a += fade_speed * delta
		if(background.color.a >= 1.0):
			fade_in = false
	if(fade_out):
		background.color.a -= fade_speed * delta
		if(background.color.a <= 0.0):
			fade_out = false
			queue_free()
