@tool
extends EditorPlugin

var drop_handler

func _enter_tree():
	# 添加自定义节点类型
	add_custom_type("MapItem", "Node3D", preload("res://global/map_item.gd"), preload("res://icon.svg"))
	
	# 创建拖拽处理器
	drop_handler = preload("res://addons/item_placer/item_drop_handler.gd").new()
	drop_handler.item_dropped.connect(_on_item_dropped)
	
	# 将处理器添加到主编辑器界面
	var main_screen = EditorInterface.get_editor_main_screen()
	if main_screen:
		main_screen.add_child(drop_handler)
		drop_handler.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _exit_tree():
	remove_custom_type("MapItem")
	if drop_handler:
		drop_handler.queue_free()

func _on_item_dropped(item_resource: ItemResource, world_position: Vector3):
	_create_map_item(item_resource, world_position)

func _create_map_item(item_resource: ItemResource, world_position: Vector3):
	var scene_tree = EditorInterface.get_edited_scene_root()
	if not scene_tree:
		print("No active scene to add item to")
		return
	
	# 创建 MapItem 实例
	var map_item_script = preload("res://global/map_item.gd")
	var map_item = Node3D.new()
	map_item.set_script(map_item_script)
	map_item.name = item_resource.item_name if item_resource.item_name != "" else "MapItem"
	
	# 设置资源（这会自动创建模型）
	map_item.item_resource = item_resource
	
	# 设置位置
	map_item.position = world_position
	
	# 添加到场景
	scene_tree.add_child(map_item)
	map_item.owner = scene_tree
	
	# 标记场景为已修改
	EditorInterface.mark_scene_as_unsaved()
	
	print("Created MapItem: ", map_item.name, " at position: ", world_position) 