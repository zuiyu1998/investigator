extends Bullet


func on_hurtbox(area: Hurtbox) -> void:
	var target = area.target as PlayerHealthBulletTarget
	target.on_helath_update(update_value)
	queue_free()
