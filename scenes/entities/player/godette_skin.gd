extends Node3D

@onready var move_state_machine = $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var attack_state_machine = $AnimationTree.get("parameters/AttackStateMachine/playback")
var attackking := false
func set_state_machine(state_name: String):
	move_state_machine.travel(state_name)

func attack():
	if not attackking:
		attack_state_machine.travel("Slice" if $SecondAttackTimer.time_left else "Chop")
		$AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func attack_toggle(value:bool):
	attackking = value
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
