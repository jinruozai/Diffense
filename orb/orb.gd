extends Area3D

var cur_target
var velocity
var bullet_speed: float = 10

func _physics_process(delta):
	var direction = -global_transform.basis.z.normalized()
	velocity = direction * bullet_speed
	global_transform.origin += velocity * delta
	
func _on_body_entered(body):
	body.emit_signal("orb_hit_body")
	queue_free()
