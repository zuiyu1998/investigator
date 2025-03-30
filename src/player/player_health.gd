extends TextureProgressBar

@export var level: Level


func _update_player_health():
	var player_data := GlobalVar.get_single_player_data()
	value = player_data.get_health_percent()

	if player_data.health <= 0:
		level.goto_manin_menu()


func _on_binds():
	var player_data := GlobalVar.get_single_player_data()
	player_data.health_update.connect(_update_player_health)


func _ready() -> void:
	_update_player_health()
	_on_binds()
