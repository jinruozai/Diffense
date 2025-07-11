@tool
class_name Entity_Build
extends Entity_Base

func on_pickup():
	_on_focus(0)
	
func on_putdown():
	pass

func get_canbe_actions():
	var actions=[]
	if not item_collision:
		return actions
	actions.append("pickup")
	return actions
