class_name Bullet
extends Node2D

@export var damage: int = 1
@export var speed: float = 300


func _goto_enemy(delta: float):
	var enemys = get_tree().get_nodes_in_group("Enemy")
	if enemys.is_empty():
		return
	var enemy = enemys[0] as Enemy

	var target = enemy.global_position - global_position - Vector2(0, enemy.get_size().y / 2)

	if target.length_squared() < 5:
		return

	var direction = target.normalized()

	position = position + direction * speed * delta


func _physics_process(delta: float) -> void:
	_goto_enemy(delta)


func _on_hitbix_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		var enemy = area.target as Enemy
		var damage_result = Enemy.Damage.new()
		damage_result.damage = self.damage
		enemy.on_damage(damage_result)
		queue_free()
