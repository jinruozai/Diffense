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
@onready var holder_tag=$Holder

var gravity=ProjectSettings.get_setting("physics/3d/default_gravity")
var is_jumping=0
var move_dir:Vector3

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
	available_tag_actions.clear()
	var phold=holder_tag.get_child(0)
	if phold:
		available_tag_actions.append("putdown")
	else:
		if interact_target:
			if interact_target.has_method("on_pickup"):
				available_tag_actions.append("pickup")
	available_actions_chged.emit(available_tag_actions)

func move(dir:Vector3):
	var ly=move_dir.y
	move_dir=dir
	move_dir.y=ly

func jump():
	if not is_jumping and is_on_floor():
		move_dir.y=1.0

func pickup():
	if not interact_target:
		return
	var aabb=interact_target.get_aabb()
	var maxsize=max(aabb.size.x,aabb.size.z,0.5)
	var holdscale=0.5/maxsize
	holder_tag.scale = Vector3(holdscale, holdscale, holdscale)
	interact_target.on_pickup()
	interact_target.reparent(holder_tag,false)
	interact_target.position=Vector3.ZERO
	interact_target.rotation=Vector3.ZERO
	interact_target=null
	ref_available_actions()

func putdown():
	var phold=holder_tag.get_child(0)
	if not phold:
		return
	var front_position = global_transform.origin -global_transform.basis.z.normalized() * 2.0
	phold.on_putdown()
	phold.reparent(get_parent(),true)
	phold.global_transform.origin=Vector3(int(front_position.x),front_position.y,int(front_position.z))
	var rotation = global_transform.basis.get_euler()
	rotation.y = round(rotation.y / (PI / 2)) * (PI / 2)  # 四舍五入到最近的 90 度 (PI / 2 弧度)
	phold.global_transform.basis=Basis.from_euler(rotation)

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
