extends CharacterBody3D

@export var jump_height : float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var base_speed := 4.0
@export var sprint_speed := 8.0
@onready var camera := $CameraController/Camera3D
var movment_input := Vector2.ZERO

func  _physics_process(delta: float) -> void:
	
	move_logic(delta)
	jump_logic(delta)
	move_and_slide()
	
func move_logic(delta: float):
	movment_input = Input.get_vector("a","d","w","s")
	movment_input = movment_input.rotated(-camera.global_rotation.y)
	var vel = Vector2(velocity.x, velocity.z)
	var speed: float = base_speed
	if Input.is_action_pressed("left shift"):
		speed = sprint_speed
	# if player is moving/movment is presses the slowly increse the player speed to max base speed
	if movment_input != Vector2.ZERO:
		vel += movment_input * speed * delta
		vel = vel.limit_length(speed)
		$GodetteSkin.set_state_machine('Running_B')
		# to know where the charachter is supposed to face to
		var target_angle = -movment_input.angle() 
		target_angle = target_angle + PI/2 # charchter was facing with 90 degree off sate so to counter that
		$GodetteSkin.rotation.y = rotate_toward($GodetteSkin.rotation.y, target_angle, 6.0 * delta)
		
	else:
		# if player has stopped moving then we slowy stop them with this
		vel = vel.move_toward(Vector2.ZERO,speed * 4.0 * delta)
		$GodetteSkin.set_state_machine('Idle' )
		
	velocity.x = vel.x
	velocity.z = vel.y
func jump_logic(delta: float):
	# this if statment make sure that no jump allowed when in the air can be modifed to be used for something like double jump
	if is_on_floor(): 
		if Input.is_action_just_pressed("space"):
			velocity.y = -jump_velocity
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta
