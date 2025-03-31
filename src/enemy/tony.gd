extends Enemy

@onready var label: Label = $HBoxContainer/Label


func _update_label():
	label.text = "%s/%s" % [self.health, self.max_health]


func on_damage(damage: Damage):
	super.on_damage(damage)
	_update_label()

	if self.health <= 0:
		var game_state_manager = GlobalVar.get_single_game_state_manager()
		game_state_manager.goto_game_end()


func _ready() -> void:
	_update_label()
