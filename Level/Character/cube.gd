extends Node3D


static var id_count : int = 0
@export var id : int

func _ready():
	id = id_count
	id_count += 1
