extends Node

@export var player_scene:PackedScene
@export var mouse_sensitivity=0.0015
@export var scroll_sensitivity = 1.0
@export var min_arm_length = 5.0
@export var max_arm_length = 50.0
@export var interact_dis: float = 2.0  # 检查的距离

@onready var hud=$HUD
@onready var spring_arm=$SpringArm3D
var interact_target:Node
var character:Node

func _ready():
	if not player_scene:
		push_error("no player scene")
		return
	character=player_scene.instantiate()
	add_child(character)
	character.add_to_group("player")
	character.connect("interact_target_chged",noti_interact_tag_chged)
	hud.link_target(character,spring_arm)
	set_physics_process(true)

func _physics_process(delta):
	var forward_direction = -character.global_transform.basis.z.normalized()
	spring_arm.global_transform.origin = character.global_transform.origin+Vector3(0,2,0)

func _unhandled_input(event):
	contol_camera(event)

func contol_camera(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90, 30)
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			spring_arm.spring_length = clamp(spring_arm.spring_length - scroll_sensitivity, min_arm_length, max_arm_length)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			spring_arm.spring_length = clamp(spring_arm.spring_length + scroll_sensitivity, min_arm_length, max_arm_length)
	if event is InputEventPanGesture:
		spring_arm.spring_length = clamp(spring_arm.spring_length + event.delta.y * scroll_sensitivity * 0.01, min_arm_length, max_arm_length)
		
func noti_interact_tag_chged(body):
	if interact_target:
		if interact_target==body:
			return
		interact_target.emit_signal("focus", false)
	interact_target=body
	if interact_target:
		interact_target.emit_signal("focus", true)
