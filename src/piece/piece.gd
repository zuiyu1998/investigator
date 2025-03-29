class_name Piece
extends Node2D

@onready var label: Label = $Sprite2D/Control/Label


func get_piece_name() -> String:
	return label.text
