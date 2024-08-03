extends GFurniture

var orb_packsecne=preload("res://orb/orb.tscn")
@onready var orb_pt=$Orb_Pt

func _on_timer_timeout():
	# 创建子弹实例
	var orb_instance=orb_packsecne.instantiate()
	get_parent().add_child(orb_instance)
	orb_instance.global_transform = orb_pt.global_transform
	var forward_direction = -global_transform.basis.z  # Z轴负方向为前方
