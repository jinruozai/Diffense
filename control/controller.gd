extends Node

@export var character:Node
@export var mouse_sensitivity=0.0015
@export var scroll_sensitivity = 1.0
@export var min_arm_length = 5.0
@export var max_arm_length = 50.0

@onready var spring_arm=$SpringArm3D

func _physics_process(delta):
	if not character:
		return
	spring_arm.global_transform.origin = character.global_transform.origin+Vector3(0,2,0)
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	character.move(delta,dir)
	print(spring_arm.spring_length)

func _unhandled_input(event):
	contol_camera(event)
	if character:
		if event.is_action_pressed("jump"):
			character.jump()
		if event.is_action_pressed("attack"):
			character.attack()

func contol_camera(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90, 30)
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			spring_arm.spring_length = clamp(spring_arm.spring_length - scroll_sensitivity, min_arm_length, max_arm_length)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			spring_arm.spring_length = clamp(spring_arm.spring_length + scroll_sensitivity, min_arm_length, max_arm_length)
	if event is InputEventPanGesture:
		spring_arm.spring_length = clamp(spring_arm.spring_length + event.delta.y * scroll_sensitivity * 0.01, min_arm_length, max_arm_length)
