extends CharacterBody3D

@export var speed : float = 4.0
@export var rotation_acceleration : float = 10.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity : float = 0.001
var twist_input : float = 0.0
var pitch_input : float = 0.0

@onready var twist_pivot : Node3D = $TwistPivot
@onready var pitch_pivot : Node3D = $TwistPivot/PitchPivot
@onready var mesh : MeshInstance3D = $Mesh
var intial_rotation : float 

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	intial_rotation = mesh.rotation.y

func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	get_input()
	#rotate the player
	if velocity.x != 0 or velocity.z != 0:
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(velocity.x, velocity.z), delta * rotation_acceleration)
	velocity = velocity * speed
	move_and_slide()

	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-30), deg_to_rad(25))
	twist_input = 0.0
	pitch_input = 0.0

func get_input() -> void:
	var vy = velocity.y
	velocity = Vector3.ZERO
	var input_dir : Vector2 = Input.get_vector("left","right","forward", "back")
	var direction : Vector3 = (twist_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x
		velocity.z = direction.z
	velocity.y = vy
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
