class_name Enemy
extends Node2D

@export var health = 20

@export var max_health = 20


func on_damage(damge: Damage):
	health -= damge.damage


class Damage:
	var damage: int
