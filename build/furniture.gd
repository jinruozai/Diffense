extends Node3D

var mat_highlight=preload("res://shader/interact_highlight.material")
signal focus(b)
var mesh:MeshInstance3D

func _ready():
	check_default_mesh()
	focus.connect(_on_focus)

func _on_focus(b):
	print(name)
	mesh.material_overlay=mat_highlight if b else null

func check_default_mesh():
	if mesh:
		return
	for sub in get_children():
		if sub is MeshInstance3D:
			mesh=sub
			return
