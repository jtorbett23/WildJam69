extends Area3D

@export var action_style : String = "breath"
@export var dialog_resource : DialogueResource
@export var dialog_start : String = "start"

var diaglog_balloon_path : String = "res://Dialog/balloon.tscn"

func action(compeletd_care: Dictionary) -> void:
	if compeletd_care[action_style] == true:
		dialog_start = "finish"
	var balloon = load(diaglog_balloon_path).instantiate()
	get_tree().root.add_child(balloon)
	balloon.start(dialog_resource, dialog_start)
	
