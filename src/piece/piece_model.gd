class_name PieceModel
extends RefCounted

var god_kind: GodConsts.GodKind
var price: int
var effects: Array[PieceEffectModel] = []


class PieceEffectModel:
	var update_value: int
	var buf: bool
	var effct_target: PieceEffect.EffectTarget

	static func new_model(model: PieceEffect) -> PieceEffectModel:
		var value = PieceEffectModel.new()
		value.update_value = model.bullet_update_value
		value.buf = model.buf
		value.effct_target = model.target
		return value
