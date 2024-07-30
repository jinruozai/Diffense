extends Control

var ctrl_character:GCharacter

func link_target(tag):
	ctrl_character=tag
	ctrl_character.connect("available_actions_chged",noti_available_actions_chged)

func noti_available_actions_chged(actions):
	var action
	var pbtn:Button
	var szno=[0,1,2]
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
