extends Node3D

@export var mouse_sensitivity := 0.005

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_from_vector(event.relative  * mouse_sensitivity)
		

func rotate_from_vector(v:Vector2):
	if v.length() == 0: return
	print("rotaion",v.x)
	rotation.y += v.x
