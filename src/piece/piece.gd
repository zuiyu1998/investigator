class_name Piece
extends Node2D

# 棋子的匹配类型
@export var match_type: MatchingController.MatchType = MatchingController.MatchType.SIGLE

# 棋子的唯一id
@export var piece_id: int


func move(target: Vector2):
	var move_tween = create_tween()
	(
		move_tween
		. tween_property(self, "position", target, 0.3)
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_OUT)
	)
	move_tween.play()
