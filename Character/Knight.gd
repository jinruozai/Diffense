extends CharacterBody3D

@export var speed=20.0
@export var roto_speed=10.0
@export var acceleration=4.0
@export var jump_speed=40
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
var last_floor=true
var attacks=[
	"1H_Melee_Attack_Slice_Diagonal",
	"1H_Melee_Attack_Slice_Horizontal",
	"1H_Melee_Attack_Chop"
]

func _physics_process(delta):
	velocity.y += -gravity * delta*6.0
	get_move_input(delta)
	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y=jump_speed
		jumping=true
		anim_tree.set("parameters/conditions/jumping",true)
		anim_tree.set("parameters/conditions/grounded",false)
	if is_on_floor() and not last_floor:
		jumping=false
		anim_tree.set("parameters/conditions/jumping",false)
		anim_tree.set("parameters/conditions/grounded",true)
	if not is_on_floor() and not jumping:
		anim_state.travel("Jump_Idel")
		anim_tree.set("parameters/conditions/grounded",false)
	last_floor=is_on_floor()
	
func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)
	if input.length()>0.1:
		model.rotation.y = lerp_angle(model.rotation.y, atan2(-dir.x, -dir.z), delta * roto_speed)
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
	if event.is_action_pressed("attack"):
		anim_state.travel(attacks.pick_random())
