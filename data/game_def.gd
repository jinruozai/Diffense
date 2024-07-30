extends Node

const ACTIONS = {
	"jump": {
		"text": "跳",
		"btn":3
	},
	"pickup": {
		"text": "拿起",
		"btn":2
	},
	"putdown": {
		"text": "放下",
		"btn":2
	},
	"interact": {
		"text": "交互",
		"btn":1
	},
	"attack": {
		"text": "攻击",
		"btn":0
	}
}

func get_action_def(name):
	var action = ACTIONS.get(name)
	if action:
		return action
	return null
