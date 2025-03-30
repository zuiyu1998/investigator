class_name PlayerData
extends Node2D

signal health_update

# 健康度
var health: int = 100
# 最大健康度
var max_health: int = 100
# 理智度
var reason: int = 100


func get_health_percent() -> float:
	return self.health * 1.0 / self.max_health


func on_update_helath(update: int):
	health += update
	health_update.emit()
