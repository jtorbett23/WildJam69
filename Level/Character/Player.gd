extends CharacterBody3D

class_name Player

@export var speed : float = 4.0
@export var rotation_acceleration : float = 10.0
@export var lay_acceleration : float = 2.0
@export var lay_angle : int = 90
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export  var enabled : bool = false
var mouse_sensitivity : float = 0.001
var twist_input : float = 0.0
var pitch_input : float = 0.0
var pitch_min : int = -30
var pitch_max : int = 25
var care_level : int = 0
var care_completed : Dictionary = {
	"breath" : false,
	"clouds" : false,
	"share" : false
}

@onready var speech_text : Label3D = $TwistPivot/PitchPivot/Speech
@onready var twist_pivot : Node3D = $TwistPivot
@onready var pitch_pivot : Node3D = $TwistPivot/PitchPivot
@onready var camera : Camera3D = $TwistPivot/PitchPivot/Camera3D
@onready var mesh : MeshInstance3D = $Mesh/body
@onready var action_finder : Area3D = $Mesh/body/ActionFinder
var intial_rotation : float 
var lay : bool = false
var breath : bool = false
var diaglog_balloon_path : String = "res://Dialog/balloon.tscn"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	intial_rotation = mesh.rotation.y
	Events.dialog_complete.connect(Callable(self, "enable"))

func _physics_process(delta) -> void:
	if enabled and !lay:
		if not is_on_floor():
			velocity.y -= gravity * delta
		get_input()
		
		velocity = velocity * speed
		move_and_slide()

func _process(delta):
	#rotate the player
	if velocity.x != 0 or velocity.z != 0:
		if mesh:
			mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-velocity.x, -velocity.z), delta * rotation_acceleration)

	if lay and camera.rotation.x != lay_angle:
		camera.rotation.x = lerp_angle(camera.rotation.x, lay_angle, delta * lay_acceleration)
	elif !lay and camera.rotation.x != 0:
		camera.rotation.x = lerp_angle(camera.rotation.x, 0, delta * lay_acceleration)
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(pitch_min), deg_to_rad(pitch_max))
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
	velocity.y = clamp(vy, -10, 10)


func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseMotion and enabled:
		# if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = - event.relative.x * mouse_sensitivity
		pitch_input = - event.relative.y * mouse_sensitivity
	elif Input.is_action_just_pressed("interact") and !lay and !breath and enabled:
		var actionables = action_finder.get_overlapping_areas()
		if actionables.size() > 0:
			self.disable()
			actionables[0].action(care_completed)
	elif Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_action_just_pressed("lay") and !breath and enabled:
		lay = !lay
		if lay:
			pitch_min -= 20
			pitch_max -= 20
			camera.set_fov(90)
			var actionables = action_finder.get_overlapping_areas()
			if actionables.size() > 0:
				actionables[0].action(care_completed, "lay")
		else:
			care("clouds")
			camera.set_fov(70)
			pitch_min += 20
			pitch_max += 20
	elif Input.is_action_just_released("breath") and enabled:
		if(!breath):
			breath = true
			Events.start_breathing.emit()

	elif Input.is_action_just_pressed("talk") and enabled:
		self.disable()
		Events.start_talking.emit()

	
func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false

func toggle_enabled() -> void:
	enabled = !enabled

func care(type : String) -> void:
	if !care_completed[type]:
		care_completed[type] = true
		care_level += 1
		update_model(care_level)

func update_model(level : int):
	if level == 1:
		mesh.get_node("tears").hide()
	elif level == 2:
		mesh.get_node("sad").hide()
		mesh.get_node("smile").show()
	elif level == 3:
		mesh.get_node("eyesad").hide()
		mesh.get_node("eyehappy").show()
		mesh.get_node("blush").show()
		get_tree().create_timer(3).timeout.connect(Callable(self, "final_narrator_text"))

func final_narrator_text():
	var dialog_resource : DialogueResource = load("res://Dialog/narrator.dialogue")
	var balloon = load(diaglog_balloon_path).instantiate()
	get_tree().root.add_child(balloon)
	disable()
	balloon.start(dialog_resource, "finish")

func update_text(text):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	enable()
	speech_text.text = text
	speech_text.show()
	care("share")
	get_tree().create_timer(3).timeout.connect(func(): speech_text.hide())
