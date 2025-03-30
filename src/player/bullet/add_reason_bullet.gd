extends Bullet


func on_hurtbox(area: Hurtbox) -> void:
	var target = area.target as PlayerReasonBulletTarget
	target.on_reason_update(update_value)
	queue_free()
