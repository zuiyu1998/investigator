class_name PieceEffect
extends Resource

enum EffectTarget { DAMAGE, HEALTH, REASON }

@export var bullet_update_value: int
@export var bullet_tscn: PackedScene
@export var buf: bool = false
@export var target: EffectTarget = EffectTarget.DAMAGE


func spawn_bullet(bullet_position: Vector2) -> Bullet:
	var bullet = bullet_tscn.instantiate() as Bullet
	bullet.position = bullet_position
	bullet.update_value = bullet_update_value
	bullet.buf = buf
	return bullet
