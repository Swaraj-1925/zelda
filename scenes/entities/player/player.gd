extends CharacterBody3D

@export var jump_height : float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var base_speed := 4.0
@export var sprint_speed := 8.0
@export var defend_speed := 2.0

@onready var camera = $CameraController/Camera3D
@onready var skin = $GodetteSkin

var movment_input := Vector2.ZERO
var weapon_active := true
var speed_modifer := 1.0

func _ready() -> void:
	skin.switch_weapon(weapon_active)
var defend := false:
	set(value):
		if not defend and value:
			skin.defend(true)
		if defend and not value:
			skin.defend(false)
		defend = value
func  _physics_process(delta: float) -> void:
	
	move_logic(delta)
	jump_logic(delta)
	ability_logic()
	if Input.is_action_just_pressed('ui_accept'):
		hit()
	move_and_slide()
	
func move_logic(delta: float):
	movment_input = Input.get_vector("A","D","W","S")
	movment_input = movment_input.rotated(-camera.global_rotation.y)
	var vel = Vector2(velocity.x, velocity.z)
	var speed: float = base_speed
	if Input.is_action_pressed("Left Shift"):
		speed = sprint_speed
	elif defend:
		speed = defend_speed
	# if player is moving/movment is presses the slowly increse the player speed to max base speed
	if movment_input != Vector2.ZERO:
		vel += movment_input * speed * delta
		vel = vel.limit_length(speed) * speed_modifer
		skin.set_state_machine('Running_B')
		# to know where the charachter is supposed to face to
		var target_angle = -movment_input.angle() 
		target_angle = target_angle + PI/2 # charchter was facing with 90 degree off sate so to counter that
		skin.rotation.y = rotate_toward(skin.rotation.y, target_angle, 6.0 * delta)
		
	else:
		# if player has stopped moving then we slowy stop them with this
		vel = vel.move_toward(Vector2.ZERO,speed * 4.0 * delta)
		skin.set_state_machine('Idle' )
		
	velocity.x = vel.x
	velocity.z = vel.y
func jump_logic(delta: float):
	# this if statment make sure that no jump allowed when in the air can be modifed to be used for something like double jump
	if is_on_floor(): 
		if Input.is_action_just_pressed("Space"):
			velocity.y = -jump_velocity
	else:
		# play animation if player is falling 
		skin.set_state_machine('Jump_Idle' )

	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta
	
func ability_logic():
	if Input.is_action_just_pressed("LMB"):
		if weapon_active:
			skin.attack()
		else:
			skin.cast_spell()
			stop_movement(0.3, 0.3)
	defend = Input.is_action_pressed('RMB')
	
	if Input.is_action_just_pressed("Scroll Up") and not skin.attacking:
		weapon_active = not weapon_active
		print("Scrolled up")
		skin.switch_weapon(weapon_active)
		

func hit():
	skin.hit()
	stop_movement(0.3,0.3)
	
# stop player for brif moment
func stop_movement(start_duration: float, end_duration: float):
	var tween = create_tween()
	tween.tween_property(self, "speed_modifer", 0.0, start_duration) # In 0.3 seconds, speed goes from 1.0 → 0.0
	tween.tween_property(self, "speed_modifer", 1.0, end_duration)	 # In 0.8 seconds, speed goes from 0.0 → 1.0
