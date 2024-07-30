extends Button

var action_name:String
var key_name:String

func _ready():
	var events = InputMap.action_get_events(name)
	for sub in events:
		if sub is InputEventKey:
			key_name=sub.as_text_physical_keycode()
			break

func set_action(s,action,character):
	if action_name!=s:
		action_name=s
		if key_name:	
			text=action["text"]+"【"+key_name+"】"
		else:
			text=action["text"]
		pressed.connect(Callable(character,s))
	visible=true

func _unhandled_input(event):
	if not visible:
		return
	if event.is_action_pressed(name):
		pressed.emit()

