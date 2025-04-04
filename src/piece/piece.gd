class_name Piece
extends Node2D

# 棋子的唯一id
@export var piece_id: int
# 棋子的匹配类型
@export var match_type: MatchingController.MatchType = MatchingController.MatchType.SIGLE
# 棋子消除的效果
@export var piece_effects: Array[PieceEffect]
# 棋子归属的神明
@export var god_kind: GodConsts.GodKind = GodConsts.GodKind.NONE

@export var price: int = 2

var matched: bool = false
var matched_count: int = 3

@onready var sprite_2d: Sprite2D = $Sprite2D


func get_price() -> int:
	return price


func get_model() -> PieceModel:
	var model = PieceModel.new()
	model.price = get_price()
	model.god_kind = god_kind

	var effects = piece_effects.map(
		func(effect): return PieceModel.PieceEffectModel.new_model(effect)
	)
	model.effects.assign(effects)

	return model


func destory():
	for piece_effect in piece_effects:
		var bullet = piece_effect.spawn_bullet(global_position)
		if bullet.buf:
			bullet.update_value = bullet.update_value * matched_count

		get_tree().current_scene.add_child(bullet)

	queue_free()


func set_matched(count: int):
	matched = true
	matched_count = count
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
