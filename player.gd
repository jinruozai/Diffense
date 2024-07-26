extends CharacterBody3D

@export var speed = 10.0
@export var jump_impulse = 6.0
@export var acceleration = 4.0
@export var mouse_sensitivity = 0.0015
@export var scroll_sensitivity = 1.0
@export var min_arm_length = 2.0
@export var max_arm_length = 10.0

@onready var spring_arm = $SpringArm3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	velocity.y += -gravity * delta
	get_move_input(delta)
	move_and_slide()

func get_move_input(delta):
	var vy = velocity.y
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)
	velocity.y = vy
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_impulse

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
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
