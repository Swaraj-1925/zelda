extends Control


@onready var heart_container = $Heart/MarginContainer/HBoxContainer
@onready var spell_texture = $Spell/MarginContainer/TextureRect
@onready var energy_bar = $EnergyBar/MarginContainer/TextureProgressBar
@onready var stamina_bar = $StaminaBar/CenterContainer/MarginContainer/TextureProgressBar

var heart_sence: PackedScene = preload("res://scenes/entities/player/heart.tscn")
var fire_texture = preload("res://graphics/ui/fire.png")
var heal_texture = preload("res://graphics/ui/heal.png")


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

func update_spell(spells, current_spells):
	if current_spells == spells.FIREBALL:
		spell_texture.texture = fire_texture
	if current_spells == spells.HEAL:
		spell_texture.texture = heal_texture

func update_energy(value: int):
	energy_bar.value = value

func update_stamina(current: int, target: int): 
	var tween = create_tween()
	tween.tween_method(_change_stamina, current, target, 0.25)
	
	
func _change_stamina(value: int):
	stamina_bar.value = value

func change_stamina_alpha(value:float):
	var tween = create_tween()
	tween.tween_method(_change_stamina_alpha, 1.0 - value, value, 0.25)

func _change_stamina_alpha(value: float):
	stamina_bar.modulate.a = value
