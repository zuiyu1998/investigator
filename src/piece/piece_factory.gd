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


static func get_piece(piece_name: String) -> Piece:
	var piece: PackedScene = PIECES.get(piece_name)
	return piece.instantiate()
