extends Control


@onready var heart_container = $Heart/MarginContainer/HBoxContainer
var heart_sence: PackedScene = preload("res://scenes/entities/player/heart.tscn")

func setup(value: int):
	for i in value:
		var heart = heart_sence.instantiate()
		heart_container.add_child(heart)
		heart.change_alpha(1.0)
		await  get_tree().create_timer(0.3).timeout
		
func update_heart(value:int, direction: int):
	for child in heart_container.get_children():
		child.queue_free()	
	if direction < 0:
		for i in value:
			var heart = heart_sence.instantiate()
			heart_container.add_child(heart)
		var heart = heart_sence.instantiate()
		heart_container.add_child(heart)
		heart.change_alpha(0.0)
	else:
		for i in value - 1:
			var heart = heart_sence.instantiate()
			heart_container.add_child(heart)
		var heart = heart_sence.instantiate()
		heart_container.add_child(heart)
		heart.change_alpha(1.0)
