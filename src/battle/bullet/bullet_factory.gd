class_name BulletFactory
extends RefCounted

const BUILETS = {"fire": preload("res://src/battle/bullet/fire_bullet.tscn")}


static func get_builet(bullet_name: String) -> Bullet:
	var bullet: PackedScene = BUILETS.get(bullet_name)
	return bullet.instantiate() as Bullet
