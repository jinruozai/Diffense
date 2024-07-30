extends Control

@onready var target_icon=$HBoxContainer/Icon
@onready var target_name=$HBoxContainer/Name

var interact_target:GCharacter

func link_target(tag):
	if interact_target==tag:
		return
	interact_target=tag
	if interact_target:
		interact_target.interact_target_chged.connect(noti_interact_tag_chged)

func noti_interact_tag_chged(tag):
	if not tag:
		visible=false
		return
	target_name.text=tag.name
	visible=true
