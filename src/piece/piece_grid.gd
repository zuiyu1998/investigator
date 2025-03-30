class_name PieceGrid
extends GridContainer

@export var piece_names: Array[String] = [
	#todo
	"yellow",
	"pink",
	"light_green",
	# 只能出现神的棋子
	#"orange",
	#"green",
	"blue"
]

var all_piece_ui = []


func _make_all_piece_ui():
	var temp = []
	for piece_name in piece_names:
		var peice_ui: PieceUi = PieceFactory.get_piece_ui(piece_name)
		add_child(peice_ui)
		temp.push_back(peice_ui)
	all_piece_ui = temp


func _ready() -> void:
	_make_all_piece_ui()
