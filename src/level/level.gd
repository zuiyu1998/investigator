class_name Level
extends Node2D

# 设置最大交换次数
@export var max_move_count = 10

var move_count = max_move_count

@onready var enemy_container: Node2D = $EnemyContainer

@onready
var end_button: Button = $Player/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/EndButton

@onready
var move_count_label: Label = $Player/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/MoveCountLabel


func goto_manin_menu():
	GlobalVar.get_single_game_state_manager().goto_main_menu()
	queue_free()


func is_move() -> bool:
	return move_count > 0


func update_move_count():
	move_count -= 1
	_update_move_count_label()


func _update_move_count_label():
	move_count_label.text = "当前行动点数: %s" % move_count


func get_enemy() -> Enemy:
	return enemy_container.get_child(0)


func refresh():
	move_count = max_move_count
	_update_move_count_label()


func attack():
	get_enemy().attack()
	refresh()


func _ready() -> void:
	_update_move_count_label()
	end_button.pressed.connect(attack)
