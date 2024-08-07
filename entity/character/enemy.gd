extends CharacterBody3D

signal orb_hit_body

@onready var nav_agent:NavigationAgent3D=$NavigationAgent3D
var explosion_scene : PackedScene=preload("res://vfx/explosion.tscn")
var move_speed=3.0
var tag_player:Node3D

func _physics_process(delta):
	update_target_pos()
	if nav_agent.is_navigation_finished():
		return
	var next_lotation=nav_agent.get_next_path_position()
	var new_velocity=global_position.direction_to(next_lotation)*move_speed
	if nav_agent.avoidance_enabled:
		nav_agent.velocity=new_velocity
	else:
		_on_navigation_agent_3d_velocity_computed(new_velocity)

func update_target_pos():
	var szplayer=get_tree().get_nodes_in_group("player")
	if szplayer.size()>0:
		if szplayer.size()==1:
			tag_player=szplayer[0]
		else:
			#选择离自己更近的玩家
			var mindis=INF
			var dis:float=0.0
			for p in szplayer:
				dis=global_position.distance_squared_to(p.global_position)
				if dis<mindis:
					tag_player=p
	if tag_player:
		nav_agent.target_position=tag_player.global_position

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity=safe_velocity
	move_and_slide()

func _on_orb_hit_body():
	var explosion_instance=explosion_scene.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	queue_free()



