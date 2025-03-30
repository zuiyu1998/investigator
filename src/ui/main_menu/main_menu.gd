extends CanvasLayer

@onready var start_game_button: Button = $VBoxContainer/StartGameButton


func _start_game():
	GlobalVar.get_single_game_state_manager().start_game()
	queue_free()


func _ready() -> void:
	start_game_button.pressed.connect(_start_game)
