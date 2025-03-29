class_name Piece
extends Node2D

# 棋子的唯一id
@export var piece_id: int
# 棋子的匹配类型
@export var match_type: MatchingController.MatchType = MatchingController.MatchType.SIGLE

var matched: bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D


func destory():
	var bullet = BulletFactory.get_builet("fire")
	bullet.position = global_position
	get_tree().current_scene.add_child(bullet)

	queue_free()


func set_matched():
	matched = true
	sprite_2d.modulate.a = 0.5


func move(target: Vector2):
	var move_tween = create_tween()
	(
		move_tween
		. tween_property(self, "position", target, 0.3)
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_OUT)
	)
	move_tween.play()
