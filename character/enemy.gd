extends RigidBody3D

signal orb_hit_body

func _on_orb_hit_body():
	queue_free()
