@tool
class_name Entity_Mahjong
extends Entity_Build

var marker_orb:Node3D
var animation_player:AnimationPlayer
var is_flip_up:bool=false
var card_mesh:Mesh

func get_canbe_actions():
	var actions=super.get_canbe_actions()
	print(actions)
	if is_flip_up:
		actions.append("discard")
	else:
		actions.append("flip")
	return actions

func on_flip():
	is_flip_up=not is_flip_up;
	update_card_texture()
	if animation_player:
		animation_player.play("Flip_Up" if is_flip_up else "Flip_Down")

func on_discard():
	queue_free()
	
func update_item():
	super.update_item()
	animation_player=null
	marker_orb=null
	if item_scene:
		animation_player=item_scene.get_node("AnimationPlayer")
		marker_orb=item_scene.get_node("Marker_Orb")
		update_card_texture()
	
	
func update_card_texture():
	if is_flip_up and card_mesh:
		var mat=card_mesh.surface_get_material(0)
		if not mat.albedo_texture:
			# 更新 card 的材质纹理
			var texture = preload("res://asset/img/mahjong/bamboo_1.png")
			mat.albedo_texture = texture

func _on_timer_timeout():
	if not res_item or not is_flip_up:
		return
	# 创建子弹实例
	var orb_instance=res_item.default_skill.orb_packed_scene.instantiate()
	get_tree().root.add_child(orb_instance)
	orb_instance.global_transform = marker_orb.global_transform
