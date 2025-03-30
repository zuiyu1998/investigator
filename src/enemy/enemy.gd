class_name Enemy
extends Node2D

@export var health = 20

@export var max_health = 20

@export var enemy_effecs: Array[EnemyEffect]

@onready var sprite_2d: Sprite2D = $Sprite2D


func on_damage(damge: Damage):
	health -= damge.damage


func get_size() -> Vector2:
	return sprite_2d.get_rect().size


func attack():
	for effect in enemy_effecs:
		var bullet = effect.spawn_bullet(global_position)
		get_tree().current_scene.add_child(bullet)


class Damage:
	var damage: int
