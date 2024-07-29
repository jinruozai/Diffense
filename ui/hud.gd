extends CanvasLayer

@export var controller:Node
@onready var joy_stick=$JoyStick
@onready var interact_target_name=$Target_Name

signal interact_target_chged(p)

func get_joy_stick():
	return joy_stick

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_interact_target_chged(p):
	interact_target_name.text=p.name if p else ""
