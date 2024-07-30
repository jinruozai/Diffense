extends CharacterBody3D
class_name GCharacter

@export var speed=12.0
@export var rotation_speed=20.0
@export var acceleration=10.0
@export var jump_speed=40

@onready var model=$Rig
@onready var anim_tree=$AnimationTree
@onready var anim_state=$AnimationTree.get("parameters/playback")
@onready var interact_area=$Area3D

var gravity=ProjectSettings.get_setting("physics/3d/default_gravity")
var is_jumping=0
var move_dir:Vector3
var attacks=[
	"1H_Melee_Attack_Slice_Diagonal",
	"1H_Melee_Attack_Slice_Horizontal",
	"1H_Melee_Attack_Chop"
]
#能对目标进行的操作
var ability_tag_map=[
	"pickup",
	"interact"
]

var available_tag_actions=[]

var interact_target:Node
signal interact_target_chged(tag)
signal available_actions_chged(actions)

func _physics_process(delta):
	velocity.y += -gravity * delta*6.0
	var input_move:Vector3=lerp(velocity, move_dir * speed, acceleration * delta)
	if move_dir.y>0:
		input_move.y=jump_speed
	else:
		input_move.y=0
	velocity=Vector3(input_move.x,velocity.y+input_move.y,input_move.z)
	if input_move.x!=0 or input_move.z!=0:
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * rotation_speed)
	move_dir=Vector3.ZERO
	move_and_slide()
	var sp=Vector2(velocity.x,velocity.z).length()/speed
	anim_tree.set("parameters/IWR/blend_position",sp)
	set_jump_state(0 if is_on_floor() else 2 if not is_jumping else 1)

func set_interact_target(tag,b):
	if not tag:
		interact_target=null
	else:
		if b:
			interact_target=tag
		else:
			if tag==interact_target:
				interact_target=null
			else:
				return
	ref_available_actions()
	interact_target_chged.emit(interact_target)
	
func ref_available_actions():
	available_tag_actions=["attack","jump"]
	if interact_target:
		for s in ability_tag_map:
			if interact_target.has_method("on_"+s):
				available_tag_actions.append(s)
	print(available_tag_actions)
	available_actions_chged.emit(available_tag_actions)

func move(dir:Vector3):
	var ly=move_dir.y
	move_dir=dir
	move_dir.y=ly

func jump():
	if not is_jumping and is_on_floor():
		move_dir.y=1.0

func attack():
	if is_jumping>0:
		return
	anim_state.travel(attacks.pick_random())

func pickup():
	print("拾取")

func interact():
	print("交互")

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

func _on_area_3d_body_entered(body):
	set_interact_target(body,true)

func _on_area_3d_body_exited(body):
	set_interact_target(body,false)
