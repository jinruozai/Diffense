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
	"flip": {
		"text": "翻牌",
		"btn":1
	},
	"discard": {
		"text": "出牌",
		"btn":1
	}
}

func get_action_def(s):
	var action = ACTIONS.get(s)
	if action:
		return action
	return null
