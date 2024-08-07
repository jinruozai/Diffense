@tool
class_name Entity_Base
extends Node3D

signal focus(b)

@export var res_item:Build_Item:set=set_item_res
@onready var mat_highlight=preload("res://shader/interact_highlight.material")

var item_scene:Node3D
var item_mesh:MeshInstance3D
var item_collision:CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready():
	update_item()
	focus.connect(_on_focus)

func set_item_res(res):
	print("=set res")
	res_item=res
	update_item()
	
func get_canbe_actions():
	return []

func get_aabb() -> AABB:
	if not item_mesh:
		return AABB()
	return item_mesh.mesh.get_aabb()

func _on_focus(b):
	if item_mesh:
		item_mesh.material_overlay=mat_highlight if b else null

func update_item():
	# Remove the existing item scene if it exists
	if item_scene:
		item_mesh=null
		item_collision=null
		item_scene.queue_free()
	# Instantiate the new item scene if res_item is valid
	prints("scene",res_item.scene)
	if res_item and res_item.scene:
		item_scene = res_item.scene.instantiate()
		add_child(item_scene)
		print(item_scene.global_position)
		check_default_mesh(item_scene)

func check_default_mesh(pnode,b=0):
	if not pnode:
		return 0
	for sub in pnode.get_children(true):
		if not item_mesh:
			if sub is MeshInstance3D:
				item_mesh=sub
		if not item_collision:
			if sub is CollisionShape3D:
				item_collision=sub
		if item_mesh and item_collision:
			return 1
		if check_default_mesh(sub,b):
			return 1
	return 0

