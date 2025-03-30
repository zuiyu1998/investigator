class_name GlobalVar
extends RefCounted


static func get_single_player_data() -> PlayerData:
	return PLAYER_DATA


static func get_single_scene_manager() -> SceneManager:
	return SCENE_MANAGER


static func get_single_game_state_manager() -> GameStateManager:
	return GAME_STATE_MANAGER
