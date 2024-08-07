extends Node3D

@onready var fire = $Fire
@onready var debris = $Debris
@onready var smoke = $Smoke

func _ready():
	fire.emitting=true
	debris.emitting=true
	smoke.emitting=true

func _on_timer_timeout():
	queue_free()
