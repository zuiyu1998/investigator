class_name SceneManager
extends Node2D

var _next_scene: String
var _loading = false

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var texture_progress_bar: TextureProgressBar = $CanvasLayer/HBoxContainer/TextureProgressBar


func _ready() -> void:
	texture_progress_bar.value = 0.0


func change_scene(next_scene: String):
	canvas_layer.visible = true
	_next_scene = next_scene
	ResourceLoader.load_threaded_request(_next_scene)
	_loading = true


func _process(delta: float) -> void:
	if not _loading:
		return

	var progress = []
	var state = ResourceLoader.load_threaded_get_status(_next_scene, progress)

	if state == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		texture_progress_bar.value = 1
		var packed_next_scene = ResourceLoader.load_threaded_get(_next_scene)
		get_tree().change_scene_to_packed(packed_next_scene)
		_loading = false
		canvas_layer.visible = false
	else:
		texture_progress_bar.value = lerp(texture_progress_bar.value, progress[0], delta * 3)
