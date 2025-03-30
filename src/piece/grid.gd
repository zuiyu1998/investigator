class_name Grid
extends Node2D

enum State { BUSY, WAIT }

@export var level: Level

# 棋盘宽度
@export var width = 16
# 棋盘高度
@export var height = 9
# 最小匹配的个数
@export var min_piece = 3
# 棋子大小
@export var offest = 64
# 最大生成棋子的尝试次数
@export var max_spawn_count = 100

@export var y_offest = 4

@export var piece_names: Array[String] = [
	# todo
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

var state: State = State.WAIT

# 拖动的棋子
var drag_piece_name

@onready var destroy_timer: Timer = $DestroyTimer
@onready var collapse_timer: Timer = $CollapseTimer
@onready var refill_timer: Timer = $RefillTimer


class MatchResult:
	var matched = false
	var piece_positions: Array[Vector2i] = []


func on_drag():
	state = State.BUSY
	var data = get_viewport().gui_get_drag_data()
	if data is PieceDrag:
		drag_piece_name = data.piece_name


func on_drag_end():
	if !drag_piece_name is String:
		return

	var mouse_position = get_local_mouse_position()
	var piece_postion = pixel_to_position(mouse_position)

	if is_in_grid(piece_postion.x, piece_postion.y):
		var piece = PieceFactory.get_piece(drag_piece_name)

		if level.is_replace(piece):
			level.replace(piece)
			var old_piece: Piece = pieces[piece_postion.x][piece_postion.y]
			piece.position = old_piece.position
			pieces[piece_postion.x][piece_postion.y] = piece

			add_child(piece)
			old_piece.queue_free()
			find_matchs()

	drag_piece_name = null


func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_DRAG_BEGIN:
		on_drag()
	if what == Node.NOTIFICATION_DRAG_END:
		on_drag_end()


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
	var resu := MatchResult.new()
	controller.check_match_type(piece.match_type, piece.piece_id)

	# 往上找
	for piece_y in range(y + 1, height):
		var temp_piece = pieces[x][piece_y]
		if not temp_piece:
			break

		var res = controller.check_match_type(temp_piece.match_type, temp_piece.piece_id)
		if not res:
			break
		resu.piece_positions.push_back(Vector2i(x, piece_y))

	var temp = range(0, y)
	temp.reverse()

	for piece_y in temp:
		var temp_piece = pieces[x][piece_y]
		if not temp_piece:
			break

		var res = controller.check_match_type(temp_piece.match_type, temp_piece.piece_id)
		if res == false:
			break
		resu.piece_positions.push_back(Vector2i(x, piece_y))

	resu.matched = controller.get_match_type_count() >= min_piece

	return resu


func piece_is_match_row(x: int, y: int, piece: Piece) -> MatchResult:
	var controller = MatchingController.new()
	var resu = MatchResult.new()
	controller.check_match_type(piece.match_type, piece.piece_id)

	# 往右找
	for piece_x in range(x + 1, width):
		var temp_piece = pieces[piece_x][y]
		if not temp_piece:
			break

		var res = controller.check_match_type(temp_piece.match_type, temp_piece.piece_id)
		if not res:
			break
		resu.piece_positions.push_back(Vector2i(piece_x, y))

	var temp = range(0, x)
	temp.reverse()

	for piece_x in temp:
		var temp_piece = pieces[piece_x][y]
		if not temp_piece:
			break
		var res = controller.check_match_type(temp_piece.match_type, temp_piece.piece_id)
		if not res:
			break
		resu.piece_positions.push_back(Vector2i(piece_x, y))

	resu.matched = controller.get_match_type_count() >= min_piece

	return resu


func piece_is_match(x: int, y: int, piece: Piece) -> MatchResult:
	var resu_column = piece_is_match_column(x, y, piece)
	var resu_row = piece_is_match_row(x, y, piece)
	var resu = MatchResult.new()
	if resu_column.matched:
		resu.matched = true
		resu.piece_positions.append_array(resu_column.piece_positions)

	if resu_row.matched:
		resu.matched = true
		resu.piece_positions.append_array(resu_row.piece_positions)

	if resu.matched:
		resu.piece_positions.push_back(Vector2i(x, y))

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
				ok = !res.matched
				count -= 1

			piece.position = position_to_pixel(Vector2i(i, j))
			add_child(piece)

			pieces[i][j] = piece


func _unhandled_input(_event: InputEvent) -> void:
	_on_touch_input()


func _on_touch_input():
	if not level.is_move():
		return

	if state == State.BUSY:
		return
	if Input.is_action_just_pressed("touch"):
		var mouse_position = get_local_mouse_position()
		var pixel_position = pixel_to_position(mouse_position)
		if is_in_grid(pixel_position.x, pixel_position.y):
			first_touch = pixel_position
	if Input.is_action_just_released("touch"):
		var mouse_position = get_local_mouse_position()
		var pixel_position = pixel_to_position(mouse_position)
		if is_in_grid(pixel_position.x, pixel_position.y):
			last_touch = pixel_position
			var direction = get_positon_direction(first_touch, last_touch)
			if direction == Vector2i.ZERO:
				return
			move_piece(first_touch.x, first_touch.y, direction)


func find_matchs():
	var matched = false

	for i in width:
		for j in height:
			var piece = pieces[i][j]
			if piece and not piece.matched:
				var res = piece_is_match(i, j, piece)
				if res.matched:
					matched = true
					var count = res.piece_positions.size()
					for piece_position in res.piece_positions:
						pieces[piece_position.x][piece_position.y].set_matched(count)
	if matched:
		destroy_timer.start()
	else:
		state = State.WAIT


func get_positon_direction(first: Vector2i, two: Vector2i) -> Vector2i:
	var direction = two - first

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
	var first_piece = pieces[x][y]
	var other_piece = pieces[x + direction.x][y + direction.y]

	if first_piece != null and other_piece != null:
		state = State.BUSY
		level.move()
		pieces[x + direction.x][y + direction.y] = first_piece
		pieces[x][y] = other_piece

		first_piece.move(position_to_pixel(Vector2i(x + direction.x, y + direction.y)))
		other_piece.move(position_to_pixel(Vector2i(x, y)))
		find_matchs()


func _ready() -> void:
	_make_pieces()
	spawn_pieces()


func destory_matchs():
	for i in width:
		for j in height:
			var piece = pieces[i][j]
			if piece is Piece:
				if piece.matched:
					piece.destory()
					pieces[i][j] = null
	collapse_timer.start()


func collapse_columns():
	for i in width:
		var tmep_j = range(0, height)
		tmep_j.reverse()
		for j in tmep_j:
			if pieces[i][j] == null:
				var temp = range(0, j)
				temp.reverse()

				for k in temp:
					if pieces[i][k] is Piece:
						pieces[i][k].move(position_to_pixel(Vector2i(i, j)))
						pieces[i][j] = pieces[i][k]
						pieces[i][k] = null
						break
	refill_timer.start()


func refill_columns():
	for i in width:
		for j in height:
			if pieces[i][j] == null:
				var count = max_spawn_count
				var ok = false
				var piece

				while count > 0 and not ok:
					piece = PieceFactory.get_piece(get_rand_piece_name())
					var res = piece_is_match(i, j, piece)
					ok = !res.matched
					count -= 1
				add_child(piece)
				piece.position = position_to_pixel(Vector2i(i, j - y_offest))
				piece.move(position_to_pixel(Vector2i(i, j)))
				pieces[i][j] = piece
	find_matchs()


func _on_destroy_timer_timeout() -> void:
	destory_matchs()


func _on_collapse_timer_timeout() -> void:
	collapse_columns()


func _on_refill_timer_timeout() -> void:
	refill_columns()
