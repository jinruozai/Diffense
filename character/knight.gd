extends CharacterBody3D

@export var speed=20.0
@export var rotation_speed=20.0
@export var acceleration=10.0
@export var jump_speed=40

@onready var model=$Rig
@onready var anim_tree=$AnimationTree
@onready var anim_state=$AnimationTree.get("parameters/playback")

var gravity=ProjectSettings.get_setting("physics/3d/default_gravity")
var is_jumping=0
var input_move:Vector3
var attacks=[
	"1H_Melee_Attack_Slice_Diagonal",
	"1H_Melee_Attack_Slice_Horizontal",
	"1H_Melee_Attack_Chop"
]

func _physics_process(delta):
	velocity.y += -gravity * delta*6.0
	velocity=Vector3(input_move.x,velocity.y+input_move.y,input_move.z)
	if input_move.x!=0 or input_move.z!=0:
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * rotation_speed)
	input_move=Vector3.ZERO
	move_and_slide()
	var sp=Vector2(velocity.x,velocity.z).length()/speed
	anim_tree.set("parameters/IWR/blend_position",sp)
	set_jump_state(0 if is_on_floor() else 2 if not is_jumping else 1)
	
func move(delta,dir:Vector3):
	var ly=input_move.y
	input_move = lerp(velocity, dir * speed, acceleration * delta)
	input_move.y=0
	input_move.y=ly

func jump():
	if not is_jumping and is_on_floor():
		input_move.y=jump_speed

func attack():
	if is_jumping>0:
		return
	anim_state.travel(attacks.pick_random())

func set_jump_state(state):
	if is_jumping==state:
		return
	is_jumping=state
	if is_jumping==2:
		anim_state.travel("Jump_Idel")
		anim_tree.set("parameters/conditions/grounded",false)
		return
	anim_tree.set("parameters/conditions/jumping",is_jumping)
	anim_tree.set("parameters/conditions/grounded",!is_jumping)

