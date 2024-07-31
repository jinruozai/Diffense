extends Control

var ctrl_character:GCharacter
var btn_no_list:Array[int]

func _ready():
	var count=get_child_count()
	for i in range(count):
		btn_no_list.append(i)

func link_target(tag):
	ctrl_character=tag
	ctrl_character.connect("available_actions_chged",noti_available_actions_chged)

func noti_available_actions_chged(actions):
	var action
	var pbtn:Button
	var szno=btn_no_list.duplicate()
	var btnno:int
	for s in actions:
		action=Game_Def.get_action_def(s)
		if action==null:
			continue
		btnno=action["btn"]
		pbtn=get_child(btnno)
		if pbtn!=null:
			pbtn.set_action(s,action,ctrl_character)
		szno.erase(btnno)
	if szno.size()>0:
		for no in szno:
			pbtn=get_child(no)
			if pbtn==null:
				continue
			pbtn.visible=false
