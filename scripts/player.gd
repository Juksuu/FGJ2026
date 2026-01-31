extends CharacterBody3D

@export var m_yaw: float = 0.022
@export var sensitivity: float = 1
@export var walk_speed: float = 5

var yaw: float = 0
var pitch: float = 0
var rotation_speed: float = 0.03


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if pitch > PI / 2:
		pitch = PI / 2
	if pitch < -PI / 2:
		pitch = -PI / 2

	$Yaw.rotation.y = yaw
	$Yaw/Pitch.rotation.x = pitch

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw += -event.relative.x * m_yaw * sensitivity * .1
		pitch += -event.relative.y * m_yaw * sensitivity * .1

func _physics_process(delta: float) -> void:
	var move = Vector3(
		Input.get_action_strength("strafe_right") - Input.get_action_strength("strafe_left"),
		0,
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)
	move = move.normalized().rotated(Vector3.UP, yaw)

	velocity.x = move.x * walk_speed
	velocity.z = move.z * walk_speed

	move_and_slide()

func set_initial_look_direction(direction: Globals.ROOM_SIDE) -> void:
	var rotation_offset = PI / 2 if direction > 1 else 0.0
	yaw = direction * PI - rotation_offset
