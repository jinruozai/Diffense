extends Node3D

@export var monster_scenes:Array[PackedScene]=[]

func spawn_monsters():
	for monsterscene in monster_scenes:
		if monsterscene:
			var monsterinstance=monsterscene.instantiate()
			add_child(monsterinstance)
			monsterinstance.global_transform = global_transform
			monsterinstance.add_to_group("enemy")
