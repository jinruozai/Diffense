extends Node

const ACTIONS = {
	"pickup": {
		"text": "拿起",
		"btn":0
	},
	"putdown": {
		"text": "放下",
		"btn":0
	},
	"interact": {
		"text": "交互",
		"btn":1
	},
}

func get_action_def(name):
	var action = ACTIONS.get(name)
	if action:
		return action
	return null
