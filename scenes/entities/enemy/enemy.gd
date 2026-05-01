class_name Enemy
extends CharacterBody3D

@onready var player = get_tree().get_first_node_in_group("Player")
#@onready var boss_skin = get_node("NagonfordSkin")
@onready var move_state_machine =  $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var attack_animation = $AnimationTree.get_tree_root().get_node("AttackAnimation")

@export var walk_speed := 2.0
@export var notice_radius := 30.0
@export var attack_radius := 3.0
@export var speed = walk_speed
var speed_modifer := 1.0



var rng = RandomNumberGenerator.new()
func move_to_player(delta):
	if position.distance_to(player.position) < notice_radius:
		# this gives a normlized diffrence between player postion and current enemy postion
		var target_pos = (player.position - position).normalized()
		var target_vec2 = Vector2(target_pos.x,target_pos.z)
		
		var target_angle = - target_vec2.angle() + PI/2
		rotation.y = rotate_toward(rotation.y, target_angle, delta * 6.0)
		if position.distance_to(player.position) > attack_radius:
			velocity = Vector3(target_vec2.x, 0, target_vec2.y) * speed * speed_modifer
			move_state_machine.travel("Walk")
		else:
			velocity = Vector3.ZERO
			move_state_machine.travel("Idle")
	
	move_and_slide()

# stop player for brif moment
func stop_movement(start_duration: float, end_duration: float):
	var tween = create_tween()
	tween.tween_property(self, "speed_modifer", 0.0, start_duration) # In 0.3 seconds, speed goes from 1.0 → 0.0
	tween.tween_property(self, "speed_modifer", 1.0, end_duration)	 # In 0.8 seconds, speed goes from 0.0 → 1.0
