extends Enemy


func _physics_process(delta: float) -> void:
	move_to_player(delta)

func _ready() -> void:
	walk_speed = 7.0


func _on_attack_timer_timeout() -> void:
	$Timers/AttackTimer.wait_time = rng.randf_range(2.0,3.5)
	if position.distance_to(player.position) < attack_radius:
		spell_cast_animation()

func spell_cast_animation():
	$AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func  shoot_fireball():
	var direction = (player.position - position).normalized()
	var dir_2d = Vector2(direction.x,direction.z)
	var pos = $Skeleton_Mage/Rig/Skeleton3D/BoneAttachment3D/wand2/Marker3D.global_position
	cast_spell.emit('fireball',pos, dir_2d,1.0)
	
