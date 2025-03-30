class_name PlayerData
extends Node2D

signal health_update
signal reason_update

# 健康度
var health: int = 100
# 最大健康度
var max_health: int = 100
# 理智度
var reason: int = 100
# 最大理智度
var max_reason: int = 100


func reset():
	health = max_health
	reason = max_reason


func get_reason_percent() -> float:
	return self.reason * 1.0 / self.max_reason


func on_update_reason(update: int):
	reason += update
	reason_update.emit()


func get_health_percent() -> float:
	return self.health * 1.0 / self.max_health


func on_update_helath(update: int):
	health += update
	health_update.emit()
