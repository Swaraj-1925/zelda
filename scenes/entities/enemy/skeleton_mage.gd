extends Enemy

func _physics_process(delta: float) -> void:
	move_to_player(delta)

func _ready() -> void:
	walk_speed = 7.0


func _on_attack_timer_timeout() -> void:
	$Timers/AttackTimer.wait_time = rng.randf_range(2.0,3.5)
	if position.distance_to(player.position) < 5.0:
		spell_cast_animation()

func spell_cast_animation():
	$AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
