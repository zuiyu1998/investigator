class_name Grid
extends Node2D

@export var width = 16

@export var height = 9

# 最小匹配的个数
@export var min_piece = 3

# 最大生成棋子的尝试次数
@export var max_spawn_count = 100

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


class MatchResult:
	var match_state = false
	var piece_postions: Array[Vector2i] = []


func piece_is_match_column(x: int, y: int, piece: Piece) -> MatchResult:
	var controller = MatchingController.new()
	var resu = MatchResult.new()
	controller.check_match_type(piece.match_type, piece.piece_id)

	# 往上找
	for piece_y in range(y, height):
		var temp_piece: Piece = pieces[x][piece_y]
		if not temp_piece:
			break

		var res = controller.check_match_type(temp_piece.match_type, temp_piece.piece_id)
		if not res:
			break
		resu.piece_postions.push_back(Vector2i(x, piece_y))

	var temp = range(0, y)
	temp.reverse()

	for piece_y in temp:
		var temp_piece: Piece = pieces[x][piece_y]
		if not temp_piece:
			break

		var res = controller.check_match_type(temp_piece.match_type, temp_piece.piece_id)
		if not res:
			break
		resu.piece_postions.push_back(Vector2i(x, piece_y))

	resu.match_state = controller.get_match_type_count() >= min_piece

	return resu


func piece_is_match_row(x: int, y: int, piece: Piece) -> MatchResult:
	var controller = MatchingController.new()
	var resu = MatchResult.new()
	controller.check_match_type(piece.match_type, piece.piece_id)

	# 往上找
	for piece_x in range(x, height):
		var temp_piece: Piece = pieces[piece_x][y]
		if not temp_piece:
			break

		var res = controller.check_match_type(temp_piece.match_type, temp_piece.piece_id)
		if not res:
			break
		resu.piece_postions.push_back(Vector2i(piece_x, x))

	var temp = range(0, x)
	temp.reverse()

	for piece_x in temp:
		var temp_piece: Piece = pieces[piece_x][y]
		if not temp_piece:
			break

		var res = controller.check_match_type(temp_piece.match_type, temp_piece.piece_id)
		if not res:
			break
		resu.piece_postions.push_back(Vector2i(piece_x, y))

	resu.match_state = controller.get_match_type_count() >= min_piece

	return resu


func piece_is_match(x: int, y: int, piece: Piece) -> MatchResult:
	var resu = piece_is_match_column(x, y, piece)
	if not resu.match_state:
		resu = piece_is_match_row(x, y, piece)
	return resu


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
			var count = max_spawn_count

			var ok = false

			var piece

			while count > 0 and not ok:
				piece = PieceFactory.get_piece(get_rand_piece_name())
				var res = piece_is_match(i, j, piece)
				ok = !res.match_state
				count -= 1

			if piece:
				piece.position = Vector2(i * 64, j * 64)
				add_child(piece)

			pieces[i][j] = piece


func _ready() -> void:
	_make_pieces()
	alloc_pieces()
