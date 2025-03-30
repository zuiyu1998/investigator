extends TextureProgressBar

@export var level: Level

@onready var player_health_float_text_source: Marker2D = $PlayerHealthFloatTextSource


func on_health_update(update: int):
	var float_text = GlobalVar.get_single_float_text()
	if update > 0:
		float_text.display_text(player_health_float_text_source.global_position, update, "#B20000")
	else:
		float_text.display_text(player_health_float_text_source.global_position, update, "#ffffff")

	_update_player_health()


func _update_player_health():
	var player_data := GlobalVar.get_single_player_data()
	value = player_data.get_health_percent()

	if player_data.health <= 0:
		level.goto_manin_menu()


func _on_binds():
	var player_data := GlobalVar.get_single_player_data()
	player_data.health_update.connect(on_health_update)


func _ready() -> void:
	_update_player_health()
	_on_binds()
