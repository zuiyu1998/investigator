extends TextureProgressBar

@export var level: Level


func _update_reason_health():
	var player_data := GlobalVar.get_single_player_data()
	value = player_data.get_reason_percent()

	if player_data.reason <= 0:
		level.goto_manin_menu()


func _on_binds():
	var player_data := GlobalVar.get_single_player_data()
	player_data.reason_update.connect(_update_reason_health)


func _ready() -> void:
	_update_reason_health()
	_on_binds()
