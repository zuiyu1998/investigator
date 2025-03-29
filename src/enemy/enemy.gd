class_name Enemy
extends Node2D

@export var health = 20

@export var max_health = 20

@onready var sprite_2d: Sprite2D = $Sprite2D


func on_damage(damge: Damage):
	print(damge.damage)
	health -= damge.damage


func get_size() -> Vector2:
	return sprite_2d.get_rect().size


class Damage:
	var damage: int
