class_name Grid
extends Node2D

@export var width = 16

@export var height = 9

# 最小匹配的个数
@export var min_piece = 3

# 棋子大小
@export var offest = 64

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

# 所有棋子
var pieces = []

# 棋子交换
var first_touch = Vector2i.ZERO
var last_touch = Vector2i.ZERO
var move = false


class MatchResult:
	var match_state = false
	var piece_postions: Array[Vector2i] = []


func is_in_grid(x: int, y: int) -> bool:
	if x >= 0 and x < width and y >= 0 and y < height:
		return true
	return false


func pixel_to_position(peice_position: Vector2) -> Vector2i:
	return Vector2i(int(peice_position.x / offest), int(peice_position.y / offest))


func position_to_pixel(peice_position: Vector2i) -> Vector2:
	return Vector2(peice_position.x * offest * 1.0, peice_position.y * offest * 1.0)


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


func spawn_pieces():
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
				piece.position = position_to_pixel(Vector2i(i, j))
				add_child(piece)

			pieces[i][j] = piece


func _unhandled_input(_event: InputEvent) -> void:
	_on_touch_input()


func _on_touch_input():
	if Input.is_action_just_pressed("touch"):
		var mouse_position = get_local_mouse_position()
		var position = pixel_to_position(mouse_position)
		if is_in_grid(position.x, position.y):
			first_touch = position
			move = true
	if Input.is_action_just_released("touch"):
		var mouse_position = get_local_mouse_position()
		var position = pixel_to_position(mouse_position)
		if move and is_in_grid(position.x, position.y):
			last_touch = position

			var direction = get_positon_direction(first_touch, last_touch)
			if direction == Vector2i.ZERO:
				return
			move_piece(first_touch.x, first_touch.y, direction)
			move = false
		else:
			move = false


func get_positon_direction(first: Vector2i, two: Vector2i) -> Vector2i:
	var direction = first - two

	if direction == Vector2i.ZERO:
		return Vector2i.ZERO

	if abs(direction.x) > abs(direction.y):
		direction.y = 0
		direction.x = direction.x / abs(direction.x)
	else:
		direction.x = 0
		direction.y = direction.y / abs(direction.y)
	return direction


func move_piece(x: int, y: int, direction: Vector2i):
	var first_piece: Piece = pieces[x][y]
	var other_piece: Piece = pieces[x + direction.x][y + direction.y]
	pieces[x + direction.x][y + direction.y] = first_piece
	pieces[x][y] = other_piece

	first_piece.move(position_to_pixel(Vector2i(x + direction.x, y + direction.y)))
	other_piece.move(position_to_pixel(Vector2i(x, y)))


func _ready() -> void:
	_make_pieces()
	spawn_pieces()
