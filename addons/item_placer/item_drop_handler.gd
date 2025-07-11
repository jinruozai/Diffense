@tool
extends Control

signal item_dropped(item_resource: ItemResource, world_position: Vector3)

func _can_drop_data(position: Vector2, data) -> bool:
	if data.has("files"):
		for file in data.files:
			if file.ends_with(".res"):
				var resource = load(file)
				if resource is ItemResource:
					return true
	return false

func _drop_data(position: Vector2, data):
	if data.has("files"):
		for file in data.files:
			if file.ends_with(".res"):
				var resource = load(file)
				if resource is ItemResource:
					var world_pos = _get_world_position_from_screen(position)
					item_dropped.emit(resource, world_pos)

func _get_world_position_from_screen(screen_pos: Vector2) -> Vector3:
	# 获取当前3D视口
	var viewport = EditorInterface.get_editor_main_screen().get_viewport()
	var camera = viewport.get_camera_3d()
	
	if camera:
		# 从屏幕位置投射到3D世界
		var from = camera.project_ray_origin(screen_pos)
		var to = from + camera.project_ray_normal(screen_pos) * 1000
		
		# 进行射线检测
		var space_state = camera.get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)
		
		if result:
			return result.position
		else:
			# 如果没有碰撞，放在摄像机前方
			return from + camera.project_ray_normal(screen_pos) * 10
	
	return Vector3.ZERO 