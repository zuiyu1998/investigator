extends HBoxContainer

@export var level: Level

@onready var player_health_progress: TextureProgressBar = $PlayerHealthProgress
@onready
var player_health_float_text_source: Marker2D = $PlayerHealthProgress/PlayerHealthFloatTextSource
@onready var player_health_label: Label = $PlayerHealthLabel


func on_health_update(update: int):
	var float_text = GlobalVar.get_single_float_text()
	if update > 0:
		float_text.display_text(player_health_float_text_source.global_position, update, "#B20000")
	else:
		float_text.display_text(player_health_float_text_source.global_position, update, "#ffffff")

	_update_player_health()


func _update_player_health():
	var player_data := GlobalVar.get_single_player_data()
	player_health_progress.value = player_data.get_health_percent()

	player_health_label.text = "%s/%s" % [player_data.health, player_data.max_health]

	if player_data.health <= 0:
		level.goto_game_end()


func _on_binds():
	var player_data := GlobalVar.get_single_player_data()
	player_data.health_update.connect(on_health_update)


func _ready() -> void:
	_update_player_health()
	_on_binds()
