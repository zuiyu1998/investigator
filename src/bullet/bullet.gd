class_name Bullet
extends Node2D

@export var update_value: int = 1
@export var speed: float = 300
@export var buf: bool = false
@export var group_name: String


func _goto_group_node(delta: float):
	var nodes = get_tree().get_nodes_in_group(group_name)
	if nodes.is_empty():
		return
	var player_health = nodes[0] as Node2D

	var target = player_health.global_position - global_position

	if target.length_squared() < 4:
		return

	var direction = target.normalized()

	position = position + direction * speed * delta


func _physics_process(delta: float) -> void:
	_goto_group_node(delta)


func on_hurtbox(_hurbox: Hurtbox) -> void:
	return


func _on_hitbix_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		on_hurtbox(area)
