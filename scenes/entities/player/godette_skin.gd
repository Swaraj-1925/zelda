extends Node3D

@onready var move_state_machine = $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var attack_state_machine = $AnimationTree.get("parameters/AttackStateMachine/playback")
@onready var extra_animation_node = $AnimationTree.get_tree_root().get_node("ExtraAnimation")
@onready var face_material: StandardMaterial3D = $Rig/Skeleton3D/Godette_Head.get_surface_override_material(0)
var attacking := false

const faces = {
	'defult' : Vector3.ZERO,
	'blink' : Vector3(0.0,0.5,0.0)
	}
var rng = RandomNumberGenerator.new()

func set_state_machine(state_name: String):
	move_state_machine.travel(state_name)

func attack():
	if not attacking:
		attack_state_machine.travel("Slice" if $SecondAttackTimer.time_left else "Chop")
		$AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func attack_toggle(value:bool):
	attacking = value
# forward is a bool values so it can be true or false whihc by defult false
# these two values are converted to floting point values true = 1, false = 0
# after substracting these values with 1.0 if forward is true = 1 then starting value is start from 0 goes till forward = true = 1
# if forward is false = 0 starting value 1.0 - 0 = 1.0 till forward = false = 0
# this apporch works beacuse wer using a blend2 node in between movment and defent animation node
func defend(forward: bool):
	var tween = create_tween()
	tween.tween_method(_defend_change, 1.0 - float(forward), float(forward), 0.25)
	
func _defend_change(value:float):
	$AnimationTree.set("parameters/Block Blend/blend_amount", value)

func switch_weapon(weapon_active: bool):
	if weapon_active:
		$Rig/Skeleton3D/RightHandSlot/Sword.show()
		$Rig/Skeleton3D/RightHandSlot/wand2.hide()
	else:
		$Rig/Skeleton3D/RightHandSlot/Sword.hide()
		$Rig/Skeleton3D/RightHandSlot/wand2.show()

func cast_spell():
	if not attacking:
		extra_animation_node.animation = 'Spellcast_Shoot'
		$AnimationTree.set("parameters/ExtraOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
func shoot_fireball():
	get_parent().shoot_fireball($Rig/Skeleton3D/RightHandSlot/Marker3D.global_position)
func hit():
	extra_animation_node.animation = 'Hit_A'
	$AnimationTree.set("parameters/ExtraOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	$AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func change_face(expression):
	face_material.uv1_offset = faces[expression]
	

func _on_blink_timer_timeout() -> void:
	change_face('blink')
	await get_tree().create_timer(0.2).timeout
	change_face('defult')
	$BlinkTimer.wait_time = rng.randf_range(1.5,3.5)

func can_damage(value:bool):
	$Rig/Skeleton3D/RightHandSlot/Sword.can_damage = value
