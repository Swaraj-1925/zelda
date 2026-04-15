extends CharacterBody3D

@export var base_speed := 4.0

var movment_input := Vector2.ZERO

func  _physics_process(_delta: float) -> void:
	movment_input = Input.get_vector("a","d","w","s")
	velocity = Vector3(movment_input.x, 0, movment_input.y) * base_speed
	move_and_slide()
