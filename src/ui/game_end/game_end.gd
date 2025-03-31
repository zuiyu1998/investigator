class_name GameEnd
extends CanvasLayer

@onready var status_label: Label = $VBoxContainer/StatusLabel
@onready var restart_game_button: Button = $VBoxContainer/RestartGameButton
@onready var go_back_main_menu_button: Button = $VBoxContainer/GoBackMainMenuButton


func show_game_end():
	_update_stats_label()
	visible = true


func _update_stats_label():
	var player_data = GlobalVar.get_single_player_data()
	if player_data.health <= 0 or player_data.reason <= 0:
		status_label.text = "你死了"
	elif player_data.reason <= 30:
		status_label.text = "你赢了，但是疯了"
	else:
		status_label.text = "你赢了"


func _restart_game():
	var app_state_manager = GlobalVar.get_single_game_state_manager()
	app_state_manager.restart_game()
	visible = false


func _go_back_main_menu():
	var app_state_manager = GlobalVar.get_single_game_state_manager()
	app_state_manager.goto_main_menu()
	visible = false


func _ready() -> void:
	visible = false
	_update_stats_label()
	restart_game_button.pressed.connect(_restart_game)
	go_back_main_menu_button.pressed.connect(_go_back_main_menu)
