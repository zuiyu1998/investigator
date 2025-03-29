class_name PieceFactory
extends RefCounted

const PIECES = {
	"yellow": preload("res://src/piece/yellow.tscn"),
	"pink": preload("res://src/piece/pink.tscn"),
	"light_green": preload("res://src/piece/light_green.tscn"),
	"orange": preload("res://src/piece/orange.tscn"),
	"green": preload("res://src/piece/green.tscn"),
	"blue": preload("res://src/piece/blue.tscn"),
}

const PIECE_UIS = {
	"blue": preload("res://src/piece/blue_piece_ui.tscn"),
	"green": preload("res://src/piece/green_piece_ui.tscn"),
	"orange": preload("res://src/piece/orange_piece_ui.tscn"),
	"light_green": preload("res://src/piece/light_green_piece_ui.tscn"),
	"pink": preload("res://src/piece/pink_piece_ui.tscn"),
	"yellow": preload("res://src/piece/yellow_piece_ui.tscn"),
}


static func get_piece_ui(piece_name: String) -> PieceUi:
	var piece_ui: PackedScene = PIECE_UIS.get(piece_name)
	return piece_ui.instantiate() as PieceUi


static func get_piece(piece_name: String) -> Piece:
	var piece: PackedScene = PIECES.get(piece_name)
	return piece.instantiate()
