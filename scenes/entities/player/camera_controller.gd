extends Node3D

@export var mouse_accleartion := 0.005
#@export var horizontal_accleartion := 0.005
#@export var vertical_accleartion := 0.005
@export var min_limit_x := -0.8
@export var max_limit_x := -0.2

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_from_vector(event.relative  * mouse_accleartion)
		

func rotate_from_vector(v:Vector2):
	if v.length() == 0: return
	rotation.y -= v.x
	rotation.x -= v.y
	rotation.x = clamp(rotation.x, min_limit_x, max_limit_x)
	
