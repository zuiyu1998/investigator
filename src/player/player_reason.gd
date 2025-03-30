extends TextureProgressBar

@export var level: Level

@onready var player_reason_float_text_source: Marker2D = $PlayerReasonFloatTextSource


func on_reason_update(update: int):
	var float_text = GlobalVar.get_single_float_text()
	if update > 0:
		float_text.display_text(player_reason_float_text_source.global_position, update, "#B22000")
	else:
		float_text.display_text(player_reason_float_text_source.global_position, update, "#ffffff")

	_update_reason_health()


func _update_reason_health():
	var player_data := GlobalVar.get_single_player_data()
	value = player_data.get_reason_percent()

	if player_data.reason <= 0:
		level.goto_manin_menu()


func _on_binds():
	var player_data := GlobalVar.get_single_player_data()
	player_data.reason_update.connect(on_reason_update)


func _ready() -> void:
	_update_reason_health()
	_on_binds()
