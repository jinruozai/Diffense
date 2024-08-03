extends StaticBody3D
class_name GFurniture

var mat_highlight=preload("res://shader/interact_highlight.material")
signal focus(b)
var mesh:MeshInstance3D
@onready var collision_shape:CollisionShape3D=$CollisionShape3D

func _ready():
	check_default_mesh()
	focus.connect(_on_focus)

func get_aabb() -> AABB:
	return mesh.get_aabb()

func on_pickup():
	collision_shape.disabled=true
	_on_focus(0)
	
func on_putdown():
	collision_shape.disabled=false

func on_interact():
	pass

func _on_focus(b):
	mesh.material_overlay=mat_highlight if b else null

func check_default_mesh():
	if mesh:
		return
	for sub in get_children():
		if sub is MeshInstance3D:
			mesh=sub
			return
