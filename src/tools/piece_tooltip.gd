class_name PieceTooltip
extends Node2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = $CanvasLayer/Label


func show_piece(piece: PieceModel):
	canvas_layer.visible = true

	var text = ""
	if GodConsts.is_si_chen(piece.god_kind):
		text += "该节点替换需要消耗%s生命值" % piece.price
	if GodConsts.is_god(piece.god_kind):
		text += "该节点替换需要消耗%s理智度" % piece.price

	for effect in piece.effects:
		var effect_text
		match effect.effct_target:
			PieceEffect.EffectTarget.DAMAGE:
				effect_text = "该节点消除时造成%s点伤害" % effect.update_value
			PieceEffect.EffectTarget.HEALTH:
				var temp_text
				if effect.buf:
					temp_text = "恢复"
				else:
					temp_text = "消耗"
				effect_text = "该节点消除时%s%s点生命值" % [temp_text, effect.update_value]
			PieceEffect.EffectTarget.REASON:
				var temp_text
				if effect.buf:
					temp_text = "恢复"
				else:
					temp_text = "消耗"
				effect_text = "该节点消除时%s%s点理智度" % [temp_text, effect.update_value]

		text += "\n"
		text += effect_text

	label.text = text


func _input(event: InputEvent) -> void:
	if canvas_layer.visible:
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("piece_show"):
		canvas_layer.visible = false


func _ready() -> void:
	canvas_layer.visible = false
