extends Bullet


func on_hurtbox(area: Hurtbox) -> void:
	var enemy = area.target as Enemy
	var damage_result = Enemy.Damage.new()
	damage_result.damage = self.update_value
	enemy.on_damage(damage_result)
	queue_free()
