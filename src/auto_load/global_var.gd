class_name GlobalVar
extends RefCounted


static func get_single_player_data() -> PlayerData:
	return PLAYER_DATA


static func get_single_scene_manager() -> SceneManager:
	return SCENE_MANAGER


static func get_single_game_state_manager() -> GameStateManager:
	return GAME_STATE_MANAGER


static func get_single_piece_tootip() -> PieceTooltip:
	return PIECE_TOOLTIP


static func get_single_float_text() -> FloatText:
	return FLOAT_TEXT
