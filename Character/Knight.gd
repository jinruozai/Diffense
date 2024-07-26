extends CharacterBody3D

@export var speed=20.0
@export var acceleration=4.0
@export var jump_speed=8.0
@export var mouse_sensitivity=0.0015
@export var scroll_sensitivity = 1.0
@export var rotation_speed=12.0
@export var min_arm_length = 10.0
@export var max_arm_length = 30.0

@onready var spring_arm=$SpringArm3D
@onready var model=$Rig
@onready var anim_tree=$AnimationTree
@onready var anim_state=$AnimationTree.get("parameters/playback")

var gravity=ProjectSettings.get_setting("physics/3d/default_gravity")
var jumping=false

func _physics_process(delta):
	velocity.y += -gravity * delta
	get_move_input(delta)
	move_and_slide()
	
func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)
	if input.length()>0.1:
		model.basis=Basis.looking_at(dir)
	var vl = velocity * model.transform.basis
	anim_tree.set("parameters/IWR/blend_position", Vector2(vl.x, -vl.z) / speed)
	print(Vector2(vl.x, -vl.z) / speed)
	velocity.y = vy

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90, 30)
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity
		print("拖拽：", spring_arm.rotation.y)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			spring_arm.spring_length = clamp(spring_arm.spring_length - scroll_sensitivity, min_arm_length, max_arm_length)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			spring_arm.spring_length = clamp(spring_arm.spring_length + scroll_sensitivity, min_arm_length, max_arm_length)
	if event is InputEventPanGesture:
		spring_arm.spring_length = clamp(spring_arm.spring_length + event.delta.y * scroll_sensitivity * 0.01, min_arm_length, max_arm_length)
