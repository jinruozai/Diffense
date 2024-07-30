extends TextureRect

@onready var dot=$Dot
var dis_max:float=0.0
var is_draging:bool=false
var ctrl_character:GCharacter
var spring_arm:SpringArm3D

func _ready():
	modulate.a=0.5
	_on_resized()
	set_physics_process(0)
	
func link_target(tag,spring):
	ctrl_character=tag
	spring_arm=spring
	set_physics_process(tag is GCharacter)

func get_move_vector(delta)->Vector2:
	var output:Vector2
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input.x!=0 or input.y!=0:
		output=Vector2(input.x,input.y)
		dot.position=pivot_offset-dot.pivot_offset+output*dis_max
		return output
	if is_draging:
		var locpt=get_global_mouse_position()-global_position-pivot_offset
		var dis=locpt.length()
		if dis<=dis_max:
			dot.position=pivot_offset+locpt-dot.pivot_offset
		else:
			var angle=locpt.angle_to_point(Vector2.ZERO)+PI
			dot.position=pivot_offset+Vector2(cos(angle)*dis_max,sin(angle)*dis_max)-dot.pivot_offset
		output=(dot.position-pivot_offset+dot.pivot_offset)/dis_max
		return output
	dot.position=pivot_offset-dot.pivot_offset
	output=Vector2.ZERO
	return output

func _physics_process(delta):
	if not ctrl_character:
		return
	var input = get_move_vector(delta)
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	ctrl_character.move(dir)
	
func _on_button_button_down():
	modulate.a=1.0
	is_draging=true

func _on_button_button_up():
	modulate.a=0.5
	is_draging=false

func _on_resized():
	var fw=min(size.x,size.y)
	var hw=fw/2
	dis_max=hw*0.9
	pivot_offset=Vector2(hw,hw)
	fw*=0.3
	hw=fw/2
	dot.position=Vector2(hw,hw)
	dot.size=Vector2(fw,fw)
	dot.pivot_offset=Vector2(hw,hw)
