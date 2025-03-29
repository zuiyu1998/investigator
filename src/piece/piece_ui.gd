class_name PieceUi
extends HBoxContainer

@export var piece_name: String

@onready var texture_rect: TextureRect = $TextureRect


func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview = TextureRect.new()
	preview.scale = Vector2(0.5, 0.5)
	preview.texture = texture_rect.texture.duplicate()

	var piece_drag = PieceDrag.new(piece_name, preview)
	set_drag_preview(piece_drag.preview)

	return piece_drag


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if !data is PieceDrag:
		return false
	return true


func _drop_data(_at_position: Vector2, _data: Variant) -> void:
	return
