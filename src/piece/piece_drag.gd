class_name PieceDrag
extends RefCounted

var piece_name: String
var preview: Control


func _init(_item: String, _preview: Control):
	self.piece_name = _item
	self.preview = _preview
