extends Enemy

@onready var health_ui: TextureProgressBar = $HealthUi


func on_damage(damage: Damage):
	super.on_damage(damage)
	health_ui.value = health / max_health


func _ready() -> void:
	health_ui.value = 1
