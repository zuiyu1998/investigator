extends Bullet


func _goto_player_health(delta: float):
	var nodes = get_tree().get_nodes_in_group("PlayerHelath")
	if nodes.is_empty():
		return
	var player_health = nodes[0] as PlayerHealthBulletTarget

	var target = player_health.global_position - global_position

	if target.length_squared() < 4:
		return

	var direction = target.normalized()

	position = position + direction * speed * delta


func _physics_process(delta: float) -> void:
	_goto_player_health(delta)


func _on_hitbix_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		var target = area.target as PlayerHealthBulletTarget
		target.on_helath_update(-update_value)
		queue_free()
