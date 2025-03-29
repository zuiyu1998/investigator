class_name Grid
extends Node2D

@export var width = 16

@export var height = 9

@export var piece_names: Array[String] = [
	#todo
	"yellow",
	"pink",
	"light_green",
	"orange",
	"green",
	"blue"
]

var pieces = []


func get_rand_piece_name() -> String:
	var rand = RandomNumberGenerator.new()
	var index = rand.randi_range(0, piece_names.size() - 1)
	return piece_names[index]


func _make_pieces():
	for i in width:
		var temp: Array[Piece] = []
		for j in height:
			temp.push_back(null)
		pieces.push_back(temp)


func alloc_pieces():
	for i in width:
		for j in height:
			var piece = PieceFactory.get_piece(get_rand_piece_name())
			if piece:
				piece.position = Vector2(i * 64, j * 64)
				add_child(piece)

			pieces[i][j] = piece


func _ready() -> void:
	_make_pieces()
	alloc_pieces()
