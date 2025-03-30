class_name Level
extends Node2D

# 设置最大交换次数
@export var max_move_count = 10

# 设置司辰棋子的最大使用次数
@export var max_use_si_chen_count = 0
# 设置正神棋子的最大使用次数
@export var max_use_god_count = 0

var move_count = max_move_count

var si_chen_count = 0
var god_count = 0

@onready var enemy_container: Node2D = $EnemyContainer

@onready
var end_button: Button = $Player/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/EndButton

@onready
var move_count_label: Label = $Player/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/MoveCountLabel
@onready var use_count_lable: Label = $Player/HBoxContainer/VBoxContainer/UseCountLable


func goto_manin_menu():
	GlobalVar.get_single_game_state_manager().goto_main_menu()
	queue_free()


func is_replace(piece: Piece) -> bool:
	match piece.god_kind:
		GodConsts.GodKind.SI_CHEN:
			return is_replace_si_chen(piece.get_price())
		GodConsts.GodKind.GOD:
			return is_replace_god(piece.get_price())
	return false


func is_replace_si_chen(price: int) -> bool:
	if self.max_use_si_chen_count > 0:
		return true
	var play_data = GlobalVar.get_single_player_data()
	if play_data.health > price:
		return true
	return false


func is_replace_god(price: int) -> bool:
	if self.max_use_god_count > 0:
		return true
	var play_data = GlobalVar.get_single_player_data()
	if play_data.reason > price:
		return true
	return false


func replace_si_chen(price: int):
	if self.max_use_si_chen_count > 0:
		self.si_chen_count -= 1
	else:
		var play_data = GlobalVar.get_single_player_data()
		play_data.on_update_helath(-price)


func replace_god(price: int):
	if self.max_use_god_count > 0:
		self.god_count -= 1
	else:
		var play_data = GlobalVar.get_single_player_data()
		play_data.on_update_reason(-price)


func replace(piece: Piece):
	match piece.god_kind:
		GodConsts.GodKind.SI_CHEN:
			replace_si_chen(piece.get_price())
		GodConsts.GodKind.GOD:
			replace_god(piece.get_price())
	_update_use_count_label()


func is_move() -> bool:
	return move_count > 0


# 棋子移动
func move():
	move_count -= 1
	_update_move_count_label()


func _update_use_count_label():
	use_count_lable.text = "当前眷顾: 司辰:%s 正神: %s" % [si_chen_count, god_count]


func _update_move_count_label():
	move_count_label.text = "当前行动点数: %s" % move_count


func get_enemy() -> Enemy:
	return enemy_container.get_child(0)


func refresh():
	move_count = max_move_count
	_update_move_count_label()
	_update_use_count_label()


func attack():
	get_enemy().attack()
	refresh()


func _ready() -> void:
	_update_move_count_label()
	_update_use_count_label()
	end_button.pressed.connect(attack)
