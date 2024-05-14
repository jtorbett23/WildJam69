extends CharacterBody3D

@export var speed = 4.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	velocity.y -= gravity * delta
	get_input()
	move_and_slide()


func get_input():
	var vy = velocity.y
	velocity = Vector3.ZERO
	velocity.x += Input.get_axis("ui_left", "ui_right") * speed
	velocity.z += Input.get_axis("ui_up", "ui_down") * speed
	velocity.y = vy
