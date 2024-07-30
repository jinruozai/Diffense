extends CanvasLayer

@export var controller:Node
@onready var joy_stick=$JoyStick
@onready var action_ctrl=$ActionCrlPanel
@onready var interact_target_panel=$Interact_Target

signal interact_target_chged(p)

func link_target(character,springarm):
	interact_target_panel.link_target(character)
	joy_stick.link_target(character,springarm)
	action_ctrl.link_target(character)
