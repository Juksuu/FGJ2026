extends CharacterBody3D

@export var m_yaw: float = 0.022
@export var sensitivity: float = 1
@export var walk_speed: float = 5
@onready var hud_image = $CanvasLayer/heldItem

var yaw: float = 0
var pitch: float = 0
var rotation_speed: float = 0.03
var held_masks = []
var inv_index = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_held_item()


func _process(_delta: float) -> void:
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

	if Input.is_action_just_pressed("inv_next") or Input.is_action_just_pressed("inv_previous"):
		inv_index += int(event.get_action_strength("inv_next") - event.get_action_strength("inv_previous"))
		if inv_index < 0:
			inv_index = int(held_masks.size())
		if inv_index > held_masks.size():
			inv_index = 0
		print(inv_index)
		update_held_item()
	if Input.is_action_just_pressed("use"):
		wear_mask()
	if Input.is_action_just_pressed("revert"):
		remove_mask()

func _physics_process(_delta: float) -> void:
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

func add_to_inventory(object) -> void:
	print("adding", object)
	held_masks.append(object)

func update_held_item() -> void:
	if inv_index == 0:
		hud_image.set_region_rect(Rect2(1280, 0, 128, 128))
	else:
		if held_masks.size() <= 0:
			pass
		var mask = held_masks[inv_index-1]
		if mask.type == "culling":
			hud_image.set_region_rect(Rect2(1152, 0, 128, 128))
		else:
			hud_image.set_region_rect(Rect2(768, 0, 128, 128))

func wear_mask() -> void:
	if inv_index == 0:
		pass
	var held_mask = held_masks[inv_index-1]
	if held_mask.type == "chroma":
		RenderingServer.global_shader_parameter_set("mask_color", Globals.COLOR_OPTIONS[held_mask.id])

func remove_mask() -> void:
	var held_mask = held_masks[inv_index-1]
	if held_mask.type == "chroma":
		RenderingServer.global_shader_parameter_set("mask_color", Vector4(1,1,1,1))

func cast_mask() -> void:
	pass
