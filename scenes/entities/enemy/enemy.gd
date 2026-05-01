class_name Enemy
extends CharacterBody3D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var boss_skin = get_node("BossSkin")

func move_to_player():
	# this gives a normlized diffrence between player postion and current enemy postion
	var target_pos = (player.position - position).normalized()
	var target_vec2 = Vector2(target_pos.x,target_pos.z)
	velocity = Vector3(target_vec2.x, 0, target_vec2.y) * 3
	move_and_slide()
