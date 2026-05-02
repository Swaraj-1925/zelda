extends Node3D


var fireball_scene: PackedScene = preload("res://scenes/entities/vfx/fire_ball.tscn")


func _ready() -> void:
	for entity in $Entites.get_children():
		if entity.has_signal("cast_spell"):
			entity.connect("cast_spell", create_fireball)
func create_fireball(type: String, pos: Vector3, direction: Vector2, size: float):
	var fireball = fireball_scene.instantiate()
	$Projectiles.add_child(fireball)
	fireball.global_position = pos
	fireball.direction = direction
	fireball.setup(size)
#func _on_player_cast_spell() -> void:
	
